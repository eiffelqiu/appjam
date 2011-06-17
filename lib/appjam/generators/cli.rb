require 'rubygems'
require 'thor/group'
require 'cli-colorize'
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
      desc "Appjam Version:\t#{Appjam::Version::STRING}"
      class_option :help, :desc => "Help screen", :aliases => '-h', :type => :string
      
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
          puts colorize( "Appjam Version: #{Appjam::Version::STRING}", { :foreground => :red, :background => :white, :config => :underline } )
          puts
          puts "Appjam is iOS code snippet hub, including framework, snippet, code, generators."
          puts          
          puts colorize("For more information:")
          puts
          puts "appjam help  # Help screen"
          puts
        end
      end
    end # Cli
  end # Generators
end # Appjam