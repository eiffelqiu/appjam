require File.expand_path(File.dirname(__FILE__) + '/helper')

class TestProjectGenerator < Test::Unit::TestCase
  def setup
    @apptmp = "#{Dir.tmpdir}/appjam-tests/#{UUID.new.generate}"
    `mkdir -p #{@apptmp}`
  end

  def teardown
    `rm -rf #{@apptmp}`
    `rm -rf /tmp/project`
  end
  
  context 'the project generator' do  
  
    should "display the right path" do
      buffer = silence_logger { generate(:project, 'project', "--root=/tmp") }
      assert_file_exists("/tmp/project")
    end
  
    should "allow simple generator to run and create base_app with no options" do
      assert_nothing_raised { silence_logger { generate(:project, 'sample_project', "--root=#{@apptmp}") } }
      assert_file_exists("#{@apptmp}/sample_project")
      assert_file_exists("#{@apptmp}/sample_project/Classes")
      assert_file_exists("#{@apptmp}/sample_project/Contacts_Prefix.pch")
      assert_file_exists("#{@apptmp}/sample_project/Contacts-Info.plist")
      assert_file_exists("#{@apptmp}/sample_project/Contacts.xcodeproj")
      assert_file_exists("#{@apptmp}/sample_project/main.m")
    end  
    
    should "raise an Error when given invalid constant names" do
      assert_raise(::NameError) { silence_logger { generate(:project, "123asdf", "--root=#{@apptmp}") } }
      assert_raise(::NameError) { silence_logger { generate(:project, "./sample_project", "--root=#{@apptmp}") } }
    end    
    
  end
  
end