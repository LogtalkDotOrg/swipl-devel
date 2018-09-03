# Native build

```{bash}
mkdir build
cd build
cmake ..
make -j 8
```

# Cross build

```{bash}
mkdir win64
cd win64
cmake -DCMAKE_TOOLCHAIN_FILE=../cmake/cross/linux_win64.cmake ..
```
