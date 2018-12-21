import scala.collection.mutable

object Day16 extends App {
  sealed trait OpCode {
    def name: String
    def apply(r: Vector[Int]): Vector[Int]
  }

  case class addr(a: Int, b: Int, c: Int) extends OpCode {
    def name = "addr"
    def apply(r: Vector[Int]) = r.updated(c, r(a) + r(b))
  }

  case class addi(a: Int, b: Int, c: Int) extends OpCode {
    def name = "addi"
    def apply(r: Vector[Int]) = r.updated(c, r(a) + b)
  }

  case class mulr(a: Int, b: Int, c: Int) extends OpCode {
    def name = "mulr"
    def apply(r: Vector[Int]) = r.updated(c, r(a) * r(b))
  }

  case class muli(a: Int, b: Int, c: Int) extends OpCode {
    def name = "muli"
    def apply(r: Vector[Int]) = r.updated(c, r(a) * b)
  }

  case class banr(a: Int, b: Int, c: Int) extends OpCode {
    def name = "banr"
    def apply(r: Vector[Int]) = r.updated(c, r(a) & r(b))
  }

  case class bani(a: Int, b: Int, c: Int) extends OpCode {
    def name = "bani"
    def apply(r: Vector[Int]) = r.updated(c, r(a) & b)
  }

  case class borr(a: Int, b: Int, c: Int) extends OpCode {
    def name = "borr"
    def apply(r: Vector[Int]) = r.updated(c, r(a) | r(b))
  }

  case class bori(a: Int, b: Int, c: Int) extends OpCode {
    def name = "bori"
    def apply(r: Vector[Int]) = r.updated(c, r(a) | b)
  }

  case class setr(a: Int, b: Int, c: Int) extends OpCode {
    def name = "setr"
    def apply(r: Vector[Int]) = r.updated(c, r(a))
  }

  case class seti(a: Int, b: Int, c: Int) extends OpCode {
    def name = "seti"
    def apply(r: Vector[Int]) = r.updated(c, a)
  }

  case class gtir(a: Int, b: Int, c: Int) extends OpCode {
    def name = "gtir"
    def apply(r: Vector[Int]) = r.updated(c, if (a > r(b)) 1 else 0)
  }

  case class gtri(a: Int, b: Int, c: Int) extends OpCode {
    def name = "gtri"
    def apply(r: Vector[Int]) = r.updated(c, if (r(a) > b) 1 else 0)
  }

  case class gtrr(a: Int, b: Int, c: Int) extends OpCode {
    def name = "gtrr"
    def apply(r: Vector[Int]) = r.updated(c, if (r(a) > r(b)) 1 else 0)
  }

  case class eqir(a: Int, b: Int, c: Int) extends OpCode {
    def name = "eqir"
    def apply(r: Vector[Int]) = r.updated(c, if (a == r(b)) 1 else 0)
  }

  case class eqri(a: Int, b: Int, c: Int) extends OpCode {
    def name = "eqri"
    def apply(r: Vector[Int]) = r.updated(c, if (r(a) == b) 1 else 0)
  }

  case class eqrr(a: Int, b: Int, c: Int) extends OpCode {
    def name = "eqrr"
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

    def apply(name: String, a: Int, b: Int, c: Int): Option[OpCode] =
      all(a, b, c).find(_.name == name)
  }

  val lines = io.Source.fromFile("16.input").getLines().toList
  val examples = lines.sliding(4, 4).filter(_.head.startsWith("Before:")).map { ll =>
    val regBefore = ll(0).stripPrefix("Before: [").stripSuffix("]").split(", ").toVector.map(_.toInt)
    val ops = ll(1).split(" ").toVector.map(_.toInt)
    val regAfter = ll(2).stripPrefix("After:  [").stripSuffix("]").split(", ").toVector.map(_.toInt)
    (regBefore, ops, regAfter)
  }.toList
  val examplesWithCandidates = examples.count { case (b, ops, a) =>
    val opCodes = OpCode.all(ops(1), ops(2), ops(3))
    opCodes.count(_(b) == a) >= 3
  }

  println(s"Part 1: $examplesWithCandidates")

  val program = lines.reverse.takeWhile(_.size > 0).reverse.map { ll =>
    val t = ll.split(" ").map(_.toInt)
    (t(0), t(1), t(2), t(3))
  }

  def hopcroftKarp(mappings: Map[Int, Set[String]]): Map[Int, String] = {
    val visited = mutable.Set[String]()
    val left = mutable.Map[Int, String]()
    val right = mutable.Map[String, Int]()

    def aux(i: Int): Boolean = {
      mappings(i).foreach { j =>
        if (!visited.contains(j)) {
          visited.add(j)
          if (!right.contains(j) || aux(right(j))) {
            left(i) = j
            right(j) = i
            return true
          }
        }
      }
      false
    }

    mappings.foreach { case (i, j) =>
      visited.clear()
      aux(i)
    }

    left.toMap
  }

  val mappings = hopcroftKarp(examples.foldLeft(Map.empty[Int, Set[String]]) { case (m, (b, ops, a)) =>
    val validOpCodes = OpCode.all(ops(1), ops(2), ops(3)).filter(oc => oc(b) == a).map(_.name).toSet
    m.get(ops(0)) match {
      case Some(opcodes) => m.updated(ops(0), opcodes & validOpCodes)
      case None => m + (ops(0) -> validOpCodes)
    }
  })

  val registers = program.foldLeft(Vector(0, 0, 0, 0)) { case (reg, (o, a, b, c)) =>
    OpCode.apply(mappings(o), a, b, c).fold(reg)(_.apply(reg))
  }

  println(s"Part 2: ${registers(0)}")
}
