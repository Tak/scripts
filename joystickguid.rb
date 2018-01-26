#!/usr/bin/env ruby

class JoystickGUID
  EVIOCGID = 0x80084502

  # Derive an SDL-style GUID from bus type, vendor, product, version
  def JoystickGUID::ReadGUID(filename)
    input = [0,0,0,0].pack('SSSS')  
    success = 0
    File.open(filename, File::RDONLY|File::NONBLOCK){ |file|
      success = file.ioctl(EVIOCGID, input)
    }
    bustype, vendor, product, version = input.unpack('SSSS')
    if(0 != success || 0 == vendor || 0 == product || 0 == version) then return nil end
    return format('%02x%02x0000%02x%02x0000%02x%02x0000%02x%02x0000', bustype & 0xFF, bustype >> 8,
                      vendor & 0xFF, vendor >> 8,
                      product & 0xFF, product >> 8,
                      version & 0xFF, version >> 8);
  end
end

if(__FILE__ == $0)
  if(1 != ARGV.length)
    puts("Usage: #{$0} eventDevice")
    exit
  end

  puts("#{ARGV[0]}: #{JoystickGUID::ReadGUID(ARGV[0])}")
end
