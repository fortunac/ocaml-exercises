type digits = int list

let parse_input (filename : string) : digits =
  let file_contents = input_line (open_in filename) in
  let char_to_int c = Char.code c - 48 in
  let rec explode i lst =
    if i < 0 then lst
    else explode (i - 1) (char_to_int file_contents.[i] :: lst)
  in
  explode (String.length file_contents - 1) []






let solve_captcha_part_1 digits =
  let rec add_digits lst sum =
    match lst with
    | [hd] when List.hd digits = hd -> sum + hd
    | hd :: nxt :: tl when hd = nxt -> add_digits (nxt :: tl) (sum + hd)
    | _ :: tl -> add_digits tl sum
    | [] -> sum
  in
  add_digits digits 0






let solve_captcha_part_2 (digits : digits) : int =
  let list_length = List.length digits in
  let step index = ((list_length / 2) + index) mod list_length in
  let rec add_digits i sum =
    if i < 0 then sum
    else
      let x, y = (List.nth digits i, List.nth digits (step i)) in
      if x == y then add_digits (i - 1) (x + sum) else add_digits (i - 1) sum
  in
  add_digits (list_length - 1) 0

let () =
  let input = parse_input "input.txt" in
  let result = solve_captcha_part_1 input in
  Printf.printf "Part 1: %d\n" result ;
  let result = solve_captcha_part_2 input in
  Printf.printf "Part 2: %d\n" result
