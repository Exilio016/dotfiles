#!/usr/bin/env bash

function apply {
    local prog=$1
    if [[ -d "$prog"  && "$prog" != ".git" ]]; then
        echo "Applying config for $prog"
        stow --no-folding "$prog"
    fi
}

if [[ $# -gt 0 ]]; then
    for prog in "$@"; do
        apply "$prog"
    done
else
    for prog in *; do
        apply "$prog"
    done
fi
systemd-tmpfiles --user --create

