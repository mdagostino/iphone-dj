CC=arm-apple-darwin-gcc
LD=$(CC)
LDFLAGS=-lobjc -framework CoreFoundation -framework AppSupport -framework Foundation -framework UIKit -framework LayerKit -framework GraphicsServices -framework CoreGraphics -framework MultitouchSupport -framework CoreAudio -framework Celestial -framework AudioToolbox


# note: replace "hacked" with the hostname of your iPhone


HOMEDIR=/Users/aaron/iphonedev

MADPLAY=$(HOMEDIR)/madplay/madplay-0.15.2b

LIBMADFLAGS = -L$(MADPLAY) -L$(MADPLAY)/.libs/libmad.a $(MADPLAY)/.libs/libid3tag.a 

CPPFLAGS = -I$(MADPLAY)

PARTYOBJS = MasterAudioController.o PartyApplication.o CompleteView.o TurntableView.o TurntableAudio.o TurntableController.o Stopwatch.o Renderer.o CrossFaderView.o MultiTouchUIImageView.o UIGLView.o

all:   Party

Party: main.o $(PARTYOBJS)
	$(LD) $(LDFLAGS) $(LIBMADFLAGS) -o $@ $^
	#scp Party root@hacked:
	cp Party /Volumes/hacked/

%.o:    %.m
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@

clean:
	rm -f *.o Party





# -L/Users/aaron/iphonedev/madplay/madplay-0.15.2b 
# /Users/aaron/iphonedev/madplay/madplay-0.15.2b/.libs/libmad.a 
# /Users/aaron/iphonedev/madplay/madplay-0.15.2b/.libs/libid3tag.a
#
# -lc 
# -lobjc 
