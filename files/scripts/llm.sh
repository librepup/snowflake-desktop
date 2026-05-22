#!/usr/bin/env bash

# UNFINISHED

helpFunc() {
    echo -e "\
Usage: llm <OPTION>

Options
  serve - Start Ollama
  start <variant> - Start Container, available Options are:
    - ollama
    - ollama-pullable
  stop <variant> - Stop Container, available Options are:
    - ollama
    - ollama-pullable
    "
}

serveFunc() {
    podman start ollama
}

enterFunc() {

}
