ISDKP=$(shell xcrun --sdk iphoneos --show-sdk-path)
ICC=$(shell xcrun --sdk iphoneos --find clang)
IOS9_SHIT=-Wl,-segalign,4000
ISDKF=-isysroot $(ISDKP)


all: luajit.deb

patch:
	patch luajit/src/lj_arch.h enable_jit.patch

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

build/luajit: build/luajit_armv7
	@ECHO
	@ECHO MERGING SLICES
	@ECHO
	lipo -arch armv7 build/libluajit_armv7.so -arch arm64 build/libluajit_arm64.so -create -output build/libluajit.so
	lipo -arch armv7 build/luajit_armv7 -arch arm64 build/luajit_arm64 -create -output build/luajit
	ldid -S build/luajit
	ldid -S build/libluajit.so

build/luajit_armv7:
	mkdir -p build
	@ECHO
	@ECHO BUILDING ARMv7
	@ECHO
	cd luajit && $(MAKE) clean
	cd luajit && $(MAKE) DEFAULT_CC=clang HOST_CC="clang -m32 -arch i386" CROSS="`dirname $(ICC)`/" TARGET_FLAGS="-arch armv7 $(ISDKF)" TARGET_SYS=iOS TARGET_LDFLAGS="$(IOS9_SHIT)" XCFLAGS="-DLUAJIT_ENABLE_LUA52COMPAT"
	mv luajit/src/luajit build/luajit_armv7
	mv luajit/src/libluajit.so build/libluajit_armv7.so
	@ECHO
	@ECHO BUILDING ARM64
	@ECHO
	cd luajit && $(MAKE) clean
	cd luajit && make DEFAULT_CC="clang" CROSS="`dirname $(ICC)`/" TARGET_FLAGS="-arch arm64 $(ISDKF)" TARGET_SYS=iOS TARGET_LDFLAGS="$(IOS9_SHIT)" XCFLAGS="-DLUAJIT_ENABLE_LUA52COMPAT"
	mv luajit/src/luajit build/luajit_arm64
	mv luajit/src/libluajit.so build/libluajit_arm64.so

clean:
	cd luajit && $(MAKE) clean
	rm -rf build
