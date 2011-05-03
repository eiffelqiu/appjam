module Appjam

  ##
  # This module it's used for bootstrap with padrino rake
  # thirdy party tasks
  #
  # ==== Examples
  #
  #   Appjam::Tasks.files << yourtask.rb
  #   Appjam::Tasks.files.concat(Dir["/path/to/all/my/tasks/*.rb"])
  #   Appjam::Tasks.files.unshift("yourtask.rb")
  #
  module Tasks

    ##
    # Returns a list of files to handle with appjam rake
    #
    def self.files
      @files ||= Dir[File.dirname(__FILE__) + "/tasks/**/*.rb"]
    end
  end # Tasks
end # Appjam