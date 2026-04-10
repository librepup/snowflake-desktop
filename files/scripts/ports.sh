#!/usr/bin/env bash
# Ports

ports() {
  doas ss -tulnp | awk '
    NR==1 {print; next}
    {printf "%-5s %-20s %-30s %-30s %s\n", $1, $5, $6, $7, $9}'
}
