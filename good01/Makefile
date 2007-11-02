CC=arm-apple-darwin-gcc
LD=$(CC)
LDFLAGS=-lobjc -framework CoreFoundation -framework Foundation -framework UIKit -framework LayerKit -framework GraphicsServices -framework CoreGraphics

all:    Hello MTouch

Hello:  hello.o HelloApplication.o
	$(LD) $(LDFLAGS) -o $@ $^

MTouch: main.o MTouchApplication.o MTouchView.o
	$(LD) $(LDFLAGS) -o $@ $^

%.o:    %.m
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@

clean:
	rm -f *.o Hello
