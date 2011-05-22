module Appjam
  module Version
    MAJOR = 0
    MINOR = 1
    PATCH = 8
    BUILD = 'pre4'
    
    STRING = [MAJOR, MINOR, PATCH, BUILD].compact.join('.').chomp('.')
  end
end