class MobileCache  
  def initialize options = {}
    @site_url = options[:url] ? options[:url] : MobileProxy::settings.site_web_url 
    @environment = options[:environment] ? options[:environment] : MobileProxy::settings.environment
    @redis_prefix = MobileProxy::settings.respond_to?(:redis_prefix) ? MobileProxy::settings.redis_prefix : "mobile:cache" 
    @redis_cache_lifetime = MobileProxy::settings.respond_to?(:redis_cache_lifetime) ? MobileProxy::settings.redis_cache_lifetime : 3600 #3600 seconds == 1hour
    @redis_host = MobileProxy::settings.respond_to?(:redis_host) ? MobileProxy::settings.redis_host : "localhost" 
    @redis_port = MobileProxy::settings.respond_to?(:redis_port) ? MobileProxy::settings.redis_port : 6379
    @redis_password = MobileProxy::settings.respond_to?(:redis_password) ? MobileProxy::settings.redis_password : nil
    flush if MobileProxy::settings.respond_to?(:flush_cache_on_load) and MobileProxy::settings.flush_cache_on_load === true
    insert_pages(MobileProxy::settings.static_pages) if MobileProxy::settings.respond_to? :static_pages
  end
  
  def redis_conn
    @@redis_conn ||= Redis.new(:host => @redis_host, :port => @redis_port, :password => @redis_password)
  end
  
  def redis_prefix
    @redis_prefix+":"+@environment.to_s
  end
 
  def page_key page
    redis_prefix+":page:"+page
  end
  
  def page_menu_titles_key page
    redis_prefix+":page:"+page+":titles"
  end
 
  def page_title_key page
    page_key page+":title"
  end
  
  def page_last_modified_key page
     page_key page+":modified"
  end
  
  def get_stylesheets
    stylesheet = redis_conn.get redis_prefix+":stylesheet"
    unless stylesheet
      stylesheet = ""
      Dir.glob("public/css/*.css") {|x| stylesheet << File.open(x, 'r') { |f| f.read }; stylesheet.gsub!(/[\n\t]/,"").gsub!(/\s\s/,"") if not_development? }
      redis_conn.set(redis_prefix+":stylesheet", stylesheet) if not_development?
    end
    stylesheet
  end
 
  def get_javascripts
    javascript = redis_conn.get redis_prefix+":javascript"
    unless javascript
      javascript = ""
      Dir.glob("public/js/*.js") {|x| javascript << "<script>"+File.open(x, 'r') { |f| f.read }+"</script>\n"; javascript.gsub!(/[\n\t]/,"").gsub!(/\s\s/,"") if not_development?}
      redis_conn.set(redis_prefix+":javascript", javascript) if not_development?
    end
    javascript
  end
 
 
  def not_development?
    not settings.environment == :development
  end
  
  def get page
    remote_page = RemotePage.new :url=>page, :site_url=>@site_url
    insert_into_cache remote_page if remote_page.status_code === 200
    return remote_page
  end
 
  def insert_into_cache page,expire=true
    redis_conn.set page_key(page.url), page.content
    redis_conn.set page_title_key(page.url), page.title
    redis_conn.set page_last_modified_key(page.url), page.last_modified
    if expire
      redis_conn.expire page_key(page.url),@redis_cache_lifetime
      redis_conn.expire page_title_key(page.url),@redis_cache_lifetime
      redis_conn.expire page_last_modified_key(page.url),@redis_cache_lifetime
    end
    update_cache_timestamp
    add_page_to_sitemap page.url
  end
  
  def create_and_insert_link_page options={}
    page = options[:page]
    key = page_key(page)
    titles_key = page_menu_titles_key(page)
    redis_conn.del key
    redis_conn.del titles_key
    options[:content].each do |link|
      redis_conn.rpush(key, link[:url])
      redis_conn.rpush(titles_key, link[:title])
    end
    redis_conn.set(page_title_key(page), options[:title])
    redis_conn.set(page_last_modified_key(page), Time.now.to_i)
  end
  
  def create_and_insert_text_page options={}
    page = options[:page]
    redis_conn.set(page_key(page), options[:content])
    redis_conn.set(page_title_key(page), options[:title])
    redis_conn.set(page_last_modified_key(page), Time.now.to_i)
  end
  
  def insert_pages pages
    pages.each do |page|
      add_page_to_sitemap page[:page]
      if page.is_a? Hash
        create_and_insert_link_page page
      else
        create_and_insert_text_page page
      end
    end
  end
  
  def update_cache_timestamp
    redis_conn.set redis_prefix+":timestamp", Time.now().to_i
  end
  
  def get_timestamp
    @cache_timestamp = redis_conn.get redis_prefix+":timestamp"
    unless @cache_timestamp
      update_cache_timestamp
      @cache_timestamp = redis_conn.get redis_prefix+":timestamp"
    end
    @cache_timestamp.to_i
  end
  
  def add_page_to_sitemap page
    redis_conn.sadd redis_prefix+":sitemap", page
  end
  
  def sitemap
    redis_conn.smembers redis_prefix+":sitemap"
  end
  
  def flush
    redis_conn.keys(redis_prefix+"*").each {|key| redis_conn.del key}
    insert_pages(MobileProxy::settings.static_pages) if MobileProxy::settings.respond_to? :static_pages
  end
end