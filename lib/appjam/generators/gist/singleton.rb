require File.dirname(__FILE__) + '/../gist'

module Appjam
  module Generators
      class Singleton < Gist
        gist_name "singleton"
        gist_id "https://gist.github.com/979981"
        gist_description "Singletons in Objective C"
        
        # Add this generator to our appjam
        Appjam::Generators.add_generator(:gist, self)

        def create_git   
          valid_constant?(options[:gist] || name)
          @gist_name = (options[:app] || name).gsub(/W/, "_").downcase
          @class_name = (options[:app] || name).gsub(/W/, "_").capitalize
          @developer = "eiffel"
          @created_on = Date.today.to_s
          self.destination_root = options[:root]
          
          if @gist_name == 'singleton'
            Gist::download_gist(979981)
            Gist::preview_gist(979981)
            eval(File.read(__FILE__) =~ /^__END__/ && $' || '')

            say "================================================================="
            say "Your function snippet has been generated."
            say "================================================================="
            
          end
        end
        
      end # Singleton
  end # Generators
end # Appjam        

__END__
