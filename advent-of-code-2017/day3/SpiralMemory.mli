type direction = Up | Down | Left | Right

type cell = { x : int; y : int; value : int; }

(** Finds the sum of all the adjacent squares to a cell *)
val neighbor_sum : int -> int -> cell list -> int

(** Finds the next cell in the grid where
 * the value is one higher than the previous cell *)
val get_next_cell1 : cell -> direction -> cell

(** Finds the next cell in the grid where
 * the value is the sum of all of its neighbors *)
val get_next_cell2 : cell -> direction -> cell list -> cell

(** Determines which direction to turn when
 * generating the grid *)
val get_next_direction : direction -> direction

(** Calculates the Manhattan Distance between a target
 * cell and the access port at cell 1 *)
val manhattan_distance : int -> int

(** Finds the first cell that is larger than the
 * inputted target *)
val first_larger_cell : int -> int
