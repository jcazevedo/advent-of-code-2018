package main

import (
	"fmt"
	"io/ioutil"
	"strconv"
	"strings"
)

type instruction struct {
	apply func([]int)
	a int
	b int
	c int
}

func NewInstruction(line string) *instruction {
	splits := strings.Split(line, " ")
	a, _ := strconv.Atoi(splits[1])
	b, _ := strconv.Atoi(splits[2])
	c, _ := strconv.Atoi(splits[3])
	i := &instruction{a: a, b: b, c: c}
	switch splits[0] {
	case "addr":
		i.apply = i.applyAddr
	case "addi":
		i.apply = i.applyAddi
	case "mulr":
		i.apply = i.applyMulr
	case "muli":
		i.apply = i.applyMuli
	case "banr":
		i.apply = i.applyBanr
	case "bani":
		i.apply = i.applyBani
	case "borr":
		i.apply = i.applyBorr
	case "bori":
		i.apply = i.applyBori
	case "setr":
		i.apply = i.applySetr
	case "seti":
		i.apply = i.applySeti
	case "gtir":
		i.apply = i.applyGtir
	case "gtri":
		i.apply = i.applyGtri
	case "gtrr":
		i.apply = i.applyGtrr
	case "eqir":
		i.apply = i.applyEqir
	case "eqri":
		i.apply = i.applyEqri
	case "eqrr":
		i.apply = i.applyEqrr
	}
	return i
}

func (a *instruction) applyAddr(reg []int) {
	reg[a.c] = reg[a.a] + reg[a.b]
}

func (a *instruction) applyAddi(reg []int) {
	reg[a.c] = reg[a.a] + a.b
}

func (a *instruction) applyMulr(reg []int) {
	reg[a.c] = reg[a.a] * reg[a.b]
}

func (a *instruction) applyMuli(reg []int) {
	reg[a.c] = reg[a.a] * a.b
}

func (a *instruction) applyBanr(reg []int) {
	reg[a.c] = reg[a.a] & reg[a.b]
}

func (a *instruction) applyBani(reg []int) {
	reg[a.c] = reg[a.a] & a.b
}

func (a *instruction) applyBorr(reg []int) {
	reg[a.c] = reg[a.a] | reg[a.b]
}

func (a *instruction) applyBori(reg []int) {
	reg[a.c] = reg[a.a] | a.b
}

func (a *instruction) applySetr(reg []int) {
	reg[a.c] = reg[a.a]
}

func (a *instruction) applySeti(reg []int) {
	reg[a.c] = a.a
}

func (a *instruction) applyGtir(reg []int) {
	if a.a > reg[a.b] {
		reg[a.c] = 1
	} else {
		reg[a.c] = 0
	}
}

func (a *instruction) applyGtri(reg []int) {
	if reg[a.a] > a.b {
		reg[a.c] = 1
	} else {
		reg[a.c] = 0
	}
}

func (a *instruction) applyGtrr(reg []int) {
	if reg[a.a] > reg[a.b] {
		reg[a.c] = 1
	} else {
		reg[a.c] = 0
	}
}

func (a *instruction) applyEqir(reg []int) {
	if a.a == reg[a.b] {
		reg[a.c] = 1
	} else {
		reg[a.c] = 0
	}
}

func (a *instruction) applyEqri(reg []int) {
	if reg[a.a] == a.b {
		reg[a.c] = 1
	} else {
		reg[a.c] = 0
	}
}

func (a *instruction) applyEqrr(reg []int) {
	if reg[a.a] == reg[a.b] {
		reg[a.c] = 1
	} else {
		reg[a.c] = 0
	}
}

func main() {
	data, _ := ioutil.ReadFile("19.input")
	lines := strings.Split(strings.Trim(string(data), " \n"), "\n")
	var instructions = make([]*instruction, len(lines) - 1)
	var reg []int = make([]int, 6)
	for i := 1; i < len(lines); i++ {
		instructions[i - 1] = NewInstruction(lines[i])
	}
	var splits = strings.Split(lines[0], " ")
	ipReg, _ := strconv.Atoi(splits[1])
	for reg[ipReg] >= 0 && reg[ipReg] < len(instructions) {
		instructions[reg[ipReg]].apply(reg)
		reg[ipReg]++
	}
	regStr := strconv.Itoa(reg[0])
	fmt.Println("Part 1: " + regStr)
}
