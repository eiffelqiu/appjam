module Appjam
  module Version
    MAJOR = 0
    MINOR = 1
    PATCH = 0
    BUILD = 'pre16'

    STRING = [MAJOR, MINOR, PATCH, BUILD].compact.join('.')
  end
end