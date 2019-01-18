open !OUnit2
open !HighEntropyPass

let test_no_duplicates pw _ =
  assert_bool "has duplicates" (HighEntropyPass.no_duplicates pw)

let test_has_duplicates pw _ =
  assert_bool "has no duplicates" (not (HighEntropyPass.no_duplicates pw))

let test_no_anagrams pw _ =
  assert_bool "has anagrams" (HighEntropyPass.no_anagrams pw)

let test_has_anagrams pw _ =
  assert_bool "has no anagrams" (not (HighEntropyPass.no_anagrams pw))

let duplicates =
  [
    "no duplicates" >:: test_no_duplicates "aa bb cc dd ee";
    "aa and aaa" >:: test_no_duplicates "aa bb cc dd aaa";
    "duplicate aa" >:: test_has_duplicates "aa bb cc dd aa";
  ]

let anagrams =
  [
    "no anagrams" >:: test_no_anagrams "abcde fghij";
    "anagrams" >:: test_has_anagrams "abcde xyz ecdab";
    "no anagrams" >:: test_no_anagrams "a ab abc abd abf abj";
    "no anagrams" >:: test_no_anagrams "iiii oiii ooii oooi oooo";
    "anagrams" >:: test_has_anagrams "oiii ioii iioi iio";
  ]

let suite =
  "HighEntropyPass" >::: [
    "Duplicates" >::: duplicates;
    "Anagrams" >::: anagrams;
  ]

let _ = run_test_tt_main suite
