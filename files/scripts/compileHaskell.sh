#!/usr/bin/env bash

_compile_func() {
    nix-shell -p ghc --run "ghc -o ${_binary_name} ${_file_path}"
}
