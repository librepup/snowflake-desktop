#!/usr/bin/env bash

netRouteListIcon() {
    allRoutes=$(ip route show default | sed 's/^[[:space:]][[:space:]][[:space:]]//g' | awk "{print \"Route \"NR\": \"\$5\" (\"\$11\")\"}")
    allRoutesAmount=$(echo ${allRoutes} | wc -l)
    for N in $(seq 1 "$allRoutesAmount"); do
        if [[ "$(nmcli device show $(echo "${allRoutes}" | sed -n ${N}p | awk '{print $3}') 2>/dev/null | grep "GENERAL.TYPE" | awk '{print $2}')" == *"ethernet"* ]]; then
            printf '%s\n' "󰈀"
        elif [[ "$(nmcli device show $(echo "${allRoutes}" | sed -n ${N}p | awk '{print $3}') 2>/dev/null | grep "GENERAL.TYPE" | awk '{print $2}')" == *"wifi"* ]]; then
            printf '%s\n' "󰖩"
        else
            printf '%s\n' ""
        fi
    done
}

netRouteCurrentIcon() {
    currentDeviceType=$(nmcli device show "$(ip route get 1.1.1.1 | awk '{print $5}' | sed ':a;N;$!ba;s/\n//g')" | grep "GENERAL.TYPE" | awk '{print $2}')
    if [[ "$currentDeviceType" == "" ]] || [[ -z $currentDeviceType ]] || ( [[ "$currentDeviceType" != *"ethernet"* ]] && [[ "$currentDeviceType" != *"wifi"* ]] ); then
        echo -e "Error: No Device Found"
        return 1
    fi
    if [[ "$currentDeviceType" == *"ethernet"* ]]; then
        printf '%s\n' "󰈀"
    elif [[ "$currentDeviceType" == *"wifi"* ]]; then
        printf '%s\n' "󰖩"
    else
        printf '%s\n' ""
    fi
}

netRoute() {
    arg1=$1
    if [[ "$arg1" == "" ]] || [[ -z $arg1 ]]; then
        echo -e "Usage: netRoute <Command>

Commands:
  list - List Routes
  list-icon - Show Icons Representing Routes
  current - Show Current Route
  current-icon - Show Icon Representing Current Route
  restart <Inteface> - Restart a Network Interface
"
        return 1
    fi
    currentDevice=$(ip route get 1.1.1.1 | awk '{print $5}' | sed ':a;N;$!ba;s/\n//g')
    allRoutes=$(ip route show default | sed 's/^[[:space:]][[:space:]][[:space:]]//g' | awk "{print \"Route \"NR\": \"\$5\" (\"\$11\")\"}")
    routesAmount=$(ip route show default | sed 's/^[[:space:]][[:space:]][[:space:]]//g' | awk "{print \"Route \"NR\": \"\$5\" (\"\$11\")\"}" | wc -l)
    case $routesAmount in
        ''|*[!1-9]*)
            echo -e "Error: No Routes Found"
            return 1
            ;;
        *)
            ;;
    esac
    arg1_lc=$(printf '%s' "$arg1" | tr '[:upper:]' '[:lower:]')
    case $arg1_lc in
        list)
            echo "${allRoutes}"
            return 0
            ;;
        current)
            echo "${currentDevice}"
            return 0
            ;;
        list-icon)
            netRouteListIcon
            return 0
            ;;
        current-icon)
            netRouteCurrentIcon
            return 0
            ;;
        restart)
            arg2=$2
            if [[ "$arg2" == "" ]] || [[ -z $arg2 ]]; then
                echo -e "Error: No Device Specified"
                return 1
            fi
            nmcli device disconnect ${arg2} \
                &>/dev/null \
                > /dev/null \
                && \
                echo -e \
                     "Success: Disconnected Device ${arg2}" \
                    || \
                    echo -e \
                         "Error: Error Disconnecting Device '${arg2}'"
            nmcli device connect ${arg2} \
                &>/dev/null \
                > /dev/null \
                && \
                echo -e \
                     "Success: Connected to Device ${arg2}" \
                    || \
                    echo -e \
                         "Error: Error Connecting to/Starting up Device '${arg2}'"
            return 0
            ;;
        *)
            echo "Error: Unknown Command '${arg1}'"
            echo -e "Usage: netRoute <Command>

Commands:
  list - List Routes
  list-icon - Show Icons Representing Routes
  current - Show Current Route
  current-icon - Show Icon Representing Current Route
  restart <Inteface> - Restart a Network Interface
"
            return 1
            ;;
    esac
}
