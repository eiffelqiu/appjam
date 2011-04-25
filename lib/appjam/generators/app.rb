require 'thor'
require 'thor/group'
require 'thor/actions'
require 'active_support/core_ext/string'

module Appjam
  module Generators
    class App < Thor::Group

      # Add this generator to our appjam
      Appjam::Generators.add_generator(:app, self)

      # Define the source template root
      def self.source_root; File.expand_path(File.dirname(__FILE__)); end
      def self.banner; "appjam project [name]"; end

      # Include related modules
      include Thor::Actions

      desc "Description:\n\n\tappjam app generates a new PureMvc application for iphone"

      argument :name, :desc => "The name of your puremvc application"

      class_option :root, :desc => "The root destination", :aliases => '-r', :default => ".", :type => :string
      class_option :destroy, :aliases => '-d', :default => false,   :type    => :boolean

      # Show help if no argv given
      #require_arguments!
    
      def in_app_root?
        File.exist?('Classes')
      end     

      def create_app
        self.destination_root = options[:root]
        @class_name = name.gsub(/\W/, "_").capitalize #.underscore.classify
        if in_app_root?
          # directory("Classes/", destination_root(name))
          app = options[:app]
          self.behavior = :revoke if options[:destroy]

          #return if self.behavior == :revoke
          template "ApplicationFacade.h.tt", "Classes/ApplicationFacade.h" 
          template "ApplicationFacade.m.tt", "Classes/ApplicationFacade.m" 
          empty_directory "Classes/controllers"
          empty_directory "Classes/models" 
          empty_directory "Classes/models/enum" 
          empty_directory "Classes/models/vo"
          empty_directory "Classes/views" 
          empty_directory "Classes/views/components"
          empty_directory "Classes/utils"

          copy_file "utils/NSStringWhiteSpace.h", "Classes/utils/NSStringWhiteSpace.h"
          copy_file "utils/NSStringWhiteSpace.m", "Classes/utils/NSStringWhiteSpace.m"   
          copy_file "utils/UIDevice.h", "Classes/utils/UIDevice.h"  
          copy_file "utils/UIDevice.m", "Classes/utils/UIDevice.m" 
          copy_file "utils/URLEncodeString.h", "Classes/utils/URLEncodeString.h"  
          copy_file "utils/URLEncodeString.m", "Classes/utils/URLEncodeString.m"    
          say (<<-TEXT).gsub(/ {10}/,'')

          =================================================================
          Your #{@class_name} application has been generated.
          =================================================================

          TEXT
        else
          say "You are not at the root of a iPhone application!" and exit unless in_app_root?
        end
      end
    end # App
  end # Generators
end # IphoneMvc