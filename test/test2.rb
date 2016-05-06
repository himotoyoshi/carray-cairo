require "carray"
require "G"

ca = CArray.uint8(100, 100, 4) { 255 }

img = Cairo::ImageSurface.new_from_ca(ca)
p Cairo::FORMAT_ARGB32
p img
img.ca[false, 3] = 255
img.ca[false, 0] = 255
p img.ca
p img.format

G.open(100,100) 
G { render(img, 0.5) }
G.update
G.listen()
