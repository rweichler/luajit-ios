**I HAVE A PRECOMPILED VERSION ON THE REPO http://cydia.r333d.com**

The arm64 JIT is unstable. But the ffi works.

# Prerequisites

* Mac OS X (duh)
* `dpkg-deb` (`brew install dpkg`)

# Building

```
git submodule update --init
make
```

Look for `luajit.deb`.
