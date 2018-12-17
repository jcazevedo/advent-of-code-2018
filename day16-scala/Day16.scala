object Day16 extends App {
  sealed trait OpCode {
    def a: Int
    def b: Int
    def c: Int
    def valid: Boolean
    def apply(r: Vector[Int]): Vector[Int]
  }

  sealed trait AllRegistersOpcode extends OpCode {
    def valid = List(a, b, c).forall(x => x >= 0 && x <= 3)
  }

  sealed trait TwoRegistersOpCode extends OpCode {
    def valid = List(a, c).forall(x => x >= 0 && x <= 3)
  }

  case class addr(a: Int, b: Int, c: Int) extends AllRegistersOpcode {
    def apply(r: Vector[Int]) = r.updated(c, r(a) + r(b))
  }

  case class addi(a: Int, b: Int, c: Int) extends TwoRegistersOpCode {
    def apply(r: Vector[Int]) = r.updated(c, r(a) + b)
  }

  case class mulr(a: Int, b: Int, c: Int) extends AllRegistersOpcode {
    def apply(r: Vector[Int]) = r.updated(c, r(a) * r(b))
  }

  case class muli(a: Int, b: Int, c: Int) extends TwoRegistersOpCode {
    def apply(r: Vector[Int]) = r.updated(c, r(a) * b)
  }

  case class banr(a: Int, b: Int, c: Int) extends AllRegistersOpcode {
    def apply(r: Vector[Int]) = r.updated(c, r(a) & r(b))
  }

  case class bani(a: Int, b: Int, c: Int) extends TwoRegistersOpCode {
    def apply(r: Vector[Int]) = r.updated(c, r(a) & b)
  }

  case class borr(a: Int, b: Int, c: Int) extends AllRegistersOpcode {
    def apply(r: Vector[Int]) = r.updated(c, r(a) | r(b))
  }

  case class bori(a: Int, b: Int, c: Int) extends TwoRegistersOpCode {
    def apply(r: Vector[Int]) = r.updated(c, r(a) | b)
  }

  case class setr(a: Int, b: Int, c: Int) extends TwoRegistersOpCode {
    def apply(r: Vector[Int]) = r.updated(c, r(a))
  }

  case class seti(a: Int, b: Int, c: Int) extends TwoRegistersOpCode {
    def apply(r: Vector[Int]) = r.updated(c, a)
  }

  case class gtir(a: Int, b: Int, c: Int) extends OpCode {
    def valid = List(b, c).forall(x => x >= 0 && x <= 3)
    def apply(r: Vector[Int]) = r.updated(c, if (a > r(b)) 1 else 0)
  }

  case class gtri(a: Int, b: Int, c: Int) extends OpCode {
    def valid = List(a, c).forall(x => x >= 0 && x <= 3)
    def apply(r: Vector[Int]) = r.updated(c, if (r(a) > b) 1 else 0)
  }

  case class gtrr(a: Int, b: Int, c: Int) extends AllRegistersOpcode {
    def apply(r: Vector[Int]) = r.updated(c, if (r(a) > r(b)) 1 else 0)
  }

  case class eqir(a: Int, b: Int, c: Int) extends OpCode {
    def valid = List(b, c).forall(x => x >= 0 && x <= 3)
    def apply(r: Vector[Int]) = r.updated(c, if (a == r(b)) 1 else 0)
  }

  case class eqri(a: Int, b: Int, c: Int) extends OpCode {
    def valid = List(a, c).forall(x => x >= 0 && x <= 3)
    def apply(r: Vector[Int]) = r.updated(c, if (r(a) == b) 1 else 0)
  }

  case class eqrr(a: Int, b: Int, c: Int) extends AllRegistersOpcode {
    def apply(r: Vector[Int]) = r.updated(c, if (r(a) == r(b)) 1 else 0)
  }

  object OpCode {
    def all(a: Int, b: Int, c: Int): List[OpCode] = List(
      addr(a, b, c),
      addi(a, b, c),
      mulr(a, b, c),
      muli(a, b, c),
      banr(a, b, c),
      bani(a, b, c),
      borr(a, b, c),
      bori(a, b, c),
      setr(a, b, c),
      seti(a, b, c),
      gtir(a, b, c),
      gtri(a, b, c),
      gtrr(a, b, c),
      eqir(a, b, c),
      eqri(a, b, c),
      eqrr(a, b, c))
  }

  val lines = io.Source.fromFile("16.input").getLines().toList
  val examples = lines.sliding(4, 4).filter(_.head.startsWith("Before:")).count { ll =>
    val regBefore = ll(0).stripPrefix("Before: [").stripSuffix("]").split(", ").toVector.map(_.toInt)
    val ops = ll(1).split(" ").toVector.map(_.toInt)
    val regAfter = ll(2).stripPrefix("After:  [").stripSuffix("]").split(", ").toVector.map(_.toInt)
    val opCodes = OpCode.all(ops(1), ops(2), ops(3))
    opCodes.count(oc => oc.valid && oc(regBefore) == regAfter) >= 3
  }

  println(s"Part 1: $examples")
}
