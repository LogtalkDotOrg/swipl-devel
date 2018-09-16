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

# Issues

  - Build documention
    - online plain text manual?
  - Test Darwin and MinGW cross compilation
  - Create installers
  - Install .qlf files
  - Install pkg-config files
  - Build library index after installation
