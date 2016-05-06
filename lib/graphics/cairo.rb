# ----------------------------------------------------------------------------
#
#  carray/graphics/cairo.rb
#
#  This file is part of Ruby/CArray extension library.
#  You can redistribute it and/or modify it under the terms of
#  the Ruby Licence.
#
#  Copyright (C) 2005-2008  Hiroki Motoyoshi
#
# ----------------------------------------------------------------------------

require "cairo"
require "carray/carray_cairo"

class Cairo::ImageSurface
  
  def self.new_from_ca (ca)
    
    if ca.data_type != CA_UINT8
      raise "invalid data_type for Cairo::ImageSurface"
    end
    
    case true
    when ( ca.rank == 2 ),
         ( ( ca.rank == 3 ) and ( ca.dim2 == 1 ) )
      image_type = Cairo::FORMAT_A8
      img = Cairo::ImageSurface.new(image_type, ca.dim1, ca.dim0)
      img.ca[] = ca
    when ( ca.data_type == CA_UINT8 and ca.rank == 3 and ca.dim2 == 3 )
      image_type = Cairo::FORMAT_RGB24
      img = Cairo::ImageSurface.new(image_type, ca.dim1, ca.dim0)
      img.ca[] = ca
    when ( ca.data_type == CA_UINT8 and ca.rank == 3 and ca.dim2 == 4 )
      image_type = Cairo::FORMAT_ARGB32
      img = Cairo::ImageSurface.new(image_type, ca.dim1, ca.dim0)
      img.ca[] = ca
    else
      raise "invalid shape of carray to create Cairo::ImageSurface"
    end

    return img
  end
  
  def to_ca
    return ca.to_ca
  end
  
end