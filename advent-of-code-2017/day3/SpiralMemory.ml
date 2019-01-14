type direction =
  | Up
  | Down
  | Left
  | Right

type cell = {
  x: int;
  y: int;
  value: int
}

let neighbor_sum x y cells =
  let is_neighbor x y c = (abs (c.x - x) < 2) && (abs (c.y - y) < 2) in
  let neighbors = List.filter (is_neighbor x y) cells in
  let vals = List.map (fun c -> c.value) neighbors in
  List.fold_left (+) 0 vals

let get_next_cell1 c direction =
  match direction with
  | Up    -> {c with y= c.y + 1; value= c.value + 1}
  | Down  -> {c with y= c.y - 1; value= c.value + 1}
  | Left  -> {c with x= c.x - 1; value= c.value + 1}
  | Right -> {c with x= c.x + 1; value= c.value + 1}

let get_next_cell2 c direction visited_cells =
  match direction with
  | Up    -> {c with y= c.y + 1; value= neighbor_sum c.x (c.y + 1) visited_cells}
  | Down  -> {c with y= c.y - 1; value= neighbor_sum c.x (c.y - 1) visited_cells}
  | Left  -> {c with x= c.x - 1; value= neighbor_sum (c.x - 1) c.y visited_cells}
  | Right -> {c with x= c.x + 1; value= neighbor_sum (c.x + 1) c.y visited_cells}

let get_next_direction d =
  match d with
  | Up    -> Left
  | Down  -> Right
  | Left  -> Down
  | Right -> Up

let manhattan_distance target =
  let starting_cell = {x= 0; y= 0; value= 1} in
  let rec spiral_out cell direction steps_per_direction steps_left turn_count =
    if cell.value = target then
      (* Arrived at the target cell *)
      abs cell.x + abs cell.y
    else if steps_left = 0 then
      (* Turn in a new direction *)
      let next_direction = get_next_direction direction in
      if turn_count mod 2 = 0 then
        spiral_out cell next_direction steps_per_direction steps_per_direction
          (turn_count + 1)
      else
        spiral_out cell next_direction (steps_per_direction + 1)
          (steps_per_direction + 1) (turn_count + 1)
    else
      (* Take step forward in the grid *)
      let next_cell = get_next_cell1 cell direction in
      spiral_out next_cell direction steps_per_direction (steps_left - 1) turn_count
  in
  spiral_out starting_cell Right 1 1 0


let first_larger_cell target =
  let starting_cell = {x= 0; y= 0; value= 1} in
  let rec spiral_out cell visited_cells direction steps_per_direction steps_left turn_count =
    if cell.value > target then
      (* Arrived at the target cell *)
      cell.value
    else if steps_left = 0 then
      (* Turn in a new direction *)
      let next_direction = get_next_direction direction in
      if turn_count mod 2 = 0 then
        spiral_out cell visited_cells next_direction steps_per_direction
          steps_per_direction (turn_count + 1)
      else
        spiral_out cell visited_cells next_direction (steps_per_direction + 1)
          (steps_per_direction + 1) (turn_count + 1)
    else
      (* Take step forward in the grid *)
      let next_cell = get_next_cell2 cell direction visited_cells in
      spiral_out next_cell (next_cell :: visited_cells) direction steps_per_direction
        (steps_left - 1) turn_count
  in
  spiral_out starting_cell [starting_cell] Right 1 1 0

let () =
  assert (manhattan_distance 1 = 0);
  assert (manhattan_distance 12 = 3);
  assert (manhattan_distance 23 = 2);
  assert (manhattan_distance 1024 = 31);

  Printf.printf "Part 1: %d\n" (manhattan_distance 289326);
  Printf.printf "Part 2: %d\n" (first_larger_cell 289326);
