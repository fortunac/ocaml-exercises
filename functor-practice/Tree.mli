(** data types that can be ordered *)
module type OrderedType =
  sig
    (** type of elements *)
    type t

    (** compare the order of two order types *)
    val compare : t -> t -> int

    (** sexp of the ordered type *)
    val sexp_of_t : t -> Ppx_sexp_conv_lib.Sexp.t

    (** generates ordered type from sexp *)
    val t_of_sexp : Ppx_sexp_conv_lib.Sexp.t -> t
  end

(** Binary tree over the order types *)
module T :
  functor (Ord : OrderedType) ->
    sig
      (** type of ordered elements *)
      type elt

      (** the tree type *)
      type 'a t

      (** compare two trees *)
      val compare : elt t -> elt t -> int

      (** the empty tree *)
      val empty : elt t

      (** adds an element into the tree in order *)
      val add : elt -> elt t -> elt t

      (** a set of elt at a certain depth of the tree *)
      val at_depth :
        elt t ->
        int ->
        (elt, Core_kernel__Set.Make(Ord).Elt.comparator_witness) Base.Set.t
    end
