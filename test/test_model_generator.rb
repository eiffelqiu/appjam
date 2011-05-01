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
  
    should "do not allow create model outside iphone project folder" do
      assert_nothing_raised { silence_logger { generate(:project, 'sample_project', "--root=#{@apptmp}") } }
      assert_raise(::NameError) { silence_logger { generate(:model, "user") } }
    end  
    
    should "raise an Error when given invalid constant names for model" do
      assert_raise(::NameError) { silence_logger { generate(:model, "123asdf") } }
      assert_raise(::NameError) { silence_logger { generate(:model, "./sample_project") } }
    end    
    
  end
  
end