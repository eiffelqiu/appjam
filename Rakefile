# encoding: utf-8

require 'rubygems'
require 'bundler'
require 'rake'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end



# temp hacking for "undefined method `sh'" error in Rake task
class Object
  alias sh system
end

require './lib/appjam/version.rb'
require './lib/appjam/tasks.rb'

Appjam::Tasks.files.each  { |ext| load(ext) }

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "appjam"
  gem.homepage = "http://github.com/eiffelqiu/appjam"
  gem.license = "MIT"
  gem.summary = %Q{Appjam is an iOS code repository, including framework, snippet, generators, etc.}
  gem.description = %Q{Appjam is iOS code repository, including framework, snippet, generators, etc.}
  gem.email = "eiffelqiu@gmail.com"
  gem.authors = ["Eiffel Q"]
  gem.version = Appjam::Version::STRING
  gem.executables = ['appjam']
  gem.files = %w(LICENSE.txt README.md) + Dir.glob('lib/**/*.*') 
  gem.add_dependency 'activesupport', '>= 3.2.8'  
  gem.add_dependency 'grit'
  gem.add_dependency 'i18n'
  gem.add_dependency 'hirb'
  gem.add_dependency 'cli-colorize'
  gem.add_dependency 'rdoc'
  gem.add_dependency 'yajl-ruby'  
  gem.add_dependency 'plist' 
end
Jeweler::GemcutterTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

require 'rcov/rcovtask'
Rcov::RcovTask.new do |test|
  test.libs << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

task :default => :test

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "appjam #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
