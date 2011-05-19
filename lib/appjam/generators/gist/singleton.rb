require File.dirname(__FILE__) + '/../jam'

module Appjam
  module Generators
    module Gist
      class Singleton < Gist
        gist_name "singleton"
        gist_id "https://gist.github.com/979981"
        gist_description "Singletons in Objective C"
        
        def create_gist
          preview_gist
        end
        
      end # Singleton
    end # Gist
  end # Generators
end # Appjam        