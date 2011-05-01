require 'thor/group'

module Appjam
  module Generators
    ##
    # This class bootstrap +config/boot+ and perform +Appjam::Generators.load_components!+ for handle
    # 3rd party generators
    #
    class Cli < Thor::Group

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
          puts
          puts '-'*70
          puts "Please specify generator to use (#{Appjam::Generators.mappings.keys.join(", ")})"
          puts '-'*70
          puts 'Usage1: appjam project todo      # generate iphone project skeleton'
          puts 'Usage2: appjam model user        # generate iphone project data model'
          puts '-'*70
          puts
        end
      end
    end # Cli
  end # Generators
end # Appjam