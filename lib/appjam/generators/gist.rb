require 'rubygems'
require 'fileutils'
require 'net/http'
require 'net/https'
require 'uri'
require "open-uri"
require 'tempfile'
require File.dirname(__FILE__) + '/jam'

module Appjam
  module Generators
    class Gist < Jam
      
      class << self
        def self.attr_rw(*attrs)
          attrs.each do |attr|
            class_eval %Q{
              def #{attr}(val=nil)
                val.nil? ? @#{attr} : @#{attr} = val
              end
            }
          end
        end        
        attr_rw :gist_name, :gist_description, :gist_id, :gist_body
        def preview_gist(gid)
          uri  = URI("https://gist.github.com/#{gid}.txt")
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
        
        def download_gists(username, page=1)
          puts "-- Downloading page #{page} of gists --"
          url = URI.parse("http://gist.github.com")
          res = Net::HTTP.start(url.host, url.port) do |http|
              response = http.get("/#{username}?page=#{page}")
              if response.code == '200'
                links = get_links(response.body)
                links.each do |link, gist_id|
                  puts "git://gist.github.com/#{gist_id}.git"
                  if File.directory?("Support/#{gist_id}")
                    `cd Support/#{gist_id} && git pull ; cd ..`
                  else
                    `git clone git://gist.github.com/#{gist_id}.git Support/#{gist_id}`
                  end
                end
                download_gists(username, page+1) unless links.empty?
              end
          end
        end     
        
        def download_gist(gist_id)
          puts "-- fetching gist --"
          puts "#{gist_id}.git"
          if File.directory?("Support/#{gist_id}")
            `cd Support/#{gist_id} && git pull ; cd ..`
          else
            `git clone git://gist.github.com/#{gist_id}.git Support/#{gist_id}`
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

      end

    end # Gist
  end # Generators
end # Appjam

__END__
# put your Gist command here
