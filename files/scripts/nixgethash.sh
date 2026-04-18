#!/bin/sh

nixgethash() {
  if [ $# -eq 0 ]; then
      echo "Please provide a URL to Fetch (.tar.gz, or Git Repo)."
      return 1
  fi

  arg=$1

  if [[ "$arg" == *.tar.gz* ]]; then
      hash=$(nix-prefetch-url --unpack "$arg")
      sha256=$(nix hash convert --hash-algo sha256 "$hash")
      fin="$sha256"
  elif [[ "$arg" == *git* ]]; then
      hash=$(nix-prefetch-git --quiet "$arg" | grep "\"hash\": \"" | awk '{print $2}' | sed 's/\"//g' | sed 's/,//g')
      fin="$hash"
  else
      echo "Error: Don't know how to Fetch."
      return 1
  fi

  echo -e "URL: ${arg}\nSha256-Hash: ${fin}\n"
}
