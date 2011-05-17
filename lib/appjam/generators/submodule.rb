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

      def create_app
        if in_app_root?
          valid_constant?(options[:submodule] || name)
          @submodule_name = (options[:app] || name).gsub(/W/, "_").downcase
          @xcode_project_name = File.basename(Dir.glob('*.xcodeproj')[0],'.xcodeproj').downcase          
          @class_name = (options[:app] || name).gsub(/W/, "_").capitalize
          @developer = "eiffel"
          @created_on = Date.today.to_s
          self.destination_root = options[:root]
        
          if @submodule_name == 'three20'
                
          eval(File.read(__FILE__) =~ /^__END__\n/ && $' || '')       

          say (<<-TEXT).gsub(/ {10}/,'')

          =================================================================
          Three20 submodule has been imported

          Open #{@xcode_project_name.capitalize}.xcodeproj
          Add "three20/src/Three20/Three20.xcodeproj" folder to the "Other Sources" Group
          Add "three20/src/Three20.bundle" folder to the "Other Sources" Group
          Build and Run
          =================================================================
          TEXT
          else
            say "="*70
            say "Only support three20 submodule now!"
            say "="*70
          end
        else
          puts
          puts '-'*70
          puts "You are not in an iphone project folder"
          puts '-'*70
          puts          
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
system "rm -rf three20"
system "git submodule add git://github.com/facebook/three20.git three20"
system "git add ."
system "git commit -m 'import three20 submodule'"

