module Appjam
  module Version
    MAJOR = 0
    MINOR = 1
    PATCH = 1
    BUILD = ''
    
    STRING = [MAJOR, MINOR, PATCH, BUILD].compact.join('.').chomp('.')
  end
end