**I HAVE A PRECOMPILED VERSION ON THE REPO http://cydia.r333d.com**

The arm64 JIT is still a WIP, so don't be as mind-blowing as on other architectures. Through limited testing, it works pretty well, though!

# Prerequisites

* Mac OS X (duh)
* `dpkg-deb` (`brew install dpkg`)

# Building

```
git submodule update --init
make
```

Look for `luajit.deb`.
