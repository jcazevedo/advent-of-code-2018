use "collections"
use "files"

primitive Goblin
primitive Elf
type UnitType is (Goblin | Elf)

class Unit is Comparable[Unit]
  var i: I32
  var j: I32
  var t: UnitType
  var ap: I32
  var hp: I32

  new create(i': I32, j': I32, t': UnitType, ap': I32, hp': I32) =>
    i = i'
    j = j'
    t = t'
    ap = ap'
    hp = hp'

  fun alive(): Bool => hp > 0

  fun clone(): Unit => Unit(i, j, t, ap, hp)

  fun lt(other: box->Unit): Bool =>
    (i < other.i) or ((i == other.i) and (j < other.j))

class State
  var units: Array[Unit ref]
  let grid: Array[String ref]
  var rounds: I32 = 0
  var done: Bool = false
  let directions: Array[(I32, I32)] = [(-1, 0); (0, -1); (0, 1); (1, 0)]

  new create(units': Array[Unit ref], grid': Array[String ref]) =>
    units = units'
    grid = grid'

  fun grid_height(): I32 =>
    grid.size().i32()

  fun grid_width(): I32 =>
    try grid(0)?.size().i32() else 0 end

  fun is_empty(i: I32, j: I32): Bool? =>
    (i >= 0) and
    (i < grid_height()) and
    (j > 0) and
    (j < grid_width()) and
    (grid(i.usize())?(j.usize())? == '.') and
    ((for unit in units.values() do
        if (unit.i == i) and (unit.j == j) and (unit.hp > 0) then
          break unit
        else
          None
        end
      end) is None)

  fun remaining_hit_points(): I32 =>
    var res: I32 = 0
    for unit in units.values() do
      if (unit.hp > 0) then
        res = res + unit.hp
      end
    end
    res

  fun ref attack(unit: Unit)? =>
    var attack_unit: (Unit ref | None) = None
    for dir in directions.values() do
      let pi = unit.i + dir._1
      let pj = unit.j + dir._2
      for other_unit in units.values() do
        if (unit is other_unit) or (unit.t is other_unit.t) or (other_unit.hp <= 0) then
          continue
        elseif (other_unit.i == pi) and (other_unit.j == pj) and ((attack_unit is None) or ((attack_unit as Unit ref).hp > other_unit.hp)) then
          attack_unit = other_unit
        end
      end
    end

    if not(attack_unit is None) then
      let u = attack_unit as Unit ref
      u.hp = u.hp - unit.ap
    end

  fun ref step(env: Env)? =>
    units = Sort[Array[Unit], Unit](units)
    var good_step = true
    for unit in units.values() do
      if unit.hp <= 0 then
        continue
      end

      var m = Map[I32, I32]()
      var p = Map[I32, I32]()
      let start = (unit.i * grid_width()) + unit.j
      m(start) = 0
      p(start) = start
      var q = List[(I32, I32)]()
      q.push((unit.i, unit.j))
      while (q.size() > 0) do
        let current = q.shift()?
        let current_i = (current._1 * grid_width()) + current._2
        for dir in directions.values() do
          let next = (current._1 + dir._1, current._2 + dir._2)
          let next_i = (next._1 * grid_width()) + next._2
          if (is_empty(next._1, next._2)? and not(m.contains(next_i))) then
            m(next_i) = m(current_i)? + 1
            p(next_i) = current_i
            q.push(next)
          end
        end
      end

      var target: (I32 | None) = None
      var enemies: I32 = 0

      for other_unit in units.values() do
        if (other_unit is unit) or (other_unit.t is unit.t) or (other_unit.hp <= 0) then
          continue
        end

        enemies = enemies + 1

        for dir in directions.values() do
          let pi = other_unit.i + dir._1
          let pj = other_unit.j + dir._2
          let d = (pi * grid_width()) + pj
          if (m.contains(d) and ((target is None) or (m(target as I32)? > m(d)?))) then
            target = d
          end
        end
      end

      if not(target is None) then
        var t = target as I32
        while p(t)? != start do
          t = p(t)?
        end
        unit.i = t / grid_width()
        unit.j = t % grid_width()
      end

      attack(unit)?

      good_step = enemies > 0
    end

    if not(good_step) then
      done = true
    else
      rounds = rounds + 1
    end

  fun print(env: Env)? =>
    let new_grid = Array[String ref]
    for line in grid.values() do
      new_grid.push(line.clone())
    end
    for unit in units.values() do
      if unit.hp <= 0 then
        continue
      end
      if unit.t is Goblin then
        new_grid(unit.i.usize())?(unit.j.usize())? = 'G'
      elseif unit.t is Elf then
        new_grid(unit.i.usize())?(unit.j.usize())? = 'E'
      end
    end
    for line in new_grid.values() do
      env.out.print(line.string())
    end

actor Main
  new create(env: Env) =>
    try
      let auth = env.root as AmbientAuth
      let file: File ref = recover File(FilePath(auth, "15.input")?) end
      let lines = file.lines()
      let grid = Array[String ref]
      let units = Array[Unit ref]
      var i: I32 = 0
      for line in lines do
        let original_line: String = consume line
        var j: I32 = 0
        let final_line: String ref = String
        for ch in original_line.values() do
          if ch == 'G' then
            units.push(Unit(i, j, Goblin, 3, 200))
            final_line.push('.')
          elseif ch == 'E' then
            units.push(Unit(i, j, Elf, 3, 200))
            final_line.push('.')
          else
            final_line.push(ch)
          end
          j = j + 1
        end
        grid.push(final_line)
        i = i + 1
      end
      let state = State(units, grid)
      while not(state.done) do
        state.step(env)?
      end
      env.out.print("Part 1: " + (state.rounds * state.remaining_hit_points()).string())
    end
