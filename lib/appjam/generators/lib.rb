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
require File.dirname(__FILE__) + '/gist'

module Appjam
  module Generators
    class Lib < Jam
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
            system("qlmanage -p #{tempfile.path} >& /dev/null")
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
        
        def download_gist(gist_id,git_category,gist_name)
          puts "-- fetching [#{gist_name}] lib --"
          # require 'uri'
          # require 'yajl/http_stream'
          # 
          # uri = URI.parse("http://gist.github.com/api/v1/json/#{gist_id}")
          # Yajl::HttpStream.get(uri, :symbolize_keys => true) do |hash|
          #   
          # end    
          #     if @submodule_name == 'kissxml'
          #       eval(File.read(__FILE__) =~ /^__END__\n/ && $' || '')  
          # 
          #       system "rm -rf kissxml"
          #       system "hg clone https://kissxml.googlecode.com/hg/ Frameworks/kissxml"
          #       system "git add ."
          #       system "git commit -m 'import kissxml submodule'"
          #       say (<<-TEXT).gsub(/ {10}/,'')      
          if gist_id.include?('github.com')               
            if File.directory?("Frameworks/#{gist_name.downcase}")
              `rm -rf Frameworks/#{gist_name.downcase}`
            end
            if("#{gist_id}".is_numeric?)
              `git clone git://gist.github.com/#{gist_id}.git Frameworks/#{gist_name.downcase} && rm -rf Frameworks/#{gist_name.downcase}/.git`
            else
              `git clone #{gist_id} Frameworks/#{gist_name.downcase} && rm -rf Frameworks/#{gist_name.downcase}/.git`
            end
          else
            if system('which hg') != nil
               system "rm -rf Frameworks/#{gist_name.downcase}"
               system "hg clone https://kissxml.googlecode.com/hg/ Frameworks/#{gist_name.downcase}"
               system "git add ."
               system "git commit -m 'import #{gist_name.downcase} submodule'"     
            else
               say "="*70
               say "Mercurial was not installed!! check http://mercurial.selenic.com/ for installation."
               say "="*70              
            end       
          end
        end                 
      end      

      # Add this generator to our appjam
      Appjam::Generators.add_generator(:lib, self)

      # Define the source lib root
      def self.source_root; File.expand_path(File.dirname(__FILE__)); end
      def self.banner; "appjam lib [name]"; end

      # Include related modules
      include Thor::Actions
      include Appjam::Generators::Actions            

      desc "Description:\n\n\tappjam will generates an new PureMvc Model for iphone"

      argument :name, :desc => "The name of your lib"

      class_option :root, :desc => "The root destination", :aliases => '-r', :default => ".", :type => :string
      class_option :destroy, :aliases => '-d', :default => false,   :type    => :boolean

      def in_app_root?
        File.exist?('Classes')
      end     

      def create_lib
        if in_app_root? 
          valid_constant?(options[:lib] || name)
          @lib_name = (options[:app] || name).gsub(/W/, "_").downcase
          @xcode_project_name = File.basename(Dir.glob('*.xcodeproj')[0],'.xcodeproj').downcase          
          @class_name = (options[:app] || name).gsub(/W/, "_").capitalize
          @developer = "eiffel"
          @created_on = Date.today.to_s
          self.destination_root = options[:root]
          
          puts colorize( "Appjam Version: #{Appjam::Version::STRING}", { :foreground => :red, :background => :white, :config => :underline } )
          puts
          require 'yaml'
          # begin
          #   page_source = Net::HTTP.get(URI.parse("http://eiffelqiu.github.com/appjam/gist.yml"))
          # rescue SocketError => e
          # end   
          gistfile = File.expand_path("~") + '/.appjam/gist.yml'
          Gist::update_gist unless File.exist?(gistfile)          
          begin 
            g = YAML.load_file(gistfile)  
          rescue ArgumentError => e
            g = YAML.load_file(File.expand_path(File.dirname(__FILE__) + '/gist.yml'))
          end
          puts "notice: #{g['info']}" if g['info']
          puts
          g.each_pair {|key,value|
            gcategory = key.downcase
            if gcategory == 'lib'
              g[key].each { |k|
                k.each_pair { |k1,v1|
                  if "#{k1}" == @lib_name
                    gid = k[k1][0]['id']
                    gname = k[k1][1]['name']
                    eval(File.read(__FILE__) =~ /^__END__\n/ && $' || '')                       
                    Lib::download_gist("#{gid}",gcategory,gname)
                    eval(File.read(__FILE__) =~ /^__END__/ && $' || '')
                    say "================================================================="
                    say "Check Frameworks/#{gname}/ for lib"
                    say "Open #{@xcode_project_name.capitalize}.xcodeproj"
                    say "Add 'Frameworks/#{gname}/' folder to the 'Classes' Group"
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
      end

    end # Submodule
  end # Generators
end # Appjam

__END__
unless File.exist?("./.git")
system "git init"
template "lib/gitignore.tt", "./.gitignore"
template "lib/gitattributes.tt", "./.gitattributes"
system "git add ."
system "git commit -m 'init commit'"
end


