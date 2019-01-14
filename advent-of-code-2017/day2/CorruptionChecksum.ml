open Std

type spreadsheet = int list list

let read_input (filename : string) : spreadsheet =
  let file_contents = Std.input_list (open_in filename) in
  let split_line (line : string) : int list =
    List.map int_of_string (String.split_on_char '\t' line)
  in
  List.map split_line file_contents

let checksum_part_1 (spreadsheet : spreadsheet) : int =
  let calculate_difference (numbers : int list) : int =
    let min_number = List.fold_right min numbers (List.hd numbers) in
    let max_number = List.fold_right max numbers (List.hd numbers) in
    max_number - min_number
  in
  List.fold_left ( + ) 0 (List.map calculate_difference spreadsheet)

let checksum_part_2 (spreadsheet : spreadsheet) : int =
  let is_divisible x y = x mod y = 0 || y mod x = 0 in
  let divide x y = max x y / min x y in
  let rec calculate_quotient numbers =
    match numbers with
    | [] -> raise Not_found
    | hd :: tl ->
        let rec find_divisor x y rest =
          match y with
          | [] -> calculate_quotient rest
          | a :: b ->
              if is_divisible x a then divide x a else find_divisor x b rest
        in
        find_divisor hd tl tl
  in
  List.fold_left ( + ) 0 (List.map calculate_quotient spreadsheet)

let () =
  let file_contents = read_input "input.txt" in
  let result1 = checksum_part_1 file_contents in
  let result2 = checksum_part_2 file_contents in
  Printf.printf "Part 1: %d\n" result1 ;
  Printf.printf "Part 2: %d\n" result2
