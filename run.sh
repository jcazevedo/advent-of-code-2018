#!/usr/bin/env bash

case "$1" in
    Day01)
        idris day01-idris/day01.idr -o day01 && ./day01
        ;;

    *)
        echo "Unknown or unavailable day"
        exit 1
esac
