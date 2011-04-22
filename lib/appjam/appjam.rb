class Appjam < Thor::Group
  include Thor::Actions
  
  # Define arguments and options
  argument :name
  
  def self.source_root
    File.dirname(__FILE__)
  end
  
  def create_lib_file
    template('generators/dummy.tt', "#{name}/Classes/#{name}.rb")
  end
  
  
  def copy_licence
    if yes?("Use MIT license?")
      # Make a copy of the MITLICENSE file at the source root
      copy_file "LICENSE.txt", "#{name}/LICENSE.txt"
    else
      say "Shame on you…", :red
    end
  end
end