module Appjam

  module Utility
    class XcodeUUIDGenerator

        def initialize
            @num = [Time.now.to_i, Process.pid, getMAC]
        end

        # Get the ethernet hardware address ("MAC"). This version
        # works on Mac OS X 10.6 (Snow Leopard); it has not been tested
        # on other versions.

        def getMAC(interface='en0')
            addrMAC = `ifconfig #{interface} ether`.split("\n")[1]
            addrMAC ? addrMAC.strip.split[1].gsub(':','').to_i(16) : 0
        end

        def generate
            @num[0] += 1
            self
        end

        def to_s
            "%08X%04X%012X" % @num
        end
    end
  end
  
end