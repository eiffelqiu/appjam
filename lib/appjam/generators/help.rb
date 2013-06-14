require 'rubygems'
require 'cli-colorize'
require 'thor/group'
require 'hirb'
require File.dirname(__FILE__) + '/../view'
require File.dirname(__FILE__) + '/jam'

module Appjam
  module Generators
    class Help < Jam
      include CLIColorize
      
      CLIColorize.default_color = :red
      RENDER_OPTIONS = { :fields => [:category,:command,:description] }   
            
      # Add this generator to our appjam
      Appjam::Generators.add_generator(:help, self)

      # Define the source root
      def self.source_root; File.expand_path(File.dirname(__FILE__)); end
      def self.banner; "appjam help"; end

      # Include related modules
      include Thor::Actions
      include Appjam::Generators::Actions            

      desc "Description:\n\n\tappjam help screen" 
      argument :name, :default => ""
      
      def create_help
        @developer = "eiffel"
        @created_on = Date.today.to_s
        puts colorize( "Appjam Version: #{Appjam::Version::STRING}", { :foreground => :red, :background => :white, :config => :underline } )
        puts
        puts "Appjam is an iOS code repository, including framework, snippet, generators, etc."
        puts  
        require 'yaml'
        gistfile = File.expand_path("~") + '/.appjam/gist.yml'
        Gist::update_gist unless File.exist?(gistfile)          
        begin 
          g = YAML.load_file(gistfile)  
        rescue ArgumentError => e
          g = YAML.load_file(File.expand_path(File.dirname(__FILE__) + '/gist.yml'))
        end
        puts "notice: a new version '#{g['info']}' released" if g['info'] and g['info'].strip != "#{Appjam::Version::STRING}"
        puts                      
        puts colorize("Generator Options")
        opt = [
              { :category => "generator", :command => "appjam start demo",  :description => "generate a starter ARC iOS project with most popular frameworks included"},
              { :category => "puremvc", :command => "appjam mvc_project todo", :description => "generate puremvc iOS project"},
              { :category => "puremvc", :command => "appjam mvc_model user",   :description => "generate puremvc model"}
             ] 
        View.render(opt, RENDER_OPTIONS)
        puts    
        g.each_pair {|key,value|
          gitopt = []   
          gname = key.downcase.gsub('_',' ')
          puts 
          if gname == 'lib'
            puts colorize("Framework Lib")   
          else
            puts colorize("Gist Category [#{gname}]") unless gname == 'info'  
          end 
          unless gname == 'info'       
            g[key].each { |k|
              k.each_pair { |k1,v1|
                if gname == 'lib'
                  gitopt << {:category => "#{key.gsub('_',' ')}", :command => "appjam lib #{k1}",   :description => "#{k[k1][2]['description']}" }
                else
                  gitopt << {:category => "#{key.gsub('_',' ')}", :command => "appjam gist #{k1}",   :description => "#{k[k1][2]['description']}" }
                end
              }
            }
          end
          View.render(gitopt, RENDER_OPTIONS) unless gname == 'info' 
        }          
        puts  
      end

    end # Search
  end # Generators
end # Appjam

