#!/usr/bin/env bash

case "$1" in
    1)
        idris --package contrib day01-idris/day01.idr -o day01 && ./day01
        ;;

    2)
        swipl -q -t main day02-prolog/day02.pl
        ;;

    3)
        lua day03-lua/day03.lua
        ;;

    4)
        rustc day04-rust/day04.rs && ./day04
        ;;

    5)
        g++ -Wall day05-c++/day05.cpp -o day05 && ./day05
        ;;

    6)
        ruby day06-ruby/day06.rb
        ;;

    7)
        octave day07-octave/day07.m
        ;;

    8)
        python day08-python/day08.py
        ;;

    9)
        erlc day09-erlang/day09.erl && erl -noshell -s day09 main -s init stop
        ;;

    10)
        Rscript day10-r/day10.R
        ;;

    11)
        ocamlopt -o day11 day11-ocaml/day11.ml && ./day11
        ;;

    12)
        dart day12-dart/day12.dart
        ;;

    13)
        php day13-php/day13.php
        ;;

    14)
        elixirc day14-elixir/day14.exs
        ;;

    15)
        ponyc day15-pony -b day15 && ./day15
        ;;

    16)
        scala day16-scala/day16.scala
        ;;

    17)
        swiftc -o day17 day17-swift/day17.swift && ./day17
        ;;

    18)
        ghc -o day18 day18-haskell/day18.hs && ./day18
        ;;

    19)
        go build day19-go/day19.go && ./day19
        ;;

    20)
        nim c -r -d:release --verbosity:0 day20-nim/day20.nim
        ;;

    21)
        kotlinc day21-kotlin/day21.kt && kotlin Day21Kt
        ;;

    22)
        tsc --lib es6 day22-typescript/day22.ts --outFile day22.js && node day22.js
        ;;

    23)
        perl day23-perl/day23.pl
        ;;

    24)
        javac day24-java/day24.java -d . && java day24
        ;;

    25)
        clj day25-clojure/day25.clj
        ;;

    *)
        echo "Unknown or unavailable day"
        exit 1
esac
