open !Core
open !Tree

module Integer = struct
  type t = int
  let compare = Pervasives.compare
  let sexp_of_t t = string_of_int t |> Sexp.of_string
  let t_of_sexp sexp = Sexp.to_string sexp |> int_of_string
end

module ST = Tree.Make(String)
module IT = Tree.Make(Integer)

let () =
  let tree1 = ST.empty |> ST.add "a" |> ST.add "b" |> ST.add "c" in
  let tree2 = ST.empty |> ST.add "e" |> ST.add "d" |> ST.add "f" in
  let tree3 = IT.empty |> IT.add  5  |> IT.add  4  |> IT.add  6  in
  let tree4 = IT.empty |> IT.add  1  |> IT.add  2  |> IT.add  3  in

  assert (ST.compare tree1 tree2 = -1);
  assert (IT.compare tree3 tree4 = 1);

  assert (ST.at_depth tree1 2 |> ST.OrdSet.elements = ["b"]);
  assert (ST.at_depth tree2 2 |> ST.OrdSet.elements = ["d"; "f"]);
  assert (IT.at_depth tree3 2 |> IT.OrdSet.elements = [4; 6]);
  assert (IT.at_depth tree4 1 |> IT.OrdSet.elements = [1]);

  printf "All tests succeeded\n"
