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

let () =
  let serial = get_serial "11.input" in
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
  Printf.printf "Part 1: %d,%d\n" ((fst !best) + 1) ((snd !best) + 1);;
