open! Core
open! Tree
open! OUnit2

module Integer = struct
  type t = int
  let compare = Pervasives.compare
  let sexp_of_t t = string_of_int t |> Sexp.of_string
  let t_of_sexp sexp = Sexp.to_string sexp |> int_of_string
end

module ST = Tree.Make (String)
module IT = Tree.Make (Integer)

let tree1 = ST.empty |> ST.add "a" |> ST.add "b" |> ST.add "c"
let tree2 = ST.empty |> ST.add "e" |> ST.add "d" |> ST.add "f"
let tree3 = IT.empty |> IT.add 5 |> IT.add 4 |> IT.add 6
let tree4 = IT.empty |> IT.add 1 |> IT.add 2 |> IT.add 3

let string_compare t1 t2 expected _ =
  let result = ST.compare t1 t2 in
  assert_equal expected result ~printer:string_of_int

let int_compare t1 t2 expected _ =
  assert_equal expected (IT.compare t1 t2) ~printer:string_of_int

let string_at_depth t depth expected _ =
  let result = ST.at_depth t depth |> ST.OrdSet.elements in
  assert_equal expected result

let int_at_depth t depth expected _ =
  let result = IT.at_depth t depth |> IT.OrdSet.elements in
  assert_equal expected result

let compare = [
    "tree1 < tree2" >:: string_compare tree1 tree2 (-1);
    "tree2 > tree1" >:: string_compare tree2 tree1 1;
    "tree1 = tree1" >:: string_compare tree1 tree1 0;
    "tree3 > tree4" >:: int_compare tree3 tree4 1;
    "tree3 = tree3" >:: int_compare tree3 tree3 0
  ]

let at_depth = [
    "tree1 2" >:: string_at_depth tree1 2 ["b"];
    "tree2 2" >:: string_at_depth tree2 2 ["d"; "f"];
    "tree3 2" >:: int_at_depth tree3 2 [4; 6];
    "tree4 1" >:: int_at_depth tree4 1 [2]
  ]

let suite =
  "Trees" >::: [
    "Compare" >::: compare;
    "At Depth" >::: at_depth
  ]

let () = run_test_tt_main suite
