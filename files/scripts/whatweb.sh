#!/usr/bin/env bash

nix-shell -p whatweb --run 'whatweb --plugin Plandora,D-Link-Router,Router -u="admin:netbsd" "http://10.33.70.164/Tools/System.asp" --follow-redirect=always --header "Content-Type: application/x-www-form-urlencoded"'
