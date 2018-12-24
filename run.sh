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
        erlc day09-erlang/day09.erl && erl -noshell -s day09 main -s init stop
        ;;

    Day10)
        Rscript day10-r/day10.R
        ;;

    Day11)
        ocamlopt -o day11 day11-ocaml/day11.ml && ./day11
        ;;

    Day12)
        dart day12-dart/day12.dart
        ;;

    Day13)
        php day13-php/day13.php
        ;;

    Day14)
        elixirc day14-elixir/day14.exs
        ;;

    Day15)
        ponyc day15-pony -b day15 && ./day15
        ;;

    Day16)
        scala day16-scala/day16.scala
        ;;

    Day17)
        swiftc -o day17 day17-swift/day17.swift && ./day17
        ;;

    Day18)
        ghc -o day18 day18-haskell/day18.hs && ./day18
        ;;

    Day19)
        go build day19-go/day19.go && ./day19
        ;;

    *)
        echo "Unknown or unavailable day"
        exit 1
esac
