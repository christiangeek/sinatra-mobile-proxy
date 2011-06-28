class RemotePage
  attr_reader :url, :status_code, :expires, :content_type, :last_modified
  
  def initialize options = {}
    @selector = MobileProxy::settings.respond_to?(:body_content_selector) ? MobileProxy::settings.body_content_selector : "body"
    @site_url = options[:site_url]
    @url = options[:url]
    @raw_content = ""
    begin
      open(@site_url+url,"User-Agent"=>"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_7) AppleWebKit/535.1 (KHTML, like Gecko) Chrome/13.0.782.13 Safari/535.1") do |f|
       @content_type = f.content_type
       @last_modified = f.last_modified
       if f.content_type == "text/html" or f.content_type == "text/xml" or f.content_type == "text/plain"
         f.each_line {|line| @raw_content << line}
         @status_code = 200
       else
         @status_code = 301
       end
      end
    rescue
      @status_code = 404 
    end
  end
  
  def content_as_a_object
    @content_as_a_object ||= Nokogiri::HTML(@raw_content)
    @content_as_a_object
  end
  
  def title
    if not @title and content_as_a_object.search("title").count > 0
      @title = content_as_a_object.search("title")[0].content
    elsif not @title
      @title = ""
    end
    @title
  end
  
  def content
    @content ||=nil
    unless @content
      content = content_as_a_object.search(@selector)
      @content = content[0]
    end
    @content
  end
   
end