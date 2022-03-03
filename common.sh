#!/bin/bash

function check4root {
    local USER=$(whoami)

    if [ "$USER" != "root" ]; then
        echo "Must run as root"
        exit 1
    fi
}
