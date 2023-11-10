#
# CMake Toolchain file for crosscompiling on ARM.
#
# This can be used when running cmake in the following way:
# cd build
# cmake .. -DCMAKE_TOOLCHAIN_FILE=/media/psf/XFORG/qxx/CrossPlatform/cross-aarch64-qnx.cmake 
# -DOPENSSL_ROOT_DIR=/media/psf/XFORG/qxx/qnx700/target/qnx7/usr/include/openssl -DOPENSSL_SSL_LIBRARY=/media/psf/XFORG/qxx/qnx700/target/qnx7/aarch64le/usr/lib/ 
# -DOPENSSL_CRYPTO_LIBRARY=/media/psf/XFORG/qxx/qnx700/target/qnx7/aarch64le/usr/lib/  -DOPENSSL_INCLUDE_DIR=/media/psf/XFORG/qxx/qnx700/target/qnx7/usr/include/openssl 
# -DCMAKE_BUILD_TYPE=RELEASE
# or
# cmake .. -DCMAKE_TOOLCHAIN_FILE=/media/psf/XFORG/qxx/CrossPlatform/cross-aarch64-qnx.cmake -DOPENSSL_SSL_LIBRARY=/media/psf/XFORG/qxx/qnx700/target/qnx7/aarch64le/usr/lib/ 
# -DOPENSSL_CRYPTO_LIBRARY=/media/psf/XFORG/qxx/qnx700/target/qnx7/aarch64le/usr/lib/ -DOPENSSL_INCLUDE_DIR=/media/psf/XFORG/qxx/qnx700/target/qnx7/usr/include/openssl 
# -DCMAKE_BUILD_TYPE=RELEASE
#
# readelf -h xxxx.a 查看静态库的信息
#
# Target operating system name.

set(CMAKE_SYSTEM_NAME QNX)
set(CMAKE_SYSTEM_VERSION 7.0.0)
set(CMAKE_SYSTEM_PROCESSOR aarch64)
set(TOOLCHAIN QNX)

set(QNX YES)
set(QNX_ARCH aarch64le)

add_definitions(-DQNX)
find_path(QNX_HOST
        NAME usr/bin/qcc
        PATHS $ENV{QNX_HOST}
        NO_CMAKE_PATH
        NO_CMAKE_ENVIRONMENT_PATH
        )

find_path(QNX_TARGET
        NAME usr/include/stdlib.h
        PATHS $ENV{QNX_TARGET}
        NO_CMAKE_PATH
        NO_CMAKE_ENVIRONMENT_PATH)
message(STATUS "QNX HOST is ${QNX_HOST}")
message(STATUS "QNX TARGET is ${QNX_TARGET}")
message(STATUS "QNX gcc is ${QNX_HOST}/usr/bin/nto${CMAKE_SYSTEM_PROCESSOR}-gcc")
set(CMAKE_C_COMPILER ${QNX_HOST}/usr/bin/nto${CMAKE_SYSTEM_PROCESSOR}-gcc)
set(CMAKE_CXX_COMPILER ${QNX_HOST}/usr/bin/nto${CMAKE_SYSTEM_PROCESSOR}-g++)

get_property(cxx_features GLOBAL PROPERTY CMAKE_CXX_KNOWN_FEATURES)
set(CMAKE_CXX_COMPILE_FEATURES ${cxx_features})
set(GLOBAL PROPERTY CMAKE_C_COMPILE_FEATURES ${cxx_features})

message(STATUS "QNX TARGET is ${QNX_TARGET}}")
link_directories(${QNX_TARGET}/aarch64le/usr/lib
        ${QNX_TARGET}/aarch64le/lib
        )

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 -pthread -Wno-write-strings -D_QNX_SOURCE=700 -O2")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -D_QNX_SOURCE=700 -pthread -O2")
#
# Different build system distros set release optimization level to different
# things according to their local policy, eg, Fedora is -O2 and Ubuntu is -O3
# here.  Actually the build system's local policy is completely unrelated to
# our desire for cross-build release optimization policy for code built to run
# on a completely different target than the build system itself.
#
# Since this goes last on the compiler commandline we have to override it to a
# sane value for cross-build here.  Notice some gcc versions enable broken
# optimizations with -O3.
#
message(STATUS "xforg CMAKE_BUILD_TYPE is ${CMAKE_BUILD_TYPE}}")
if (CMAKE_BUILD_TYPE MATCHES RELEASE OR CMAKE_BUILD_TYPE MATCHES Release OR CMAKE_BUILD_TYPE MATCHES release)
	set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -O2")
	set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -O2")
endif()

#-nostdlib
# search programs in the host environment only.
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)

# Search headers and libraries in the target environment only.
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)


