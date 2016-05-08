NOTE: This *enables* JIT. This is not that washed down shit that Apple wants.

However, since the arm64 JIT is not complete, you will only get blazing fast speeds on 32-bit iOS devices. :P

How to compile (requires Mac OS X):

```
git submodule update --init
make patch
make
```

Look for `luajit.deb`.
