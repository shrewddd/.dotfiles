#!/bin/bash

CONFIG="$HOME/.config/aerospace/aerospace.toml"

CURRENT=$(grep "outer.top" "$CONFIG" | awk -F'= ' '{print $2}')

if [ "$CURRENT" -eq 10 ]; then
    NEW=40
else
    NEW=10
fi

sed -i '' "s/outer.top = .*/outer.top = $NEW/" "$CONFIG"

aerospace reload-config
