require "mkmf"
require "carray/mkmf"

ENV["PKG_CONFIG_PATH"] = (ENV["PKG_CONFIG_PATH"]||"") + ":/opt/X11/lib/pkgconfig"

if /cygwin|mingw/ =~ RUBY_PLATFORM
  open("Makefile", "w") { |io|
    io << "all:" << "\n"
    io << "install:" << "\n"        
    io << "clean:" << "\n"
    io << "distclean:" << "\n"     
    io << "\trm -rf mkmf.log Makefile" << "\n"     
  }
  exit(0)
end

begin
  have_image_cairo = true
  $CPPFLAGS << " " << `pkg-config --cflags cairo`.chomp
  $LDFLAGS  << " " << `pkg-config --libs cairo`.chomp
  `pkg-config --libs cairo`.chomp.split(/\s+/).uniq.each do |opt|
    case opt
    when /\-l(.*)/
      unless have_library($1)
        have_image_cairo = false
        break
      end
    end
  end
rescue
end

if have_carray()
  if have_header("cairo.h") and have_image_cairo
    create_makefile("carray/carray_cairo")
  else
    open("Makefile", "w") { |io|
      io << "all:" << "\n"
      io << "install:" << "\n"        
      io << "clean:" << "\n"
      io << "distclean:" << "\n"     
      io << "\trm -rf mkmf.log Makefile" << "\n"     
    }
  end
end