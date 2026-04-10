#!/usr/bin/env bash
# Translate Text to English

translate() {
  trans -brief :"en" "$@"
}
