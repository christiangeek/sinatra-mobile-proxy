$:.unshift(File.dirname(__FILE__) + '/../../lib')
require 'cucumber/rake/task'

Cucumber::Rake::Task.new do |t|
  t.cucumber_opts = %w{--format pretty}
end

task :flush_mobile_cache do
   require File.dirname(__FILE__) + '/app'
   MobileCache.new(:url=> "", :environment => ENV['RACK_ENV'] ? ENV['RACK_ENV'] : "production").flush
end