require 'thor'
require 'thor/group'
require 'thor/actions'
require 'active_support/core_ext/string'
require File.dirname(__FILE__) + '/actions'

module Appjam
  module Generators
    class Project < Thor::Group

      # Add this generator to our appjam
      Appjam::Generators.add_generator(:project, self)

      # Define the source template root
      def self.source_root; File.expand_path(File.dirname(__FILE__)); end
      def self.banner; "appjam project [name]"; end

      # Include related modules
      include Thor::Actions
      include Appjam::Generators::Actions      

      desc "Description:\n\n\tappjam will generates an new PureMvc application for iphone"

      argument :name, :desc => "The name of your puremvc application"

      class_option :root, :desc => "The root destination", :aliases => '-r', :default => ".", :type => :string
      class_option :destroy, :aliases => '-d', :default => false,   :type    => :boolean

      # Show help if no argv given
      #require_arguments!
    
      def in_app_root?
        File.exist?('Classes')
      end     

      def create_app
        valid_constant?(options[:project] || name)
        @project_name = (options[:app] || name).gsub(/\W/, "_").downcase
        @class_name = name.gsub(/\W/, "_").capitalize 
        self.destination_root = options[:root]
        project = options[:project]
        self.behavior = :revoke if options[:destroy]
        
        empty_directory "#{@project_name}"
        template "project/Contacts_Prefix.pch.tt", "#{@project_name}/Contacts_Prefix.pch"
        template "project/Contacts-Info.plist.tt", "#{@project_name}/Contacts-Info.plist"
        directory "project/Contacts.xcodeproj", "#{@project_name}/Contacts.xcodeproj"
        template "project/main.m.tt", "#{@project_name}/main.m"
        
        empty_directory "#{@project_name}/Classes/utils"

        copy_file "project/utils/NSStringWhiteSpace.h", "#{@project_name}/Classes/utils/NSStringWhiteSpace.h"
        copy_file "project/utils/NSStringWhiteSpace.m", "#{@project_name}/Classes/utils/NSStringWhiteSpace.m"   
        copy_file "project/utils/UIDevice.h", "#{@project_name}/Classes/utils/UIDevice.h"  
        copy_file "project/utils/UIDevice.m", "#{@project_name}/Classes/utils/UIDevice.m" 
        copy_file "project/utils/URLEncodeString.h", "#{@project_name}/Classes/utils/URLEncodeString.h"  
        copy_file "project/utils/URLEncodeString.m", "#{@project_name}/Classes/utils/URLEncodeString.m"
        
        directory "project/Classes", "#{@project_name}/Classes"

        say (<<-TEXT).gsub(/ {10}/,'')
      
      =================================================================
      Your #{@class_name} application has been generated.
      =================================================================
      
      TEXT
      end
    end # Project
  end # Generators
end # Appjam