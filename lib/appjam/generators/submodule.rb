require File.dirname(__FILE__) + '/jam'

module Appjam
  module Generators
    class Submodule < Jam

      # Add this generator to our appjam
      Appjam::Generators.add_generator(:submodule, self)

      # Define the source submodule root
      def self.source_root; File.expand_path(File.dirname(__FILE__)); end
      def self.banner; "appjam submodule [name]"; end

      # Include related modules
      include Thor::Actions
      include Appjam::Generators::Actions            

      desc "Description:\n\n\tappjam will generates an new PureMvc Model for iphone"

      argument :name, :desc => "The name of your puremvc submodule"

      class_option :root, :desc => "The root destination", :aliases => '-r', :default => ".", :type => :string
      class_option :destroy, :aliases => '-d', :default => false,   :type    => :boolean

      def in_app_root?
        File.exist?('Classes')
      end     

      def create_submodule
        valid_constant?(options[:submodule] || name)
        @submodule_name = (options[:app] || name).gsub(/W/, "_").downcase
        @xcode_project_name = File.basename(Dir.glob('*.xcodeproj')[0],'.xcodeproj').downcase          
        @class_name = (options[:app] || name).gsub(/W/, "_").capitalize
        @developer = "eiffel"
        @created_on = Date.today.to_s
        self.destination_root = options[:root]
        
        if which('hg') != nil
          if in_app_root?
            if @submodule_name == 'kissxml'
              eval(File.read(__FILE__) =~ /^__END__\n/ && $' || '')  

              system "rm -rf kissxml"
              system "hg clone https://kissxml.googlecode.com/hg/ kissxml"
              system "git add ."
              system "git commit -m 'import kissxml submodule'"
              say (<<-TEXT).gsub(/ {10}/,'')

              =================================================================
              kissxml submodule has been imported

              Open #{@xcode_project_name.capitalize}.xcodeproj
              Add "kissxml" folder to the "Other Sources" Group
              Build and Run
              =================================================================
              TEXT
            else
              unless %w(three20 sihttp json-framework kissxml).include?(@submodule_name)
                say "="*70
                say "Only support three20,asihttp,json-framework,kissxml submodule now!"
                say "="*70
              end            
            end
          else
            puts
            puts '-'*70
            puts "You are not in an iphone project folder"
            puts '-'*70
            puts            
          end
        else
          say "="*70
          say "Mercurial was not installed!! check http://mercurial.selenic.com/ for installation."
          say "="*70          
        end        
        
        if which('git') != nil
          if in_app_root? 
            if @submodule_name == 'three20'
                
            eval(File.read(__FILE__) =~ /^__END__\n/ && $' || '')  
                 
            system "rm -rf three20"
            system "git submodule add git://github.com/facebook/three20.git three20"
            system "git add ."
            system "git commit -m 'import three20 submodule'"
            
            say (<<-TEXT).gsub(/ {10}/,'')

            =================================================================
            Three20 submodule has been imported

            Open #{@xcode_project_name.capitalize}.xcodeproj
            Add "three20/src/Three20/Three20.xcodeproj" folder to the "Other Sources" Group
            Add "three20/src/Three20.bundle" folder to the "Other Sources" Group
            Build and Run
            =================================================================
            TEXT
            elsif @submodule_name == 'asihttp'
              eval(File.read(__FILE__) =~ /^__END__\n/ && $' || '')  

              system "rm -rf asihttp"
              system "git submodule add git://github.com/pokeb/asi-http-request.git asihttp"
              system "git add ."
              system "git commit -m 'import asihttp submodule'"

              say (<<-TEXT).gsub(/ {10}/,'')

              =================================================================
              Asihttp submodule has been imported

              Open #{@xcode_project_name.capitalize}.xcodeproj
              Add "asihttp" folder to the "Other Sources" Group
              Build and Run
              =================================================================
              TEXT
            elsif @submodule_name == 'json'
              eval(File.read(__FILE__) =~ /^__END__\n/ && $' || '')  

              system "rm -rf json-framework"
              system "git submodule add git://github.com/stig/json-framework json-framework"
              system "git add ."
              system "git commit -m 'import json-framework submodule'"      
              say (<<-TEXT).gsub(/ {10}/,'')

              =================================================================
              json-framework submodule has been imported

              Open #{@xcode_project_name.capitalize}.xcodeproj
              Add "json-framework" folder to the "Other Sources" Group
              Build and Run
              =================================================================
              TEXT
            else
              unless %w(three20 sihttp json-framework kissxml).include?(@submodule_name)
                say "="*70
                say "Only support three20,asihttp,json-framework,kissxml submodule now!"
                say "="*70
              end
            end
          else
            puts
            puts '-'*70
            puts "You are not in an iphone project folder"
            puts '-'*70
            puts          
          end
        else
          say "="*70
          say "Git was not installed!! check http://git-scm.com/ for installation."
          say "="*70          
        end
      end

    end # Submodule
  end # Generators
end # Appjam

__END__
unless File.exist?("./.git")
system "git init"
template "submodule/gitignore.tt", "./.gitignore"
system "git add ."
system "git commit -m 'init commit'"
end


