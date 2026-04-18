#!/usr/bin/env bash

_localRandFunc() {
    tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 12
}

websiteDownload() {
    local cmd="$1"
    local arg="$2"
    local origDir="$PWD"
    case "$cmd" in
        1|suckit|si|suck)
            if [ -z "$arg" ]; then
                echo "Usage: websiteDownload 1 <URL>"
                return 1
            fi
            if [[ "$arg" = "--help" || "$arg" = "help" || "$arg" = "h" || "$arg" = "-h" || "$arg" = "-help" ]]; then
                echo "Usage: websiteDownload 1 <URL>"
                return 1
            fi
            _currentRandOut=$(_localRandFunc)
            echo "Created Randomized Directory Name: \"$_currentRandOut\"..."
            mkdir -p ./"$_currentRandOut"
            echo "Created Directory..."
            cd ./"$_currentRandOut"
            echo "Starting Download..."
            suckit "$arg" > /dev/null
            echo -e "Successfully Downloaded:\n - \"$arg\" to (->) \"$_currentRandOut\""
            cd "$origDir"
            return 0
            ;;
        2|httrack|ht|track|htt)
            if [ -z "$arg" ]; then
                echo "Usage: websiteDownload 2 <URL>"
                return 1
            fi
            if [[ "$arg" = "--help" || "$arg" = "help" || "$arg" = "h" || "$arg" = "-h" || "$arg" = "-help" ]]; then
                echo "Usage: websiteDownload 2 <URL>"
                return 1
            fi
            _currentRandOut=$(_localRandFunc)
            mkdir -p ./"$_currentRandOut"
            httrack "$arg" --path "./$_currentRandOut" --no-question --quiet > /dev/null
            echo -e "Successfully Downloaded:\n - \"$arg\" to (->) \"$_currentRandOut\""
            return 0
            ;;
        *|"")
            echo "Usage: websiteDownload <N> <URL>"
            return 1
            ;;
        esac
}
