open !Core

module SS = Set.Make(String)

let order_letters word =
  String.to_list word
  |> List.sort ~compare:Char.compare
  |> String.of_char_list

let no_duplicates password =
  let wordlist = String.split password ~on:' ' in
  let set = SS.of_list wordlist in
  SS.length set = List.length wordlist

let no_anagrams password =
  let wordlist = String.split password ~on:' ' |> List.map ~f:order_letters in
  let set = SS.of_list wordlist in
  SS.length set = List.length wordlist

let count_valid passwords condition =
  List.length (List.filter passwords ~f:condition)

let () =
  let passwords = In_channel.read_lines "input.txt" in

  (* Part one *)
  assert (no_duplicates "aa bb cc dd ee");
  assert (not (no_duplicates "aa bb cc dd aa"));
  assert (no_duplicates "aa bb cc dd aaa");

  printf "Part 1: %d\n" (count_valid passwords no_duplicates);

  (* Part two *)
  assert (no_anagrams "abcde fghij");
  assert (not (no_anagrams "abcde xyz ecdab"));
  assert (no_anagrams "a ab abc abd abf abj");
  assert (no_anagrams "iiii oiii ooii oooi oooo");
  assert (not (no_anagrams "oiii ioii iioi iiio"));

  printf "Part 2: %d\n" (count_valid passwords no_anagrams);
