TEMPLATE = (<<-TEMPLATE)
require 'thor'
require 'thor/group'
require 'thor/actions'
require 'active_support/core_ext/string'
require 'active_support/inflector'
require File.dirname(__FILE__) + '/actions'
require 'date' 

module Appjam
  module Generators
    class Template < Thor::Group

      # Add this generator to our appjam
      Appjam::Generators.add_generator(:template, self)

      # Define the source template root
      def self.source_root; File.expand_path(File.dirname(__FILE__)); end
      def self.banner; "appjam template [name]"; end

      # Include related modules
      include Thor::Actions
      include Appjam::Generators::Actions            

      desc "Description:\\n\\n\\tappjam will generates an new PureMvc Model for iphone"

      argument :name, :desc => "The name of your puremvc model"

      class_option :root, :desc => "The root destination", :aliases => '-r', :default => ".", :type => :string
      class_option :destroy, :aliases => '-d', :default => false,   :type    => :boolean
    
      def in_app_root?
        File.exist?('Classes')
      end     

      def create_app
        if in_app_root?
          
say (<<-TEXT).gsub(/ {10}/,'')

=================================================================
Your template has been generated.
=================================================================

TEXT          
        end
      end
    end # Template
  end # Generators
end # Appjam
TEMPLATE

namespace :appjam do
  namespace :plugin do

    desc 'Create an plugin structure for appjam'
    task :create  do
      puts "what's your plugin name?"
      pname = STDIN.gets.chomp
      plugin_dir = File.dirname(__FILE__) + "/../generators/#{pname}"
      plugin_name = File.dirname(__FILE__) + "/../generators/#{pname}.rb"
      Dir.mkdir plugin_dir unless File.exist?(plugin_dir)
      File.open(plugin_name, 'w') {|f| f.write(TEMPLATE) }  
    end

  end # plugin
end # appjam
