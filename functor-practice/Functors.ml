open !Core

module type OrderedType =
  sig
    type t
    val compare: t -> t -> int
    val sexp_of_t: t -> Ppx_sexp_conv_lib.Sexp.t
    val t_of_sexp: Ppx_sexp_conv_lib.Sexp.t -> t
  end

module Tree (Ord: OrderedType) = struct

  type elt = Ord.t

  type 'a t =
    | Null
    | Node of 'a * 'a t * 'a t

  let compare x y =
    match x, y with
    | Null,           Null           -> 0
    | Null,           Node _         -> -1
    | Node _,         Null           -> 1
    | Node (a, _, _), Node (b, _, _) -> Ord.compare a b

  let empty = Null

  let rec add x tree =
    match tree with
    | Null -> Node (x, Null, Null)
    | Node (y, l, r) as node ->
        if (Ord.compare x y) < 0 then
          Node (y, add x l, r)
        else if (Ord.compare x y) > 0 then
          Node (y, l, add x r)
        else
          (* no duplicate nodes *)
          node

  let at_depth t depth =
    let module OrdSet = Set.Make(Ord) in
    let rec traverse t set level =
      match t with
      | Null           -> set
      | Node (x, l, r) ->
          if level = depth then
            OrdSet.add set x
          else
            traverse l (traverse r set (level + 1)) (level + 1)
    in traverse t OrdSet.empty 1

end

(* tests *)
let () =
  let module Integer = struct
    type t = int
    let compare = Pervasives.compare
    let sexp_of_t t = string_of_int t |> Sexp.of_string
    let t_of_sexp sexp = Sexp.to_string sexp |> int_of_string
  end in

  let module ST = Tree(String) in
  let module IT = Tree(Integer) in
  let module SS = Set.Make(String) in
  let module IS = Set.Make(Integer) in

  let tree1 = ST.empty |> ST.add "a" |> ST.add "b" |> ST.add "c" in
  let tree2 = ST.empty |> ST.add "e" |> ST.add "d" |> ST.add "f" in
  let tree3 = IT.empty |> IT.add  5  |> IT.add  4  |> IT.add  6  in
  let tree4 = IT.empty |> IT.add  1  |> IT.add  2  |> IT.add  3  in

  assert (ST.compare tree1 tree2 = -1);
  assert (IT.compare tree3 tree4 = 1);

  assert (ST.at_depth tree1 2 |> SS.elements = ["b"]);
  assert (ST.at_depth tree2 2 |> SS.elements = ["d"; "f"]);
  assert (IT.at_depth tree3 2 |> IS.elements = [4; 6]);
  assert (IT.at_depth tree4 1 |> IS.elements = [1]);
