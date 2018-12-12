open Array

let get_serial f =
  let ic = open_in f in
  let line = input_line ic in
  close_in ic;
  int_of_string line;;

let power_level x y s =
  let rack_id = (x + 1) + 10 in
  ((((rack_id * (y + 1) + s) * rack_id) mod 1000) / 100) - 5;;

let grid w h s =
  let m = make_matrix w h 0 in
  for x = 0 to w - 1 do
    for y = 0 to h - 1 do
      m.(x).(y) <- power_level x y s;
    done
  done;
  m;;

let square_value g x y =
  let sum = ref 0 in
  for xi = x to x + 2 do
    for yi = y to y + 2 do
      sum := (!sum + g.(xi).(yi));
    done
  done;
  !sum;;

let part_1 serial =
  let w = 300 in
  let h = 300 in
  let g = grid w h serial in
  let best = ref (0, 0) in
  for x = 0 to w - 3 do
    for y = 0 to h - 3 do
      let best_v = square_value g (fst !best) (snd !best) in
      let curr_v = square_value g x y in
      best := if best_v > curr_v then !best else (x, y);
    done
  done;
  ((fst !best) + 1, (snd !best) + 1);;

let build_dp g =
  let w = length g in
  let h = length g.(0) in
  let dp = make_matrix w h 0 in
  for x = 0 to w - 1 do
    for y = 0 to h - 1 do
      dp.(x).(y) <- g.(x).(y);
      if (x > 0) then dp.(x).(y) <- dp.(x).(y) + dp.(x - 1).(y);
      if (y > 0) then dp.(x).(y) <- dp.(x).(y) + dp.(x).(y - 1);
      if (x > 0 && y > 0) then dp.(x).(y) <- dp.(x).(y) - dp.(x - 1).(y - 1);
    done
  done;
  dp;;

let g_sum dp x y s =
  let sum = ref dp.(x + s - 1).(y + s - 1) in
  if (x > 0) then sum := !sum - dp.(x - 1).(y + s - 1);
  if (y > 0) then sum := !sum - dp.(x + s - 1).(y - 1);
  if (x > 0 && y > 0) then sum := !sum + dp.(x - 1).(y - 1);
  !sum;;

let part_2 serial =
  let w = 300 in
  let h = 300 in
  let g = grid w h serial in
  let dp = build_dp g in
  let best = ref (0, 0, 1) in
  for x = 0 to w - 1 do
    for y = 0 to h - 1 do
      for s = 1 to (min (w - x) (h - y)) do
        let (best_x, best_y, best_s) = !best in
        let curr_best = g_sum dp best_x best_y best_s in
        let curr_sum = g_sum dp x y s in
        if curr_sum > curr_best then best := (x, y, s)
      done
    done;
  done;
  let (x, y, s) = !best in
  (x + 1, y + 1, s);;

let () =
  let serial = get_serial "11.input" in
  let (x1, y1) = part_1 serial in
  let (x2, y2, s) = part_2 serial in
  Printf.printf "Part 1: %d,%d\n" x1 y1;
  Printf.printf "Part 2: %d,%d,%d\n" x2 y2 s;;
