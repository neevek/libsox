ANDROID_TOOLCHAIN=$NDK/toolchains/llvm/prebuilt/darwin-x86_64
CC=$ANDROID_TOOLCHAIN/bin/arm-linux-androideabi-gcc
CXX=$ANDROID_TOOLCHAIN/bin/arm-linux-androideabi-g++
LINK=$ANDROID_TOOLCHAIN/bin/arm-linux-androideabi-gcc
AR=$ANDROID_TOOLCHAIN/bin/arm-linux-androideabi-ar
RANLIB=$ANDROID_TOOLCHAIN/bin/arm-linux-androideabi-ranlib
LD=$ANDROID_TOOLCHAIN/bin/arm-linux-androideabi-ld

if [[ ! -f configure ]]; then
  autoreconf -i
fi

./configure \
  --prefix=$(pwd)/androidbuild \
  --with-opus=no \
  --host=arm-none-linux \
  --enable-shared \
  CC=$CC \
  RANLIB=$RANLIB \
  LINK=$LINK \
  AR=$AR \
  LD=$LD \
  CFLAGS="-fPIC" \
  LDFLAGS="-L/Users/ali/Library/Android/sdk/ndk-bundle/toolchains/llvm/prebuilt/darwin-x86_64/sysroot/usr/lib/arm-linux-androideabi/28 -fPIC -avoid-version"

NPROCESSORS=$(getconf NPROCESSORS_ONLN 2>/dev/null || getconf _NPROCESSORS_ONLN 2>/dev/null)
PROCESSORS=${NPROCESSORS:-1}
make clean && make -s -j${PROCESSORS} && make install

# strip the library and change the SONAME of the built shared library in androidbuild/lib
# patchelf --set-soname libsox.so libsox.so.3.0.0
