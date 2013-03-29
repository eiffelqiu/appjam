# encoding: utf-8
require 'rubygems'
require 'cli-colorize'
require 'hirb'
require File.dirname(__FILE__) + '/jam'
require File.dirname(__FILE__) + '/../view'

module Appjam
  module Generators
    class Blank < Jam
      include CLIColorize
      
      CLIColorize.default_color = :red
      author 'Eiffel Qiu'
      homepage 'http://www.likenote.com'
      email 'eiffelqiu@gmail.com'
      version Appjam::Version::STRING  

      # Add this generator to our appjam
      Appjam::Generators.add_generator(:blank, self)
  
      init_generator

      desc "Description:\n\n\tappjam will generates an new wax iOS application"

      argument :name, :desc => "The name of your full stack iOS application"

      class_option :root, :desc => "The root destination", :aliases => '-r', :default => ".", :type => :string
      class_option :destroy, :aliases => '-d', :default => false,   :type    => :boolean

      def create_project
        valid_constant?(options[:project] || name)
        @project_name = (options[:app] || name).gsub(/\W/, "_").downcase
        @class_name = (options[:app] || name).gsub(/\W/, "_").capitalize
        @developer = "#{`whoami`.strip}"
        @created_on = Date.today.to_s
        self.destination_root = options[:root]
        project = options[:project]
        self.behavior = :revoke if options[:destroy]
        
        puts colorize( "Appjam Version: #{Appjam::Version::STRING}", { :foreground => :red, :background => :white, :config => :underline } )
        puts        

        eval(File.read(__FILE__) =~ /^__END__\n/ && $' || '')       
        say (<<-TEXT).gsub(/ {10}/,'')
    
      =================================================================
      Your #{@project_name} full stack iOS application has been generated.
      Open #{@project_name}.xcodeproj
      Build and Run
      =================================================================
    
      TEXT
      end
    end # Project
  end # Generators
end # Appjam

__END__
empty_directory "#{@project_name}"

directory "templates/blank/EiffelApplication.xcodeproj", "#{@project_name}/#{@project_name}.xcodeproj"

fileName = "#{options[:root]}/#{@project_name}/#{@project_name}.xcodeproj/project.pbxproj"
aFile = File.open(fileName, "r")
aString = aFile.read
aFile.close
aString.gsub!('EiffelApplication', "#{@project_name}")
File.open(fileName, "w") { |file| file << aString }

fileName = "#{options[:root]}/#{@project_name}/#{@project_name}.xcodeproj/xcuserdata/swh.xcuserdatad/xcschemes/WaxApplication.xcscheme"
aFile = File.open(fileName, "r")
aString = aFile.read
aFile.close
aString.gsub!('EiffelApplication', "#{@project_name}")
File.open(fileName, "w") { |file| file << aString }

fileName = "#{options[:root]}/#{@project_name}/#{@project_name}.xcodeproj/xcuserdata/swh.xcuserdatad/xcschemes/xcschememanagement.plist"
aFile = File.open(fileName, "r")
aString = aFile.read
aFile.close
aString.gsub!('EiffelApplication', "#{@project_name}")
File.open(fileName, "w") { |file| file << aString }

fileName = "#{options[:root]}/#{@project_name}/#{@project_name}.xcodeproj/xcuserdata/swh.xcuserdatad/xcschemes/WaxApplication.xcscheme"
aFile = File.open(fileName, "r")
aString = aFile.read
aFile.close
aString.gsub!('EiffelApplication', "#{@project_name}")
File.open(fileName, "w") { |file| file << aString }

fileName = "#{options[:root]}/#{@project_name}/#{@project_name}.xcodeproj/project.xcworkspace/contents.xcworkspacedata"
aFile = File.open(fileName, "r")
aString = aFile.read
aFile.close
aString.gsub!('EiffelApplication', "#{@project_name}")
File.open(fileName, "w") { |file| file << aString }

fileName = "#{options[:root]}/#{@project_name}/#{@project_name}.xcodeproj/project.xcworkspace/xcuserdata/swh.xcuserdatad/UserInterfaceState.xcuserstate"
aFile = File.open(fileName, "r")
aString = aFile.read.unpack("C*").pack("U*")
aFile.close
aString.gsub!('EiffelApplication', "#{@project_name}")
File.open(fileName, "w") { |file| file << aString }

system "mv #{options[:root]}/#{@project_name}/#{@project_name}.xcodeproj/project.xcworkspace/xcuserdata/swh.xcuserdatad #{options[:root]}/#{@project_name}/#{@project_name}.xcodeproj/project.xcworkspace/xcuserdata/#{`whoami`.strip}.xcuserdatad" if `whoami`.strip != 'swh'

system "mv #{options[:root]}/#{@project_name}/#{@project_name}.xcodeproj/xcuserdata/swh.xcuserdatad #{options[:root]}/#{@project_name}/#{@project_name}.xcodeproj/xcuserdata/#{`whoami`.strip}.xcuserdatad" if `whoami`.strip != 'swh'

system "mv #{options[:root]}/#{@project_name}/#{@project_name}.xcodeproj/xcuserdata/#{`whoami`.strip}.xcuserdatad/xcschemes/WaxApplication.xcscheme #{options[:root]}/#{@project_name}/#{@project_name}.xcodeproj/xcuserdata/#{`whoami`.strip}.xcuserdatad/xcschemes/#{@project_name}.xcscheme" 

template "templates/blank/EiffelApplication/main.m.tt", "#{@project_name}/#{@project_name}/main.m"
template "templates/blank/EiffelApplication/AppDelegate.h.tt", "#{@project_name}/#{@project_name}/AppDelegate.h"
template "templates/blank/EiffelApplication/AppDelegate.m.tt", "#{@project_name}/#{@project_name}/AppDelegate.m"
directory "templates/blank/EiffelApplication/en.lproj", "#{@project_name}/#{@project_name}/en.lproj"

template "templates/blank/EiffelApplication/EiffelApplication-Info.plist.tt", "#{@project_name}/#{@project_name}/#{@project_name}-Info.plist"
template "templates/blank/EiffelApplication/EiffelApplication-Prefix.pch.tt", "#{@project_name}/#{@project_name}/#{@project_name}-Prefix.pch"

copy_file "templates/resources/Default-568h@2x.png", "#{@project_name}/#{@project_name}/Default-568h@2x.png"
copy_file "templates/resources/Default@2x.png", "#{@project_name}/#{@project_name}/Default@2x.png"
copy_file "templates/resources/Default.png", "#{@project_name}/#{@project_name}/Default.png"

