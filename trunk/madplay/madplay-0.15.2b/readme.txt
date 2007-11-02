# our port of madplay to iphone... libmad & libid3 are easy compiles, this required writing a custom audio_iphone to output based upon the NES.app code for sound output.  Prebuffers with a solid tone then outputs the decoded mp3! works!

# compiling steps require the runme* series


#our configure command that doesn't use any ARM-specific stuff (has trouble w/the community's gcc-llvm right now)

LDFLAGS=-L. CPPFLAGS=-I./ CC=/usr/local/bin/arm-apple-darwin-gcc CXXCPP=/usr/local/bin/arm-apple-darwin-cpp RANLIB=/usr/local/bin/arm-apple-darwin-ranlib ./configure --disable-aso --host=arm --with-libiconf-prefix=/Users/aaron/iphonedev/root/usr
#hey, ./configure runs now

#good04 = plays basic tone!   some issues, like silence and headphone jack screws it up.
#plays an mp3!!!!
