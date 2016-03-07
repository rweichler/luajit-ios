ISDKP=$(shell xcrun --sdk iphoneos --show-sdk-path)
ICC=$(shell xcrun --sdk iphoneos --find clang)
ISDKF=-isysroot $(ISDKP)



all: luajit.deb

luajit.deb: build/luajit build/libluajit.so
	mkdir -p tmp
	mkdir -p tmp/usr
	mkdir -p tmp/usr/local
	mkdir -p tmp/usr/local/lib
	mkdir -p tmp/usr/local/bin
	cp build/luajit tmp/usr/local/bin/
	cp build/libluajit.so tmp/usr/local/lib/libluajit-5.1.2.dylib
	cp -r DEBIAN tmp/
	dpkg-deb -Zgzip -b tmp
	mv tmp.deb $@
	rm -r tmp

build/luajit: build/luajit_armv7
	@ECHO
	@ECHO MERGING SLICES
	@ECHO
	lipo -arch armv7 build/libluajit_armv7.so -arch arm64 build/libluajit_arm64.so -create -output build/libluajit.so
	lipo -arch armv7 build/luajit_armv7 -arch arm64 build/luajit_arm64 -create -output build/luajit

build/luajit_armv7:
	mkdir -p build
	@ECHO
	@ECHO BUILDING ARMv7
	@ECHO
	cd luajit && $(MAKE) clean
	cd luajit && $(MAKE) HOST_CC="clang -m32 -arch i386" CROSS="`dirname $(ICC)`/" TARGET_FLAGS="-arch armv7 $(ISDKF)" TARGET_SYS=iOS
	mv luajit/src/luajit build/luajit_armv7
	mv luajit/src/libluajit.so build/libluajit_armv7.so
	@ECHO
	@ECHO BUILDING ARM64
	@ECHO
	cd luajit && $(MAKE) clean
	cd luajit && make CROSS="`dirname $(ICC)`/" TARGET_FLAGS="-arch arm64 $(ISDKF)" TARGET_SYS=iOS
	mv luajit/src/luajit build/luajit_arm64
	mv luajit/src/libluajit.so build/libluajit_arm64.so

clean:
	cd luajit && $(MAKE) clean
	rm -rf build
