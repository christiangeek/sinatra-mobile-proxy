sinatra-mobile-proxy
===========

A example sinatra application to demonstrate the use of a mobile proxy to access existing websites.

Description
-------------
A sinatra application that serves as a proxy and cache for mobile browsers. The content is cached in redis and served by sinatra. Supports HTTP cache headers, and compression on the Rack handler side. Supports different cache backend such as scraping or tied to a current database.

Rationale
-------------
I was conducting some training on mobile websites recently and the majority of questions were along the lines of: "Should I serve a separate website or simply mobile aware Javascript and CSS?". While this question cannot be answered outright for every scenario, most of the time I would suggest that the mobile website be separate from your desktop website. The mobile website should offer all the content of the full website without all the jQuery/mooTools/CSS required by the desktop browsers.

Why use Mars Hill Church in the example?
-------------

1. A friend of mine uses a older blackberry that has trouble viewing the MHC website (06/11). Even on a iPhone 4 and slightly less on a iPad, the site is a bit hard to navigate. 
2. I am surprised that MHC does not have a mobile website, something I think every site should have, but I am sure that their reasons are good. They have a excellent native application but is solely for media and not info/content, so to fulfill #1 and to be a example for the future I customized some code I had written awhile back over a weekend for some penetration testing. The only part customized for Mars Hill is the `config.ru` file and the `public/css/style.css` file.

Notes
-------------
This is a example of lightweight mobile **website** not a mobile web *application*. For webkit browsers, it loads in some JavaScript and the Zepto framework. I would recommend looking at Sencha Touch or jQuery Mobile if you are looking to write a mobile web application. Both frameworks are excellent but a little too heavy for this use-case.

Testing  
-------------
This site has been tested under ruby 1.9.2 with unicorn, thin, webrick and passenger. For the front-end nginx was used and configured for static files and gzip compression. This application currently powers a couple different mobile websites residing in the dark corners of the net so not to dilute any brands. There are cucumber tests that can be run, I was too lazy to write unit tests.

Usage
-------------
Edit the `config.ru` file and the `public/css/style.css` file as you see fit. Please do not run it as is and make it public unless you have rights to proxy the content you are pointing it at. The cache can be flushed via rack options or rake.

Security
-------------
If you do not know the security implications of a mobile proxy, you probably should not run this on a public server.

Bugs/Todo
-------------
* The application manifest is a little funky.
* Use SASS for CSS for easy customization.

Disclaimer
-------------
I am not affiliated with Mars Hill Church in anyway and probably using this application as is (that is pointed at their web servers) violates their [Creative Commons Attribution-Noncommercial-No Derivative Works 3.0 United States License] (http://www.marshillchurch.org/about/media-faq) because it could be considered a derivative work. I only offer the URLs as a example and if you get banned by their IDS system (managed to trip my own during testing), that is your fault. 

License
-------------
This code is dual licensed under the 1 Thessalonians 2:8 and Matthew 10:8 licenses.

Questions?
-------------
[http://about.me/christiangeek] (http://about.me/christiangeek)