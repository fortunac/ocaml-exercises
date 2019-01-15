open !Core

module type T =
  sig
    (** set of ordered elements *)
    module OrdSet : Set.S

    (** type of ordered elements *)
    type elt

    (** the tree type *)
    type t

    (** compare two trees *)
    val compare : t -> t -> int

    (** the empty tree *)
    val empty : t

    (** adds an element into the tree in order *)
    val add : elt -> t -> t

    (** a set of elt at a certain depth of the tree *)
    val at_depth : t -> int -> OrdSet.t
  end

module Make (Ord : Set.Elt) :
  T with type elt = Ord.t and type OrdSet.Elt.t = Ord.t
