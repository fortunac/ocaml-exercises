open !Core

module type T = sig
  module OrdSet : Set.S
  type elt
  type t
  val compare : t -> t -> int
  val empty : t
  val add : elt -> t -> t
  val at_depth : t -> int -> OrdSet.t
end

module Make (Ord : Set.Elt) = struct

  module OrdSet = Set.Make(Ord)

  type elt = Ord.t

  type t =
    | Null
    | Node of elt * t * t

  let compare (x : t) (y : t) : int =
    match x, y with
    | Null,           Null           -> 0
    | Null,           Node _         -> -1
    | Node _,         Null           -> 1
    | Node (a, _, _), Node (b, _, _) -> Ord.compare a b

  let empty = Null

  let rec add (x : elt) (tree : t) : t =
    match tree with
    | Null -> Node (x, Null, Null)
    | Node (y, l, r) as node ->
        let comparison = Ord.compare x y in
        if comparison < 0 then
          Node (y, add x l, r)
        else if comparison > 0 then
          Node (y, l, add x r)
        else (* no duplicate nodes *)
          node

  let at_depth (tree : t) (depth : int) : OrdSet.t =
    let rec traverse tree set level =
      match tree with
      | Null -> set
      | Node (x, l, r) ->
          if level = depth then
            OrdSet.add set x
          else
            traverse l (traverse r set (level + 1)) (level + 1)
    in
    traverse tree OrdSet.empty 1

end
