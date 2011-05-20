module Appjam
  module Version
    MAJOR = 0
    MINOR = 1
    PATCH = 7
    BUILD = '2pre'
    
    STRING = [MAJOR, MINOR, PATCH, BUILD].compact.join('.').chomp('.')
  end
end