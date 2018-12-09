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

    Day05)
        g++ -Wall day05-c++/day05.cpp -o day05 && ./day05
        ;;

    Day06)
        ruby day06-ruby/day06.rb
        ;;

    Day07)
        octave day07-octave/day07.m
        ;;

    Day08)
        python day08-python/day08.py
        ;;

    Day09)
        escript day09-erlang/day09.erl
        ;;

    *)
        echo "Unknown or unavailable day"
        exit 1
esac
