require 'rubygems'
require 'fileutils'
require 'net/http'
require 'net/https'
require 'uri'
require "open-uri"
require 'tempfile'
require 'cli-colorize'
require 'hirb'
require File.dirname(__FILE__) + '/../view'
require File.dirname(__FILE__) + '/jam'

class String
  def is_numeric?
    Float(self)
    true 
  rescue 
    false
  end
end

module Appjam
  module Generators
    class Gist < Jam
      include CLIColorize
      
      CLIColorize.default_color = :red
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
            system("qlmanage -p #{tempfile.path}/* >& /dev/null")
          end          
        end  
        
        def update_gist
          appjam_dir = '~/.appjam'
          appjam_gist = File.expand_path("~") + '/.appjam/gist.yml'
          system "mkdir -p #{appjam_dir}" unless File.exist?(appjam_dir)
          begin
            puts "fetching new gist list from server ... "
            page_source = Net::HTTP.get(URI.parse("http://eiffelqiu.github.com/appjam/gist.yml"))
            File.open(appjam_gist, 'w') {|f| f.write(page_source) }
          rescue SocketError => e
            puts "can not access github.com, back to local version gist.yml"
            origin_gist = File.expand_path(File.dirname(__FILE__) + '/gist.yml')
            system "cp #{origin_gist} #{appjam_gist}"
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
                  if File.directory?("Gist/#{gist_id}")
                    `cd Gist/#{gist_id} && git pull ; cd ..`
                  else
                    `git clone git://gist.github.com/#{gist_id}.git Gist/#{gist_id}`
                  end
                end
                download_gists(username, page+1) unless links.empty?
              end
          end
        end     
        
        def download_gist(gist_id,git_category,gist_name,gist_type)
          puts "-- fetching gist [#{gist_name}] --"
          # require 'uri'
          # require 'yajl/http_stream'
          # 
          # uri = URI.parse("http://gist.github.com/api/v1/json/#{gist_id}")
          # Yajl::HttpStream.get(uri, :symbolize_keys => true) do |hash|
          #   
          # end      
          if File.directory?("Gist/#{git_category}/#{gist_name.downcase}")
            `rm -rf Gist/#{git_category}/#{gist_name.downcase}`
          end
          if("#{gist_id}".is_numeric?)
            if system('which git') != nil  
              `git clone git://gist.github.com/#{gist_id}.git Gist/#{git_category}/#{gist_name.downcase} && rm -rf Gist/#{git_category}/#{gist_name.downcase}/.git`
            else
              say "="*70
              say "Git was not installed!! check http://git-scm.com/ for installation."
              say "="*70              
            end
          else
            if "#{gist_type}".strip == 'hg'
              if system('which hg') != nil
                `hg clone #{gist_id} Gist/#{git_category}/#{gist_name.downcase} && rm -rf Gist/#{git_category}/#{gist_name.downcase}/.hg`
              else
                 say "="*70
                 say "Mercurial was not installed!! check http://mercurial.selenic.com/ for installation."
                 say "="*70              
              end 
            end  
            if "#{gist_type}".strip == 'svn'
              if system('which svn') != nil
                `svn co #{gist_id} Gist/#{git_category}/#{gist_name.downcase} && rm -rf Gist/#{git_category}/#{gist_name.downcase}/.svn`
              else
                 say "="*70
                 say "Subversion was not installed!! check http://www.open.collab.net/downloads/community/ for installation."
                 say "="*70              
              end 
            end 
            if "#{gist_type}".strip == 'git'   
              if system('which git') != nil                  
                `git clone #{gist_id} Gist/#{git_category}/#{gist_name.downcase} && rm -rf Gist/#{git_category}/#{gist_name.downcase}/.git`
              else
                say "="*70
                say "Git was not installed!! check http://git-scm.com/ for installation."
                say "="*70              
              end
            end
          end
          if system('which qlmanage')
            system("qlmanage -p Gist/#{git_category}/#{gist_name.downcase}/* >& /dev/null")
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

      def create_git  
          valid_constant?(options[:gist] || name)
          @gist_name = (options[:app] || name).gsub(/W/, "_").downcase
          @class_name = (options[:app] || name).gsub(/W/, "_").capitalize   
          @developer = "eiffel"
          @created_on = Date.today.to_s
          self.destination_root = options[:root]

          puts colorize( "Appjam Version: #{Appjam::Version::STRING}", { :foreground => :red, :background => :white, :config => :underline } )
          puts
                    
          unless @gist_name == 'update'
            if in_app_root? 
              require 'yaml'
              @xcode_project_name = File.basename(Dir.glob('*.xcodeproj')[0],'.xcodeproj').downcase
              # begin
              #   page_source = Net::HTTP.get(URI.parse("http://eiffelqiu.github.com/appjam/gist.yml"))
              # rescue SocketError => e
              #   puts "can not access github.com, back to local version gist.yml"
              # end   
              gistfile = File.expand_path("~") + '/.appjam/gist.yml'
              Gist::update_gist unless File.exist?(gistfile)
              begin 
                puts "fetching new gists ..." 
                g = YAML.load_file(gistfile)  
              rescue ArgumentError => e
                puts "can't fetch new gists, loading local gists ..."
                g = YAML.load_file(File.expand_path(File.dirname(__FILE__) + '/gist.yml'))
              end
              puts "notice: a new version '#{g['info']}' released" if g['info'] and g['info'].strip != "#{Appjam::Version::STRING}"
              puts
              g.each_pair {|key,value|
                gcategory = key.downcase
                unless (gcategory == 'lib' or gcategory == 'info')
                  
                  g[key].each { |k|
                    k.each_pair { |k1,v1|
                      if "#{k1}" == @gist_name
                        gid = k[k1][0]['id']
                        gname = k[k1][1]['name']
                        gtype = 'git'
                        if k[k1].length == 4
                          gtype = k[k1][3]['type']
                        end
                        puts "repository type: #{gtype}"
                        Gist::download_gist("#{gid}",gcategory,gname,gtype)
                        eval(File.read(__FILE__) =~ /^__END__/ && $' || '')
                        say "================================================================="
                        say "Your '#{gname.capitalize}' snippet code has been generated."
                        say "Check Gist/#{gcategory}/#{gname}/ for snippet"
                        say "Open #{@xcode_project_name.capitalize}.xcodeproj"
                        say "Add 'Gist/#{gcategory}/#{gname}/' folder to the 'Classes/apps' Group"
                        say "Build and Run"          
                        say "================================================================="              
                      end                  
                    }
                  }
                end
              }
            else 
              puts
              puts '-'*70
              puts "You are not in an iphone project folder"
              puts '-'*70
              puts
            end            
          else
            Gist::update_gist
          end
      end # create_gist

    end # Gist
  end # Generators
end # Appjam

__END__
# put your Gist command here

