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
  
  should "display the right path" do
    buffer = silence_logger { generate(:project, 'project', "--root=/tmp") }
    assert_file_exists("/tmp/project")
  end
  
end