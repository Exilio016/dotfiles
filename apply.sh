#!/usr/bin/env bash

for prog in *; do
    if [[ -d "$prog"  && "$prog" != ".git" ]]; then
        echo "Applying config for $prog"
        stow --no-folding "$prog"
    fi
done

