require 'rubygems'
require 'net/http'
require 'net/https'
require 'uri'
require 'tempfile'
require File.dirname(__FILE__) + '/jam'

module Appjam
  module Generators
    class Gist < Jam
      
      class << self
        attr_rw :gist_name, :gist_description, :gist_id, :gist_body
        def preview_gist
          uri  = URI(self.gist_body)
          http = Net::HTTP.new(uri.host, uri.port)
          if uri.scheme == 'https'
            http.use_ssl     = true
            http.verify_mode = OpenSSL::SSL::VERIFY_NONE
          end

          result   = http.start {|h| h.request(Net::HTTP::Get.new(uri.path))}
          tempfile = Tempfile.new('gist')
          tempfile.puts(result)
          tempfile.close

          if system('which qlmanage')
            system("qlmanage -c public.plain-text -p #{tempfile.path} >& /dev/null")
          end          
        end
      end

      # Add this generator to our appjam
      Appjam::Generators.add_generator(:gist, self)

      # Define the source Gist root
      def self.source_root; File.expand_path(File.dirname(__FILE__)); end
      def self.banner; "appjam gist [name]"; end

      # Include related modules
      include Thor::Actions
      include Appjam::Generators::Actions            

      desc "Description:\n\n\tappjam will generates function snippet for iphone"

      argument :name, :desc => "The name of your function"

      class_option :root, :desc => "The root destination", :aliases => '-r', :default => ".", :type => :string
      class_option :destroy, :aliases => '-d', :default => false,   :type    => :boolean

      def in_app_root?
        File.exist?('Classes')
      end     

      def create_gist
        valid_constant?(options[:gist] || name)
        @gist_name = (options[:app] || name).gsub(/W/, "_").downcase
        @class_name = (options[:app] || name).gsub(/W/, "_").capitalize
        @developer = "eiffel"
        @created_on = Date.today.to_s
        self.destination_root = options[:root]
                
        eval(File.read(__FILE__) =~ /^__END__
/ && $' || '')

say (<<-TEXT).gsub(/ {10}/,'')

=================================================================
Your function snippet has been generated.
=================================================================

TEXT          
        end

    end # Gist
  end # Generators
end # Appjam

__END__
# put your Gist command here

