require 'thor'
require 'thor/group'
require 'thor/actions'
require 'active_support/core_ext/string'
require 'active_support/inflector'
require 'date' 
require File.dirname(__FILE__) + '/actions'

module Appjam
  module Generators
    class Jam < Thor::Group   

      # Add this generator to our appjam
      Appjam::Generators.add_generator(:jam, self)

      # Define the source template root
      def self.source_root; File.expand_path(File.dirname(__FILE__)); end
      def self.banner; "appjam jam [name]"; end

      # Include related modules
      include Thor::Actions
      include Appjam::Generators::Actions      

      desc "Description:\n\n\tthis should not be used, only acts as Parent Class"

      argument :name, :desc => "The name of your jam"

      class_option :root, :desc => "The root destination", :aliases => '-r', :default => ".", :type => :string
      class_option :destroy, :aliases => '-d', :default => false,   :type    => :boolean

      def in_app_root?
        File.exist?('Classes')
      end     

      def create_app
        valid_constant?(options[:project] || name)
        @jam_name = (options[:jam] || name).gsub(/\W/, "_").downcase
        @developer = "#{`whoami`.strip}"
        @created_on = Date.today.to_s
        self.destination_root = options[:root]
        project = options[:jam]
        self.behavior = :revoke if options[:destroy]
        
        empty_directory "#{@jam_name}"

        say (<<-TEXT).gsub(/ {10}/,'')
      
      =================================================================
      Your #{@jam_name} has been generated.
      =================================================================
      
      TEXT
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
          attr_rw :version, :homepage, :author, :email
      end
      
    end # Jam
  end # Generators
end # Appjam