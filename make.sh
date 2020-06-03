gcc t/00-struct-sizes.c `pkg-config --cflags goocanvas-2.0` -shared -o t/00-struct-sizes.so `pkg-config --libs goocanvas-2.0`
