require 'thor'
require 'thor/group'
require 'thor/actions'
require 'active_support/core_ext/string'
require 'active_support/inflector'
require File.dirname(__FILE__) + '/actions'
require File.dirname(__FILE__) + '/jam'
require 'date' 

module Appjam
  module Generators
    class Project < Jam

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

      def in_app_root?
        File.exist?('Classes')
      end     

      def create_app
        valid_constant?(options[:project] || name)
        @project_name = (options[:app] || name).gsub(/\W/, "_").downcase
        @class_name = (options[:app] || name).gsub(/\W/, "_").capitalize
        @developer = "#{`whoami`.strip}"
        @created_on = Date.today.to_s
        self.destination_root = options[:root]
        project = options[:project]
        self.behavior = :revoke if options[:destroy]
        
        empty_directory "#{@project_name}"
        template "project/Contacts_Prefix.pch.tt", "#{@project_name}/#{@class_name}_Prefix.pch"
        template "project/Contacts-Info.plist.tt", "#{@project_name}/#{@class_name}-Info.plist"
        directory "project/Contacts.xcodeproj", "#{@project_name}/#{@class_name}.xcodeproj"
        fileName = "#{options[:root]}/#{@project_name}/#{@class_name}.xcodeproj/project.pbxproj"
        aFile = File.open(fileName, "r")
        aString = aFile.read
        aFile.close

        aString.gsub!('contacts', "#{@project_name}")
        aString.gsub!('User', "#{@class_name}")
        aString.gsub!('Contacts', "#{@class_name}")
        aString.gsub!('Contact', "#{@class_name}")
        File.open(fileName, "w") { |file| file << aString }
        
        system "mv #{options[:root]}/#{@project_name}/#{@class_name}.xcodeproj/eiffel.pbxuser #{options[:root]}/#{@project_name}/#{@class_name}.xcodeproj/#{`whoami`.strip}.pbxuser"
        system "mv #{options[:root]}/#{@project_name}/#{@class_name}.xcodeproj/eiffel.perspectivev3 #{options[:root]}/#{@project_name}/#{@class_name}.xcodeproj/#{`whoami`.strip}.perspectivev3"
        
        template "project/main.m.tt", "#{@project_name}/main.m"
        
        empty_directory "#{@project_name}/Classes/utils"

        copy_file "project/utils/NSStringWhiteSpace.h", "#{@project_name}/Classes/utils/NSStringWhiteSpace.h"
        copy_file "project/utils/NSStringWhiteSpace.m", "#{@project_name}/Classes/utils/NSStringWhiteSpace.m"   
        copy_file "project/utils/UIDevice.h", "#{@project_name}/Classes/utils/UIDevice.h"  
        copy_file "project/utils/UIDevice.m", "#{@project_name}/Classes/utils/UIDevice.m" 
        copy_file "project/utils/URLEncodeString.h", "#{@project_name}/Classes/utils/URLEncodeString.h"  
        copy_file "project/utils/URLEncodeString.m", "#{@project_name}/Classes/utils/URLEncodeString.m"
        
        directory "project/Classes/org", "#{@project_name}/Classes/org"
        
        template "project/Classes/ContactsAppDelegate.h.tt" , "#{@project_name}/Classes/#{@class_name}AppDelegate.h"
        template "project/Classes/ContactsAppDelegate.m.tt" , "#{@project_name}/Classes/#{@class_name}AppDelegate.m"
        template "project/Classes/contacts/ApplicationFacade.h.tt" , "#{@project_name}/Classes/#{@project_name}/ApplicationFacade.h"
        template "project/Classes/contacts/ApplicationFacade.m.tt" , "#{@project_name}/Classes/#{@project_name}/ApplicationFacade.m"
        template "project/Classes/contacts/controller/CreateUserCommand.h.tt" , "#{@project_name}/Classes/#{@project_name}/controller/Create#{@class_name}Command.h"
        template "project/Classes/contacts/controller/CreateUserCommand.m.tt" , "#{@project_name}/Classes/#{@project_name}/controller/Create#{@class_name}Command.m"
        template "project/Classes/contacts/controller/DeleteUserCommand.h.tt" , "#{@project_name}/Classes/#{@project_name}/controller/Delete#{@class_name}Command.h"
        template "project/Classes/contacts/controller/DeleteUserCommand.m.tt" , "#{@project_name}/Classes/#{@project_name}/controller/Delete#{@class_name}Command.m"
        template "project/Classes/contacts/controller/GetUsersCommand.h.tt" , "#{@project_name}/Classes/#{@project_name}/controller/Get#{@class_name}sCommand.h"
        template "project/Classes/contacts/controller/GetUsersCommand.m.tt" , "#{@project_name}/Classes/#{@project_name}/controller/Get#{@class_name}sCommand.m"
        template "project/Classes/contacts/controller/StartupCommand.h.tt" , "#{@project_name}/Classes/#{@project_name}/controller/StartupCommand.h"
        template "project/Classes/contacts/controller/StartupCommand.m.tt" , "#{@project_name}/Classes/#{@project_name}/controller/StartupCommand.m"
        template "project/Classes/contacts/controller/UpdateUserCommand.h.tt" , "#{@project_name}/Classes/#{@project_name}/controller/Update#{@class_name}Command.h"
        template "project/Classes/contacts/controller/UpdateUserCommand.m.tt" , "#{@project_name}/Classes/#{@project_name}/controller/Update#{@class_name}Command.m"
        template "project/Classes/contacts/model/UserProxy.h.tt" , "#{@project_name}/Classes/#{@project_name}/model/#{@class_name}Proxy.h"
        template "project/Classes/contacts/model/UserProxy.m.tt" , "#{@project_name}/Classes/#{@project_name}/model/#{@class_name}Proxy.m"
        template "project/Classes/contacts/model/vo/UserVO.h.tt" , "#{@project_name}/Classes/#{@project_name}/model/vo/#{@class_name}VO.h"
        template "project/Classes/contacts/model/vo/UserVO.m.tt" , "#{@project_name}/Classes/#{@project_name}/model/vo/#{@class_name}VO.m"
        template "project/Classes/contacts/view/UserMediator.h.tt" , "#{@project_name}/Classes/#{@project_name}/view/#{@class_name}Mediator.h"
        template "project/Classes/contacts/view/UserMediator.m.tt" , "#{@project_name}/Classes/#{@project_name}/view/#{@class_name}Mediator.m"
        template "project/Classes/contacts/view/UserFormMediator.h.tt" , "#{@project_name}/Classes/#{@project_name}/view/#{@class_name}FormMediator.h"
        template "project/Classes/contacts/view/UserFormMediator.m.tt" , "#{@project_name}/Classes/#{@project_name}/view/#{@class_name}FormMediator.m"
        template "project/Classes/contacts/view/UserListMediator.h.tt" , "#{@project_name}/Classes/#{@project_name}/view/#{@class_name}ListMediator.h"
        template "project/Classes/contacts/view/UserListMediator.m.tt" , "#{@project_name}/Classes/#{@project_name}/view/#{@class_name}ListMediator.m"
        template "project/Classes/contacts/view/components/Contacts.h.tt" , "#{@project_name}/Classes/#{@project_name}/view/components/#{@class_name}.h"
        template "project/Classes/contacts/view/components/Contacts.m.tt" , "#{@project_name}/Classes/#{@project_name}/view/components/#{@class_name}.m"
        template "project/Classes/contacts/view/components/UserForm.h.tt" , "#{@project_name}/Classes/#{@project_name}/view/components/#{@class_name}Form.h"
        template "project/Classes/contacts/view/components/UserForm.m.tt" , "#{@project_name}/Classes/#{@project_name}/view/components/#{@class_name}Form.m"
        template "project/Classes/contacts/view/components/UserList.h.tt" , "#{@project_name}/Classes/#{@project_name}/view/components/#{@class_name}List.h"
        template "project/Classes/contacts/view/components/UserList.m.tt" , "#{@project_name}/Classes/#{@project_name}/view/components/#{@class_name}List.m"

        

        say (<<-TEXT).gsub(/ {10}/,'')
      
      =================================================================
      Your #{@project_name} application has been generated.
      Open #{@project_name.capitalize}.xcodeproj
      Build and Run
      =================================================================
      
      TEXT
      end
    end # Project
  end # Generators
end # Appjam