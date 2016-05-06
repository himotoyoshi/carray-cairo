require "cairo"
require "carray"
require "G"

img = Cairo::ImageSurface.new(:rgb24, 100, 100)
#p Cairo::ImageSurface.new(:a8, 50, 100).ca
data = img.ca
data[nil,nil,1].random!(255)
p img
p img.ca
p img.format
G.open(100,100) 
G { render(img) }
G.update
G.listen()

