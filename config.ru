ENV['RACK_ENV'] ||= 'production'
require File.dirname(__FILE__)+"/app.rb"

set :views, File.dirname(__FILE__) + '/views'
set :public, File.dirname(__FILE__) + '/public'

MobileProxy.set :site_name, "Mars Hill Church"
MobileProxy.set :site_web_url, "http://www.marshillchurch.org"
MobileProxy.set :site_not_mobile_url, "http://www.marshillchurch.org"
MobileProxy.set :site_logo_url, "/logo.png"
MobileProxy.set :site_logo_width, "250px"
MobileProxy.set :site_logo_height, "34px"
MobileProxy.set :http_cache_lifetime, 300 #300 seconds == 5minutes
MobileProxy.set :body_content_selector, "#pageContent"
MobileProxy.set :static_pages, [
{:page => "/", :title => nil, :content=>[
  {:title=>"I AM <strong>NEW HERE</strong>",:url=>"/newhere"},
  {:title=>"ABOUT MHC",:url=>"/about"},
  {:title=>"LOCATIONS & SERVICES",:url=>"/locations_and_services"},
  {:title=>"THE CITY",:url=>"http://marshill.onthecity.org"},
  {:title=>"COMMUNITY GROUPS",:url=>"/community_menu"},  
  {:title=>"<strong>GIVE</strong>",:url=>"https://www.marshillchurch.org/give"}
]},
{:page => "/newhere", :title => "I AM NEW HERE", :content=>[
  {:title=>"FIND A LOCATION",:url=>"/locations_and_services"},
  {:title=>"WHAT WE BELIEVE",:url=>"/about/what-we-believe"},
  {:title=>"GET CONNECTED",:url=>"/community"}
]},
{:page => "/about", :title => "ABOUT MHC", :content=>[
  {:title=>"Jesus",:url=>"/about/jesus"},
  {:title=>"The Gospel",:url=>"/about/the-gospel"},
  {:title=>"What We Believe",:url=>"/about/what-we-believe"},
  {:title=>"MHC Pastors",:url=>"/about/elders"},
  {:title=>"History",:url=>"/about/history"},
  {:title=>"Become a Member",:url=>"/about/become-a-member"},
  {:title=>"The City",:url=>"/about/about-the-city"},
  {:title=>"Ministries",:url=>"/about/ministries"},
  {:title=>"Job Opportunities",:url=>"/about/jobs"},
  {:title=>"Contact Us",:url=>"/about/contact-us"},
  {:title=>"FAQ",:url=>"/about/media-faq"},
  {:title=>"Website",:url=>"/about/website"}
]},
{:page => "/locations_and_services", :title => "LOCATIONS", :content=>[
  {:title=>"Albuquerque, NM",:url=>"/locations/albuquerque-nm"},
  {:title=>"Ballard, Seattle, WA",:url=>"http://ballard.marshillchurch.org/"},
  {:title=>"Bellevue, WA",:url=>"http://bellevue.marshillchurch.org/"},
  {:title=>"Downtown, Seattle, WA",:url=>"http://downtownseattle.marshillchurch.org/"},
  {:title=>"Federal Way, WA",:url=>"http://federalway.marshillchurch.org/"},
  {:title=>"Olympia, WA",:url=>"http://olympia.marshillchurch.org/"},
  {:title=>"Shoreline, WA",:url=>"http://shoreline.marshillchurch.org/"},
  {:title=>"U-District, WA",:url=>"http://udistrict.marshillchurch.org/"},
  {:title=>"West Seattle, WA",:url=>"http://westseattle.marshillchurch.org/"}
]},
{:page => "/locations/albuquerque-nm", :title => "Albuquerque, NM", :content=>[
    {:title=>"Website",:url=>"http://albuquerque.marshillchurch.org/"},
    {:title=>"Map/Directions",:url=>"http://maps.google.com/maps?q=3013%20Central%20Ave.%20NE,%20Albuquerque,%20NM%2087106"}
]},
{:page => "/community_menu", :title => "COMMUNITY GROUPS", :content=>[
  {:title=>"Introduction",:url=>"/community"},
  {:title=>"Foundation",:url=>"/community/foundation"},
  {:title=>"Vision",:url=>"/community/vision"},
  {:title=>"Elements",:url=>"/community/elements"},
  {:title=>"Organization",:url=>"/community/organization"},
  {:title=>"Training",:url=>"/community/training"},
  {:title=>"Resources",:url=>"/community/resources"}
]}]

run MobileProxy