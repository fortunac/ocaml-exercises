(** Order the letters in a word in
 * alphabetical order *)
val order_letters : Core.String.t -> Core.String.t

(** Check to see there are no duplicate words
 * in a passphrase *)
val no_duplicates : Core.String.t -> bool

(** Check to see there are no anagrams in
 * a passphrase, i.e. the letters of a word
 * cannot be rearranged to form another word *)
val no_anagrams : Core.String.t -> bool

(** Counts the number of passphrases in a list
 * that satisfies a condition *)
val count_valid : 'a Core.List.t -> ('a -> bool) -> int
