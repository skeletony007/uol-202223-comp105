module Main (get_maze, print_maze, is_wall, place_player, move, can_move, game_loop, get_path, main) where 

import System.Environment

maze_path = "overwrite this with your own path!"

-- Useful code from Lecture 25
-- You may use this freely in your solutions

get :: [String] -> Int -> Int -> Char
get maze x y = (maze !! y) !! x 

modify_list :: [a] -> Int -> a -> [a]
modify_list list pos new =
    let
        before = take  pos    list
        after  = drop (pos+1) list
    in
        before ++ [new] ++ after

set :: [String] -> Int -> Int -> Char -> [String]
set maze x y char = 
    let
        line = maze !! y
        new_line = modify_list line x char
        new_maze = modify_list maze y new_line
    in
        new_maze

---- Part A

-- Question 1

get_maze :: String -> IO [String]
get_maze path = do file <- readFile path
                   return $ lines file

-- Question 2

print_maze :: [String] -> IO ()
print_maze maze = putStrLn $ unlines maze

-- Question 3

is_wall :: [String] -> (Int, Int) -> Bool
is_wall maze (x, y)
 | y < 0 || y >= length maze ||
   x < 0 || x >= length (head maze) ||
   maze !! y !! x == '#' = True
 | otherwise             = False

-- Question 4

place_player :: [String] -> (Int, Int) -> [String]
place_player maze (x, y) = set maze x y '@'

---- Part B

-- Question 5

move :: (Int, Int) -> Char -> (Int, Int)
move (x, y) char
 | char == 'w' = (x    , y - 1)
 | char == 's' = (x    , y + 1)
 | char == 'a' = (x - 1, y    )
 | char == 'd' = (x + 1, y    )
 | otherwise   = (x    , y    )

-- Question 6

can_move :: [String] -> (Int, Int) -> Char -> Bool
can_move maze (x, y) char
 | is_wall maze (x', y') = False
 | otherwise             = True
 where moved = move (x, y) char
       x' = (\(x, _) -> x) moved
       y' = (\(_, y) -> y) moved

-- Question 7

game_loop :: [String] -> (Int, Int) -> IO ()
game_loop maze (x, y) = do print_maze $ place_player maze (x, y)
                           string <- getLine
                           let input = string !! 0
                           if can_move maze (x, y) input
                            then game_loop maze (move (x, y) input)
                            else game_loop maze (x, y)

---- Part C

-- Question 8

shrink_maze :: [String] -> (Int, Int) -> (Int, Int) -> (Int, Int) -> [String]
shrink_maze maze start target (x, y)
 | (x, y) == target               = maze
 | x + 1 < length (head maze)     = next (x + 1, y    ) 
 | x + 1 == length (head maze) &&
   y + 1 < length maze            = next (0    , y + 1)
 where blockable = (length (filter (can_move maze (x, y)) "wsad") <= 1) &&
                   ((x, y) /= start) &&
                   ((x, y) /= target)
       next
        | blockable = shrink_maze (set maze x y '#') start target
        | otherwise = shrink_maze maze               start target

wall_dead_ends :: [String] -> (Int, Int) -> (Int, Int) -> [String]
wall_dead_ends maze start target = shrink_number maze start target 0
 where shrink_number maze start target number
        | number < (length (head maze) - 1) * (length maze - 1) =
           shrink_number (shrink_maze maze start target (0, 0)) start target (number + 1)
        | otherwise = maze

get_path :: [String] -> (Int, Int) -> (Int, Int) -> [(Int, Int)]
get_path maze start target =
 traverse (wall_dead_ends maze start target) start target
 where traverse maze (x, y) target
        | (x, y) == target = [target]
        | otherwise        =
           (x, y) : traverse (set maze x y '#')
           (move (x, y) (head (filter (can_move maze (x, y)) "wsad")))
           target

-- Question 9

print_path :: [String] -> (Int, Int) -> (Int, Int) -> IO ()
print_path maze start target = putStrLn $ unlines $ dot maze (get_path maze start target)
 where dot maze path
        | path == [] = maze
        | otherwise  = dot (repl (head path)) (tail path)
        where repl (x, y) = set maze x y '.'

main :: IO ()
main = do args <- getArgs
          let path = (args !! 0)
          maze <- get_maze path 
          print_path maze (1, 1) ((length (head maze)) - 2, (length maze) - 2)
