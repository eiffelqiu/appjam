module Appjam
  module Version
    MAJOR = 0
    MINOR = 1
    PATCH = 8
    BUILD = '3'
    
    STRING = [MAJOR, MINOR, PATCH, BUILD].compact.join('.').chomp('.')
  end
end