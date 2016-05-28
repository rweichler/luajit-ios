**I HAVE A PRECOMPILED VERSION ON THE REPO http://cydia.r333d.com**

Since the arm64 JIT is not complete, you will only get JIT on 32-bit. Hopfully Mike Pall finishes it soon.

# Prerequisites

* Mac OS X (duh)
* `dpkg-deb` (`brew install dpkg`)

# Building

```
git submodule update --init
make patch
make
```

Look for `luajit.deb`.
