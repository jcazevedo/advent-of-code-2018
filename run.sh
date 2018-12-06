#!/usr/bin/env bash

case "$1" in
    Day01)
        idris --package contrib day01-idris/day01.idr -o day01 && ./day01
        ;;

    Day02)
        swipl -q -t main day02-prolog/day02.pl
        ;;

    Day03)
        lua day03-lua/day03.lua
        ;;

    Day04)
        rustc day04-rust/day04.rs && ./day04
        ;;

    *)
        echo "Unknown or unavailable day"
        exit 1
esac
