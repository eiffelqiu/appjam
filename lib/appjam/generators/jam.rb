require 'thor'
require 'hirb'
require 'thor/group'
require 'thor/actions'
require 'active_support/core_ext/string'
require 'active_support/inflector'
require 'date' 
require File.dirname(__FILE__) + '/actions'
require File.dirname(__FILE__) + '/../view'

module Appjam
  module Generators
    class Jam < Thor::Group   

      def self.init_generator
        # Define the source template root
        def self.source_root; File.expand_path(File.dirname(__FILE__)); end
        def self.banner; "appjam #{self.to_s.downcase.intern} [name]"; end

        # Include related modules
        include Thor::Actions
        include Appjam::Generators::Actions 
      end     
      
      def self.parseTemplate(data)
        eval(data)
      end

      desc "Description:\n\n\tthis should not be used, only acts as Parent Class"

      argument :name, :desc => "The name of your #{self.to_s.downcase.intern}"

      class_option :root, :desc => "The root destination", :aliases => '-r', :default => ".", :type => :string
      class_option :destroy, :aliases => '-d', :default => false,   :type    => :boolean

      def in_app_root?
        File.exist?('Classes')
      end     

      def create_jam
        valid_constant?(options["#{self.to_s.downcase.intern}"] || name)
        @jam_name = (options["#{self.to_s.downcase.intern}"] || name).gsub(/\W/, "_").downcase
        @developer = "#{`whoami`.strip}"
        @created_on = Date.today.to_s
        self.destination_root = options[:root]
        project = options["#{self.to_s.downcase.intern}"]
        self.behavior = :revoke if options[:destroy]
        
        #empty_directory "#{@jam_name}"
        
      #   View.render(options)
      #   say (<<-TEXT).gsub(/ {10}/,'')
      # 
      # =================================================================
      # Your #{@jam_name} has been generated.
      # =================================================================
      # 
      # TEXT
      end
      
      class << self
          # The methods below define the JAM DSL.
          attr_reader :stable, :unstable
          
          def self.attr_rw(*attrs)
            attrs.each do |attr|
              class_eval %Q{
                def #{attr}(val=nil)
                  val.nil? ? @#{attr} : @#{attr} = val
                end
              }
            end
          end
          attr_rw :version, :homepage, :author, :email, :data
      end
      
    end # Jam
  end # Generators
end # Appjam