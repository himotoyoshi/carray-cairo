
module Cairo
  class Surface
  end
  class ImageSurface < Surface
    autoload_method "self.new_from_ca", "carray/graphics/cairo"
    autoload_method "ca", "carray/graphics/cairo"
  end
end
