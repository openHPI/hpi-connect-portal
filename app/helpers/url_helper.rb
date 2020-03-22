module UrlHelper

  def url_with_protocol(url)
    /^http/.match(url) ? url : "http://#{url}"
  end
  def url_without_protocol(url)
  	/^http/.match(url) && /\/\//.match(url) ? url.slice(url.index("//")+2..-1) : url
  end
end