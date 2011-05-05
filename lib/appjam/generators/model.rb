require File.dirname(__FILE__) + '/jam'

module Appjam
  module Generators
    class Model < Jam
      
      author 'Eiffel Qiu'
      homepage 'http://www.likenote.com'
      email 'eiffelqiu@gmail.com'
      version Appjam::Version::STRING   
      
      # Add this generator to our appjam
      Appjam::Generators.add_generator(:model, self)
  
      init_generator      

      desc "Description:\n\n\tappjam will generates an new PureMvc Model for iphone"

      argument :name, :desc => "The name of your puremvc model"

      class_option :root, :desc => "The root destination", :aliases => '-r', :default => ".", :type => :string
      class_option :destroy, :aliases => '-d', :default => false,   :type    => :boolean

      def create_app
        if in_app_root?
          valid_constant?(options[:model] || name)
          @model_name = (options[:app] || name).gsub(/\W/, "_").downcase
          @project_name = (options[:app] || name).gsub(/\W/, "_").downcase
          @xcode_project_name = File.basename(Dir.glob('*.xcodeproj')[0],'.xcodeproj').downcase
          @class_name = (options[:app] || name).gsub(/\W/, "_").capitalize
          @developer = "#{`whoami`.strip}"
          @created_on = Date.today.to_s
          self.destination_root = options[:root]
          project = options[:project]
          self.behavior = :revoke if options[:destroy]
          
          eval(File.read(__FILE__) =~ /^__END__\n/ && $' || '')

          say (<<-TEXT).gsub(/ {10}/,'')
      
      =================================================================
      Your [#{@model_name.capitalize}] Model has been generated.
      Open #{@xcode_project_name.capitalize}.xcodeproj
      Add "Classes/#{@model_name}/" folder to the "Classes/apps" Group
      Build and Run
      =================================================================
      
        TEXT
        else 
          puts
          puts '-'*70
          puts "You are not in an iphone project folder"
          puts '-'*70
          puts
        end
      end
    end # Model
  end # Generators
end # Appjam

__END__
header = "
#define ShowNew#{@class_name} @\"ShowNew#{@class_name}\"
#define ShowEdit#{@class_name} @\"ShowEdit#{@class_name}\"
#define Show#{@class_name}Form @\"Show#{@class_name}Form\"
#define Show#{@class_name}List @\"Show#{@class_name}Lis\t\"
#define Create#{@class_name} @\"Create#{@class_name}\"
#define Update#{@class_name} @\"Update#{@class_name}\"
#define Delete#{@class_name} @\"Delete#{@class_name}\"
#define Get#{@class_name}s @\"Get#{@class_name}s\"
#define Get#{@class_name}sSuccess @\"Get#{@class_name}sSuccess\"          
"
inject_into_file destination_root("Classes/#{@xcode_project_name}/ApplicationFacade.h"), header, :after => "#import \"Facade.h\"\n"        
template "project/Classes/contacts/controller/CreateUserCommand.h.tt" , "Classes/#{@model_name}/controller/Create#{@class_name}Command.h"
template "project/Classes/contacts/controller/CreateUserCommand.m.tt" , "Classes/#{@model_name}/controller/Create#{@class_name}Command.m"
template "project/Classes/contacts/controller/DeleteUserCommand.h.tt" , "Classes/#{@model_name}/controller/Delete#{@class_name}Command.h"
template "project/Classes/contacts/controller/DeleteUserCommand.m.tt" , "Classes/#{@model_name}/controller/Delete#{@class_name}Command.m"
template "project/Classes/contacts/controller/GetUsersCommand.h.tt" , "Classes/#{@model_name}/controller/Get#{@class_name}sCommand.h"
template "project/Classes/contacts/controller/GetUsersCommand.m.tt" , "Classes/#{@model_name}/controller/Get#{@class_name}sCommand.m"
template "project/Classes/contacts/controller/UpdateUserCommand.h.tt" , "Classes/#{@model_name}/controller/Update#{@class_name}Command.h"
template "project/Classes/contacts/controller/UpdateUserCommand.m.tt" , "Classes/#{@model_name}/controller/Update#{@class_name}Command.m"
template "project/Classes/contacts/model/UserProxy.h.tt" , "Classes/#{@model_name}/model/#{@class_name}Proxy.h"
template "project/Classes/contacts/model/UserProxy.m.tt" , "Classes/#{@model_name}/model/#{@class_name}Proxy.m"
template "project/Classes/contacts/model/vo/UserVO.h.tt" , "Classes/#{@model_name}/model/vo/#{@class_name}VO.h"
template "project/Classes/contacts/model/vo/UserVO.m.tt" , "Classes/#{@model_name}/model/vo/#{@class_name}VO.m"
template "project/Classes/contacts/view/UserMediator.h.tt" , "Classes/#{@model_name}/view/#{@class_name}Mediator.h"
template "project/Classes/contacts/view/UserMediator.m.tt" , "Classes/#{@model_name}/view/#{@class_name}Mediator.m"
template "project/Classes/contacts/view/UserFormMediator.h.tt" , "Classes/#{@model_name}/view/#{@class_name}FormMediator.h"
template "project/Classes/contacts/view/UserFormMediator.m.tt" , "Classes/#{@model_name}/view/#{@class_name}FormMediator.m"
template "project/Classes/contacts/view/UserListMediator.h.tt" , "Classes/#{@model_name}/view/#{@class_name}ListMediator.h"
template "project/Classes/contacts/view/UserListMediator.m.tt" , "Classes/#{@model_name}/view/#{@class_name}ListMediator.m"
template "project/Classes/contacts/view/components/Contacts.h.tt" , "Classes/#{@model_name}/view/components/#{@class_name}.h"
template "project/Classes/contacts/view/components/Contacts.m.tt" , "Classes/#{@model_name}/view/components/#{@class_name}.m"
template "project/Classes/contacts/view/components/UserForm.h.tt" , "Classes/#{@model_name}/view/components/#{@class_name}Form.h"
template "project/Classes/contacts/view/components/UserForm.m.tt" , "Classes/#{@model_name}/view/components/#{@class_name}Form.m"
template "project/Classes/contacts/view/components/UserList.h.tt" , "Classes/#{@model_name}/view/components/#{@class_name}List.h"
template "project/Classes/contacts/view/components/UserList.m.tt" , "Classes/#{@model_name}/view/components/#{@class_name}List.m"