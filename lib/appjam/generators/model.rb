require 'thor'
require 'thor/group'
require 'thor/actions'
require 'active_support/core_ext/string'

module Appjam
  module Generators
    class Model < Thor::Group

      # Add this generator to our appjam
      Appjam::Generators.add_generator(:model, self)

      # Define the source template root
      def self.source_root; File.expand_path(File.dirname(__FILE__)); end
      def self.banner; "appjam model [name]"; end

      # Include related modules
      include Thor::Actions

      desc "Description:\n\n\tappjam will generates an new PureMvc Model for iphone"

      argument :name, :desc => "The name of your puremvc model"

      class_option :root, :desc => "The root destination", :aliases => '-r', :default => ".", :type => :string
      class_option :destroy, :aliases => '-d', :default => false,   :type    => :boolean

      # Show help if no argv given
      #require_arguments!
    
      def in_app_root?
        File.exist?('Classes')
      end     

      def create_app
        self.destination_root = options[:root]
        @project_name = name.gsub(/\W/, "_").downcase
        @class_name = name.gsub(/\W/, "_").capitalize 
        app = options[:model]
        self.behavior = :revoke if options[:destroy]

        say (<<-TEXT).gsub(/ {10}/,'')
      
      =================================================================
      Your #{@class_name} Model app has been generated.
      =================================================================
      
      TEXT
      end
    end # Model
  end # Generators
end # Appjam