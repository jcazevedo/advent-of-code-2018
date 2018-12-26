import java.io.File

sealed class OpCode {
  abstract fun apply(r: IntArray)
}

data class addr(val a: Int, val b: Int, val c: Int): OpCode() {
  override fun apply(r: IntArray) {
    r[c] = r[a] + r[b]
  }
}

data class addi(val a: Int, val b: Int, val c: Int): OpCode() {
  override fun apply(r: IntArray) {
    r[c] = r[a] + b
  }
}

data class mulr(val a: Int, val b: Int, val c: Int): OpCode() {
  override fun apply(r: IntArray) {
    r[c] = r[a] * r[b]
  }
}

data class muli(val a: Int, val b: Int, val c: Int): OpCode() {
  override fun apply(r: IntArray) {
    r[c] = r[a] * b
  }
}

data class banr(val a: Int, val b: Int, val c: Int): OpCode() {
  override fun apply(r: IntArray) {
    r[c] = r[a] and r[b]
  }
}

data class bani(val a: Int, val b: Int, val c: Int): OpCode() {
  override fun apply(r: IntArray) {
    r[c] = r[a] and b
  }
}

data class borr(val a: Int, val b: Int, val c: Int): OpCode() {
  override fun apply(r: IntArray) {
    r[c] = r[a] or r[b]
  }
}

data class bori(val a: Int, val b: Int, val c: Int): OpCode() {
  override fun apply(r: IntArray) {
    r[c] = r[a] or b
  }
}

data class setr(val a: Int, val b: Int, val c: Int): OpCode() {
  override fun apply(r: IntArray) {
    r[c] = r[a]
  }
}

data class seti(val a: Int, val b: Int, val c: Int): OpCode() {
  override fun apply(r: IntArray) {
    r[c] = a
  }
}

data class gtir(val a: Int, val b: Int, val c: Int): OpCode() {
  override fun apply(r: IntArray) {
    r[c] = if (a > r[b]) 1 else 0
  }
}

data class gtri(val a: Int, val b: Int, val c: Int): OpCode() {
  override fun apply(r: IntArray) {
    r[c] = if (r[a] > b) 1 else 0
  }
}

data class gtrr(val a: Int, val b: Int, val c: Int): OpCode() {
  override fun apply(r: IntArray) {
    r[c] = if (r[a] > r[b]) 1 else 0
  }
}

data class eqir(val a: Int, val b: Int, val c: Int): OpCode() {
  override fun apply(r: IntArray) {
    r[c] = if (a == r[b]) 1 else 0
  }
}

data class eqri(val a: Int, val b: Int, val c: Int): OpCode() {
  override fun apply(r: IntArray) {
    r[c] = if (r[a] == b) 1 else 0
  }
}

data class eqrr(val a: Int, val b: Int, val c: Int): OpCode() {
  override fun apply(r: IntArray) {
    r[c] = if (r[a] == r[b]) 1 else 0
  }
}

fun createInstruction(line: String): OpCode? {
  val splits = line.split(" ")
  val a = splits[1].toInt()
  val b = splits[2].toInt()
  val c = splits[3].toInt()
  when (splits[0]) {
    "addr" -> return addr(a, b, c)
    "addi" -> return addi(a, b, c)
    "mulr" -> return mulr(a, b, c)
    "muli" -> return muli(a, b, c)
    "banr" -> return banr(a, b, c)
    "bani" -> return bani(a, b, c)
    "borr" -> return borr(a, b, c)
    "bori" -> return bori(a, b, c)
    "setr" -> return setr(a, b, c)
    "seti" -> return seti(a, b, c)
    "gtir" -> return gtir(a, b, c)
    "gtrr" -> return gtrr(a, b, c)
    "eqir" -> return eqir(a, b, c)
    "eqri" -> return eqri(a, b, c)
    "eqrr" -> return eqrr(a, b, c)
  }
  return null
}

fun minValue(ipReg: Int, instructions: List<OpCode>): Int {
  val reg = intArrayOf(0, 0, 0, 0, 0, 0)

  while (reg[ipReg] >= 0 && reg[ipReg] < instructions.size) {
    if (reg[ipReg] == 28) {
      return reg[1]
    }

    instructions[reg[ipReg]].apply(reg)
    reg[ipReg]++
  }

  return -1
}

fun maxValue(ipReg: Int, instructions: List<OpCode>): Int {
  val reg = intArrayOf(0, 0, 0, 0, 0, 0)
  val visited = mutableMapOf<Int, Int>()
  var prevValue = -1

  while (reg[ipReg] >= 0 && reg[ipReg] < instructions.size) {
    if (reg[ipReg] == 28) {
      visited[reg[1]] = (visited[reg[1]] ?: 0) + 1
      if (visited[reg[1]] == 2) {
        return prevValue
      }
      prevValue = reg[1]
    }

    instructions[reg[ipReg]].apply(reg)
    reg[ipReg]++
  }

  return -1
}

fun main(args: Array<String>) {
  val lines = File("21.input").useLines { it.toList() }
  val instructions = lines.drop(1).map({ l -> createInstruction(l) }).filterNotNull()
  val ipReg = lines[0].split(" ")[1].toInt()
  val part1 = minValue(ipReg, instructions)
  val part2 = maxValue(ipReg, instructions)
  println("Part 1: $part1")
  println("Part 2: $part2")
}
