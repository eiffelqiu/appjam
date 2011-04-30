module Appjam
  module Version
    MAJOR = 0
    MINOR = 1
    PATCH = 0
    BUILD = 'pre10'

    STRING = [MAJOR, MINOR, PATCH, BUILD].compact.join('.')
  end
end