/* ---------------------------------------------------------------------------

  carray/carray_cairo.c

  This file is part of Ruby/CArray extension library.
  You can redistribute it and/or modify it under the terms of
  the Ruby Licence.

  Copyright (C) 2005-2008  Hiroki Motoyoshi

---------------------------------------------------------------------------- */

#include "ruby.h"
#include <cairo.h>

static VALUE rb_mCairo, rb_cImageSurface;

#include "carray.h"

static VALUE
cr_image_surface_ca (VALUE self)
{
  volatile VALUE obj;
  int32_t  dim[3];
  int      format, width, height, width0;
  unsigned char *data;
  cairo_surface_t *surface;

  Data_Get_Struct (self, cairo_surface_t, surface);

  format = cairo_image_surface_get_format(surface);
  width  = cairo_image_surface_get_width(surface);
  height = cairo_image_surface_get_height(surface);
  data   = cairo_image_surface_get_data(surface);

  switch ( format ) {
  case CAIRO_FORMAT_ARGB32:
  case CAIRO_FORMAT_RGB24:
    dim[0] = height;
    dim[1] = width;
    dim[2] = 4;
    obj = rb_carray_wrap_ptr(CA_UINT8, 3, dim, 0, NULL, (char *)data, self);
    if ( ca_endian == CA_LITTLE_ENDIAN ) {
      obj = rb_funcall(obj, rb_intern("[]"), 2, 
                                 Qfalse, 
                                 rb_range_new(INT2FIX(-1),INT2FIX(0),0));
    }
    break;
  case CAIRO_FORMAT_A8:
    width0 = width + (CA_ALIGN_VOIDP - width % CA_ALIGN_VOIDP);
    dim[0] = height;
    dim[1] = width0;
    obj = rb_carray_wrap_ptr(CA_UINT8, 2, dim, 0, NULL, (char *)data, self);
    obj = rb_funcall(obj, rb_intern("[]"), 2, 
                                 Qnil, 
                                 rb_range_new(INT2FIX(0),INT2NUM(width), 1));
    break;
  case CAIRO_FORMAT_A1:
    rb_raise(rb_eRuntimeError, "can't wrap CAIRO_FORMAT_A1 data by CArray");
  }
  return obj;
}

void
Init_carray_cairo ()
{
  rb_mCairo = rb_const_get(rb_cObject, rb_intern("Cairo"));
  rb_cImageSurface = rb_const_get(rb_mCairo, rb_intern("ImageSurface"));
  rb_define_method(rb_cImageSurface, "ca", cr_image_surface_ca, 0);
}
