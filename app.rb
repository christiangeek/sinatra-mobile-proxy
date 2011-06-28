# TODO 
# add first run DB init for production/development and for test

require "digest/md5"
require "open-uri"
require "bundler/setup"
Bundler.require(:app)
require File.dirname(__FILE__) + "/lib/remote_page"
require File.dirname(__FILE__) + "/lib/mobile_cache"

class MobileProxy < Sinatra::Base
  set :views, File.dirname(__FILE__) + '/views'
  set :public, File.dirname(__FILE__) + '/public'
  set (:profile) { |value| condition { Object.const_defined? :RubyProf } }
  set (:not_on_profile_page) { |value| condition { not request.path() == "/last_profile" } }
  
  def not_development?
    not settings.environment == :development
  end
  
  def cache
    @@cache ||= MobileCache.new()
  end

  def redis_conn
    cache.redis_conn
  end

  def page_key page
    cache.page_key page
  end

  def page_title_key page
    cache.page_title_key page
  end

  def page_last_modified_key page
    cache.page_last_modified_key page
  end
  
  def page_menu_titles_key page
    cache.page_menu_titles_key page
  end
  
  def stylesheet
    cache.get_stylesheets
  end

  def javascript
    cache.get_javascripts
  end

  def is_a_webkit_browser?
    /webkit/i =~ request.user_agent
  end

  def page_url
    request.path().gsub(".json","")
  end

  def page_url_cleaned_up options = {}
    options[:page_url] ||=  page_url 
    options[:page_url].gsub("/","---").gsub(".","----")
  end

  def get_page_type page
    redis_conn.type(page_key page)
  end

  def get_all_pages
    cache.sitemap
  end

  def get_all_pages_as_json
    cache.sitemap.map{|page| page+".json"}
  end

  def content options = {}
    options[:page] ||=  page_url
    page_type = get_page_type options[:page]
    if page_type == "list"
      get_links options[:page]
    elsif page_type == "string"
      get_text options[:page]
    else
      check_for_existence_or_inform_otherwise options[:page]
    end
  end

  def get_links page
    links = build_links_hash_from_redis page
    title = get_page_title page
    haml :menu, :layout => false, :locals =>{:links => links, :title=> title}
  end

  def build_links_hash_from_redis page
    links = []
    key = page_key page
    title_key = page_menu_titles_key page
    redis_conn.llen(key).to_i.times {|x| 
      links << {:url=>redis_conn.lindex(key, x), :title=>redis_conn.lindex(title_key, x)}
    }
    links
  end

  def get_text page
    text = redis_conn.get page_key(page)
    title = get_page_title page
    haml :text, :layout => false, :locals => {:text => text, :title => title}
  end

  def get_page_title page
    redis_conn.get page_title_key(page)
  end

  def get_page_last_modified page
    redis_conn.get page_last_modified_key(page)
  end

  def check_for_existence_or_inform_otherwise page
    cache_page = cache.get page
    if cache_page.status_code === 200
      content :page=>page
    elsif cache_page.status_code === 301
      redirect to(settings.site_web_url+page), 301
    else
      return_404
    end
  end

  def return_404
    status 404
    haml :fourohfour, :layout => false
  end

  before "*", :not_on_profile_page => true do
    RubyProf.start if Object.const_defined? :RubyProf
    expires(settings.http_cache_lifetime, :private, :must_revalidate) if settings.respond_to? :http_cache_lifetime
  end

  after "*", :not_on_profile_page => true do
    etag Digest::MD5.hexdigest(response.body) if response.body.is_a? String
    if Object.const_defined? :RubyProf
      last_profile_html = ""
      RubyProf::GraphHtmlPrinter.new(RubyProf.stop).print(last_profile_html, :min_percent=>0)
      redis_conn.set cache.redis_prefix+":last_profile_html", last_profile_html.to_s
    end 
  end

  get "/default.appcache" do
    content_type "text/cache-manifest"
    last_modified Time.at(cache.get_timestamp)
    body haml :cache_manifest, :ugly => true,  :layout => false
  end

  get "/last_profile", :profile => true do
    redis_conn.get cache.redis_prefix+":last_profile_html" 
  end

  get "*.json" do
    content_type "application/javascript"
    output = {}
    last_modified Time.at(get_page_last_modified(page_url).to_i)
    output[:body] = haml :page, :ugly => true, :format => :html5, :layout => false
    #output[:body] = haml :page, :ugly => true, :format => :html5, :layout => false, :locals => {:page_url_cleaned_up => page_url_cleaned_up(:page_url => page_url), :content => content(:page => page_url)}
    output[:body].gsub!(/[\n\t]/,"") if not_development?
    body output.to_json
  end

  get "*" do
    last_modified Time.at(get_page_last_modified(page_url).to_i)
    output = haml :inital_page, :ugly => true, :format => :html5
    output.gsub!(/[\n\t]/,"") if not_development?
    body output
  end
end