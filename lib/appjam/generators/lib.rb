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
    class Lib < Jam
      
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
            `git clone git://gist.github.com/#{gist_id}.git Gist/#{git_category}/#{gist_name.downcase} && rm -rf Gist/#{git_category}/#{gist_name.downcase}/.git`
          else
            `git clone #{gist_id} Gist/#{git_category}/#{gist_name.downcase} && rm -rf Gist/#{git_category}/#{gist_name.downcase}/.git`
          end
          if system('which qlmanage')
            system("qlmanage -p Gist/#{git_category}/#{gist_name.downcase}/*.* >& /dev/null")
          end
        end                 
      end      

      # Add this generator to our appjam
      Appjam::Generators.add_generator(:submodule, self)

      # Define the source submodule root
      def self.source_root; File.expand_path(File.dirname(__FILE__)); end
      def self.banner; "appjam submodule [name]"; end

      # Include related modules
      include Thor::Actions
      include Appjam::Generators::Actions            

      desc "Description:\n\n\tappjam will generates an new PureMvc Model for iphone"

      argument :name, :desc => "The name of your puremvc submodule"

      class_option :root, :desc => "The root destination", :aliases => '-r', :default => ".", :type => :string
      class_option :destroy, :aliases => '-d', :default => false,   :type    => :boolean

      def in_app_root?
        File.exist?('Classes')
      end     

      def create_submodule
        valid_constant?(options[:submodule] || name)
        @submodule_name = (options[:app] || name).gsub(/W/, "_").downcase
        @xcode_project_name = File.basename(Dir.glob('*.xcodeproj')[0],'.xcodeproj').downcase          
        @class_name = (options[:app] || name).gsub(/W/, "_").capitalize
        @developer = "eiffel"
        @created_on = Date.today.to_s
        self.destination_root = options[:root]
        
        # if which('hg') != nil
        #   if in_app_root?
        #     if @submodule_name == 'kissxml'
        #       eval(File.read(__FILE__) =~ /^__END__\n/ && $' || '')  
        # 
        #       system "rm -rf kissxml"
        #       system "hg clone https://kissxml.googlecode.com/hg/ Frameworks/kissxml"
        #       system "git add ."
        #       system "git commit -m 'import kissxml submodule'"
        #       say (<<-TEXT).gsub(/ {10}/,'')
        # 
        #       =================================================================
        #       kissxml submodule has been imported
        # 
        #       Open #{@xcode_project_name.capitalize}.xcodeproj
        #       Add "kissxml" folder to the "Other Sources" Group
        #       Build and Run
        #       =================================================================
        #       TEXT
        #     else
        #       unless %w(three20 sihttp json-framework kissxml).include?(@submodule_name)
        #         say "="*70
        #         say "Only support three20,asihttp,json-framework,kissxml submodule now!"
        #         say "="*70
        #       end            
        #     end
        #   else
        #     puts
        #     puts '-'*70
        #     puts "You are not in an iphone project folder"
        #     puts '-'*70
        #     puts            
        #   end
        # else
        #   say "="*70
        #   say "Mercurial was not installed!! check http://mercurial.selenic.com/ for installation."
        #   say "="*70          
        # end        
        # 
        # if which('git') != nil
        #   if in_app_root? 
        #     if @submodule_name == 'three20'
        #         
        #     eval(File.read(__FILE__) =~ /^__END__\n/ && $' || '')  
        #          
        #     system "rm -rf three20"
        #     system "git submodule add git://github.com/facebook/three20.git Frameworks/three20"
        #     system "git add ."
        #     system "git commit -m 'import three20 submodule'"
        #     
        #     say (<<-TEXT).gsub(/ {10}/,'')
        # 
        #     =================================================================
        #     Three20 submodule has been imported
        # 
        #     Open #{@xcode_project_name.capitalize}.xcodeproj
        #     Add "three20/src/Three20/Three20.xcodeproj" folder to the "Other Sources" Group
        #     Add "three20/src/Three20.bundle" folder to the "Other Sources" Group
        #     Build and Run
        #     =================================================================
        #     TEXT
        #     elsif @submodule_name == 'asihttp'
        #       eval(File.read(__FILE__) =~ /^__END__\n/ && $' || '')  
        # 
        #       system "rm -rf asihttp"
        #       system "git submodule add git://github.com/pokeb/asi-http-request.git Frameworks/asihttp"
        #       system "git add ."
        #       system "git commit -m 'import asihttp submodule'"
        # 
        #       say (<<-TEXT).gsub(/ {10}/,'')
        # 
        #       =================================================================
        #       Asihttp submodule has been imported
        # 
        #       Open #{@xcode_project_name.capitalize}.xcodeproj
        #       Add "asihttp" folder to the "Other Sources" Group
        #       Build and Run
        #       =================================================================
        #       TEXT
        #     elsif @submodule_name == 'json'
        #       eval(File.read(__FILE__) =~ /^__END__\n/ && $' || '')  
        # 
        #       system "rm -rf json-framework"
        #       system "git submodule add git://github.com/stig/json-framework Frameworks/json-framework"
        #       system "git add ."
        #       system "git commit -m 'import json-framework submodule'"      
        #       say (<<-TEXT).gsub(/ {10}/,'')
        # 
        #       =================================================================
        #       json-framework submodule has been imported
        # 
        #       Open #{@xcode_project_name.capitalize}.xcodeproj
        #       Add "json-framework" folder to the "Other Sources" Group
        #       Build and Run
        #       =================================================================
        #       TEXT
        #     else
        #       unless %w(three20 sihttp json-framework kissxml).include?(@submodule_name)
        #         say "="*70
        #         say "Only support three20,asihttp,json-framework,kissxml submodule now!"
        #         say "="*70
        #       end
        #     end
        #   else
        #     puts
        #     puts '-'*70
        #     puts "You are not in an iphone project folder"
        #     puts '-'*70
        #     puts          
        #   end
        # else
        #   say "="*70
        #   say "Git was not installed!! check http://git-scm.com/ for installation."
        #   say "="*70          
        # end
        
          require 'yaml'
          begin
            page_source = Net::HTTP.get(URI.parse("http://eiffelqiu.github.com/appjam/gist.yml"))
          rescue SocketError => e
          end   
          begin 
            puts "fetching new gists ..." 
            g = YAML::load(page_source)  
          rescue ArgumentError => e
            g = YAML.load_file(File.expand_path(File.dirname(__FILE__) + '/gist.yml'))
          end
          g.each_pair {|key,value|
            gcategory = key.downcase
            if gcategory == 'lib'
              g[key].each { |k|
                k.each_pair { |k1,v1|
                  if "#{k1}" == @gist_name
                    gid = k[k1][0]['id']
                    gname = k[k1][1]['name']
                    Gist::download_gist("#{gid}",gcategory,gname)
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
      end

    end # Submodule
  end # Generators
end # Appjam

__END__
unless File.exist?("./.git")
system "git init"
template "submodule/gitignore.tt", "./.gitignore"
template "submodule/gitattributes.tt", "./.gitattributes"
system "git add ."
system "git commit -m 'init commit'"
end


