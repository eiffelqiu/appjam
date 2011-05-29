require 'rubygems'
require 'cli-colorize'
require 'thor/group'
require 'hirb'
require File.dirname(__FILE__) + '/../view'
require File.dirname(__FILE__) + '/jam'

module Appjam
  module Generators
    class Search < Jam
      include CLIColorize
      
      CLIColorize.default_color = :red
      RENDER_OPTIONS = { :fields => [:category,:command,:description] }   
            
      # Add this generator to our appjam
      Appjam::Generators.add_generator(:search, self)

      # Define the source root
      def self.source_root; File.expand_path(File.dirname(__FILE__)); end
      def self.banner; "appjam search [option]"; end

      # Include related modules
      include Thor::Actions
      include Appjam::Generators::Actions            

      desc "Description:\n\n\tappjam will search option"

      argument :name, :desc => "The name of option"

      class_option :root, :desc => "The root destination", :aliases => '-r', :default => ".", :type => :string
      class_option :destroy, :aliases => '-d', :default => false,   :type    => :boolean

      def in_app_root?
        File.exist?('Classes')
      end     

      def create_search
        valid_constant?(options[:search] || name)
        @gist_name = (options[:app] || name).gsub(/W/, "_").downcase
        @gist_class_name = (options[:app] || name).gsub(/W/, "_").capitalize
        @developer = "eiffel"
        @created_on = Date.today.to_s
        self.destination_root = options[:root]
        puts
        puts colorize("Available Options contains [#{@gist_name}]")
        puts
        require 'yaml'
        # begin
        #   page_source = Net::HTTP.get(URI.parse("http://eiffelqiu.github.com/appjam/gist.yml"))
        # rescue SocketError => e
        # end   
        # begin 
        #   g = YAML::load(page_source)  
        # rescue ArgumentError => e
        #   g = YAML.load_file(File.expand_path(File.dirname(__FILE__) + '/gist.yml'))
        # end
        gistfile = File.expand_path("~") + '/.appjam/gist.yml'
        Gist::update_gist unless File.exist?(gistfile)          
        begin 
          g = YAML.load_file(gistfile)  
        rescue ArgumentError => e
          g = YAML.load_file(File.expand_path(File.dirname(__FILE__) + '/gist.yml'))
        end        
        gitopt = []  
        g.each_pair {|key,value|
          # puts colorize("Gist Category [#{key.gsub('_',' ')}]")    
          gname = key.gsub('_',' ')        
          g[key].each { |k|
            k.each_pair { |k1,v1|
              gist_name = k1.downcase
              gist_desc = k[k1][2]['description'].downcase
              if gist_name.include?(@gist_name) or gist_desc.include?(@gist_name)
                # gitopt << {:category => "#{key.gsub('_',' ')}", :command => "appjam gist #{k1}",   :description => "#{k[k1][2]['description']}" }
                if gname == 'lib'
                  gitopt << {:category => "#{key.gsub('_',' ')}", :command => "appjam lib #{k1}",   :description => "#{k[k1][2]['description']}" }
                else
                  gitopt << {:category => "#{key.gsub('_',' ')}", :command => "appjam gist #{k1}",   :description => "#{k[k1][2]['description']}" }
                end              
              end
            }
          }
        } 
        View.render(gitopt, RENDER_OPTIONS)          
        puts     
      end

    end # Search
  end # Generators
end # Appjam

