require 'rubygems'
require '../lib/app-jam/version.rb'

if %w(-v --version).include? ARGV.first
  puts "#{File.basename($0)} #{AppJam::VERSION}"
  exit(0)
end
