# compiler-explorer-docker-image

A docker-based version of
[Matt Godbolt's Compiler Explorer](https://github.com/mattgodbolt/compiler-explorer)
for local use.

This version is intended to be used to test the latest C++ Standard, therefore
the image only contains modern versions of GCC and Clang. The compilers default
to their latest supported C++ Standard. The Clang compiler uses libc++ by default.

## Setup

The Docker image expects a link to a local libc++ build or installation. Therefore create a symlink like

`ln -s <path/to/libcxx> libcxx`

## Requirements

* Docker
* docker-compose

## Running the docker image

Type in your terminal:

`docker pull mordante/compiler-explorer:latest && docker-compose up -d`

Then point your browser at http://localhost:10240

## License

The code is provided as-is and is in the public domain.
