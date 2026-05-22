#!/usr/bin/env bash

mountiphone() {
    idevicepair pair
    ifuse /mountables/iphone
    cd /mountables/iphone
}

unmountiphone() {
    fusermount -u /mountables/iphone
}

detectiphone() {
    doas systemctl restart usbmuxd
}
