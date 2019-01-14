open !Core

module type OrderedType =
  sig
    type t
    val compare: t -> t -> int
    val sexp_of_t: t -> Ppx_sexp_conv_lib.Sexp.t
    val t_of_sexp: Ppx_sexp_conv_lib.Sexp.t -> t
  end

module T (Ord: OrderedType) = struct

  type elt = Ord.t

  type t =
    | Null
    | Node of elt * t * t

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

