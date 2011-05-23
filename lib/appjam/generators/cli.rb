require 'rubygems'
require 'cli-colorize'
require 'thor/group'
require 'hirb'
require File.dirname(__FILE__) + '/../view'

module Appjam
  module Generators
    ##
    # This class bootstrap +config/boot+ and perform +Appjam::Generators.load_components!+ for handle
    # 3rd party generators
    #
    class Cli < Thor::Group
      include CLIColorize
      
      CLIColorize.default_color = :red
      
      RENDER_OPTIONS = { :fields => [:category,:command,:description] }   
      # Include related modules
      include Thor::Actions

      class_option :root, :desc => "The root destination", :aliases => '-r', :default => ".", :type => :string

      # We need to TRY to load boot because some of our app dependencies maybe have
      # custom generators, so is necessary know who are.
      def load_boot
        begin
          ENV['BUNDLE_GEMFILE'] = File.join(options[:root], "Gemfile") if options[:root]
        rescue Exception => e
          puts "=> Problem loading #{boot}"
          puts ["=> #{e.message}", *e.backtrace].join("\n  ")
        end
      end

      def setup
        Appjam::Generators.load_components!

        generator_kind  = ARGV.delete_at(0).to_s.downcase.to_sym if ARGV[0].present?
        generator_class = Appjam::Generators.mappings[generator_kind]

        if generator_class
          args = ARGV.empty? && generator_class.require_arguments? ? ["-h"] : ARGV
          generator_class.start(args)
        else
          puts colorize("Usage: appjam [OPTIONS] [ARGS]")
          puts
          puts colorize("Project Options")
          opt = [{ :category => "objective c (iphone)", :command => "appjam project todo", :description => "generate iphone project skeleton"},
                 { :category => "objective c (iphone)", :command => "appjam model user",   :description => "generate iphone project data model"}
                 ] 
          View.render(opt, RENDER_OPTIONS)
          puts
          puts colorize("Submodule Options")
          puts          
          opt = [
           { :category => "objective c (iphone)", :command => "appjam submodule three20",   :description => "fetch three20 subproject from github.com"},
           { :category => "objective c (iphone)", :command => "appjam submodule asihttp",   :description => "fetch asi-http-request subproject from github.com"},
           { :category => "objective c (iphone)", :command => "appjam submodule json",   :description => "fetch json-framework subproject from github.com"},
           { :category => "objective c (iphone)", :command => "appjam submodule kissxml",   :description => "fetch kissxml subproject from code.google.com"}]
          View.render(opt, RENDER_OPTIONS)
          puts 
          puts colorize("Gist Options")
          require 'yaml'
          g = YAML.load_file(File.expand_path(File.dirname(__FILE__) + '/gist.yml'))   
          
          g.each_pair {|key,value|
            gitopt = []   
            puts 
            puts colorize("Gist #{key} Options")            
            g[key].each { |k|
              k.each_pair { |k1,v1|
                gitopt << {:category => "#{key.gsub('_',' ')}", :command => "appjam gist #{k1}",   :description => "#{k[k1][2]['description']}" }
              }
            }
            View.render(gitopt, RENDER_OPTIONS) 
          }          
          puts
        end
      end
    end # Cli
  end # Generators
end # Appjam