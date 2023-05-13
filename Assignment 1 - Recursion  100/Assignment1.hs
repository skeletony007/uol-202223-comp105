-- Do not alter the following line
module Assignment1 (char_to_int, repeat_char, decode, int_to_char, length_char, drop_char, encode, complex_encode, complex_decode) where


-- Part A

 -- HELPER FUNCTIONS

head' :: [a] -> a
head' (x : xs) = x


tail' :: [a] -> [a]
tail' (x : xs) = xs


div' :: Integer -> Integer -> Integer
div' x y
 | x < y     = 0
 | otherwise = 1 + div' (x - y) y


mod' :: Integer -> Integer -> Integer
mod' x y
 | x < y     = x
 | otherwise = mod' (x - y) y


 -- FUNCTIONS

char_to_int :: Char -> Integer
char_to_int char
 | char == '1' = 1
 | char == '2' = 2
 | char == '3' = 3
 | char == '4' = 4
 | char == '5' = 5
 | char == '6' = 6
 | char == '7' = 7
 | char == '8' = 8
 | char == '9' = 9
 | char == '0' = 0


repeat_char :: Char -> Integer -> String
repeat_char c n
 | n == 0    = []
 | otherwise = c : repeat_char c (n - 1)


decode :: String -> String
decode string
 | string == [] = []
 | otherwise    = repeat_char (head' string) (char_to_int(head' (tail' string))) ++ decode (tail' (tail' string))


-- Part B

int_to_char :: Integer -> Char
int_to_char int
 | int == 1 = '1'
 | int == 2 = '2'
 | int == 3 = '3'
 | int == 4 = '4'
 | int == 5 = '5'
 | int == 6 = '6'
 | int == 7 = '7'
 | int == 8 = '8'
 | int == 9 = '9'
 | int == 0 = '0'


length_char :: Char -> String -> Integer
length_char c string
 | (string == []) || (head' string /= c) = 0
 | otherwise                             = 1 + length_char c (tail' string)


drop_char :: Char -> String -> String
drop_char c string
 | (string == []) || (head' string /= c) = string
 | otherwise                             = drop_char c (tail' string)


encode :: String -> String
encode string
 | string == [] = []
 | otherwise    = head' string : (int_to_char (length_char (head' string) string)) : (encode (drop_char (head' string) string))


-- Part C

 -- HELPER FUNCTIONS FOR COMPLEX ENCODE FUNCTION

int_to_string :: Integer -> String
int_to_string int
 | int == 0  = []  -- Note input 0 outputs the empty list
 | otherwise = int_to_string (div' (int - (mod' int 10)) 10) ++ [int_to_char (mod' int 10)]


encode_int_to_string :: Integer -> String
encode_int_to_string int  -- Formats  int_to_string  for use in  complex_encode
 | a == "1"  = []
 | otherwise = a
 where a = int_to_string int


 -- HELPER FUNCTIONS FOR COMPLEX DECODE FUNCTION

length' :: String -> Integer
length' string
 | string == [] = 0
 | otherwise    = 1 + length' (tail' string)


string_to_int :: String -> Integer
string_to_int string
 | string == [] = 0
 | otherwise    = char_to_int (head' string) * (10 ^ (length' string - 1)) + string_to_int (tail' string)


decode_string_to_int :: String -> Integer
decode_string_to_int string = string_to_int string  -- Formats  sting_to_int  for ues in  complex_decode


is_int :: Char -> Bool
is_int char
 | char == '1' = True
 | char == '2' = True
 | char == '3' = True
 | char == '4' = True
 | char == '5' = True
 | char == '6' = True
 | char == '7' = True
 | char == '8' = True
 | char == '9' = True
 | char == '0' = True
 | otherwise   = False


drop_int :: String -> String
drop_int string
 | (string == []) || (is_int (head' string) == False) = string
 | otherwise                                          = drop_int (tail' string)


get_int :: String -> String
get_int string
 | (string == []) || (is_int (head' string) == False) = []
 | otherwise                                          = head' string : (get_int (tail' string))


 -- COMPLEX ENCODE FUNCTION

complex_encode :: String -> String
complex_encode string
 | string == [] = []
 | otherwise    = head' string : (encode_int_to_string (length_char (head' string) string)) ++ (complex_encode (drop_char (head' string) string))


 -- COMPLEX DECODE FUNCTION

complex_decode :: String -> String
complex_decode string
 | string == [] = []
 | get_int (tail' string) == "" = head' string : complex_decode (drop_int (tail' string))
 | otherwise                    = repeat_char (head' string) (decode_string_to_int(get_int (tail' string))) ++ complex_decode (drop_int (tail' string)) 
