Expected to know
================

  

Anonymous functions
-------------------

Functions with no "name"

(\\ **<arguments>** -> **<function body>**)

An anonymous function is used in place of the function name in situations such as **map**, **filter**, **fold**, **scan** where a function may only be called by name once otherwise.

  

Swap
----

swap :: (a -> b -> c) -> (b -> a -> c)
swap f = \\ x y -> f y x

  

Polymorphic Types
-----------------

Encode the fact that an element of an expression does not have a specified type

*   Using **type vaiables**
*   When you fix a type variable once, that variabl is fixed throughout the function

Most higher order functions have a polymorphic type

  

Custom types
------------

The **type** keywrd gives a new name to n existing type

*   All types must start with catital letters

Ex.

type String' = \[Char\]

String' can now be used in place of \[Char\]

  

Indeed any **type annotation** can be assigned a **custom type**

*   Useful to give a **meaningful name**

### Data keyword

The **data** keyword is used to create an entirely new type

data Bool' \= True | False

*   | should be read as "or"
*   each of the values is a **constructor**
*   by default, a new data type is not part of any **class**

Use the **deriving** keyword to make a type part of a class

Ex.

data Direction = North | South | East | West deriving (Show)

Haskel can automatically implement the following **type classes**

*   Show -- will print out the type as shown in the
*   Read -- will parse the type as it is in the code
*   Eq -- the natural definition of equality
*   Ord -- constructors that come first are smaller

data Colour = Red | Blue | Green deriving (Show, Read, Eq, Ord)

\-- More complex constructors can contain other types
data Point = Point Int Int deriving (Show, Read, Eq)

ghci> Point 1 4
Point 1 4

\-- Example function on Point 
shift\_up (Point x y) = Point x (y+1)﻿

  

﻿Zip
----

ghci> :t zip
zip :: \[a\] -> \[b\] -> \[(a,b)\]

Example:

ghci\> zip (1,2,3) "abc" \[(1,'a'),(2,'b'),(3,'c')\] 

  

Higher order functions
----------------------

### Map

ghci> :t map
map :: (a -> b) -> \[a\] -> \[b\]

> Applies a function (any function) to all elements of the list

map <function> <list>

*   the function can have only one argument

i.e. **<function>** :: a -> b

map' :: (a -> b) -> \[a\] -> \[b\]
map' \_ \[\]     = \[\]
map' f (x:xs) = f  x : map' f xs

Example.

ghci> map even \[1..5\]
\[False, True, False, True, False\]﻿

  

### Filter

> Filters things out of the list

filter <boolean test> <list>

  

### Fold foldr foldl foldr1 foldl1

fold**r** is RTL foldr**1** uses the final vlaue of the list to initialize the accumulator

fold**l** is LTR foldl**1** uses the first vlaue of the list to initialize the accumulator

ghci> :t foldr
foldr :: Foldable t => (a -> b -> b) -> b -> t a -> b

ghci> :t foldl
foldl :: Foldable t => (b -> a -> b) -> b -> t a -> b

ghci> :t foldr1
foldr1 :: Foldable t => (a -> a -> a) -> t a -> a

ghci> :t foldl1
foldl1 :: Foldable t => (a -> a -> a) -> t a -> a

General case:

fold**< r / r1 / l / l1 >** **<function>** **<initialising element** if not foldr1 / foldl1 **\> <list>**

  

### Scan scanr scanl

scan**r** is RTL

scan**l** is LTR

  

IO
--

IO code can call functions, functions cannot call IO code

Types

IO String -- result of impure computation

ghci> x <- getLine  -- unboxing String from IO type
asdf
ghci> x
"asdf"
ghci> :t x
x :: String

### The unbox operation

*   the interface between IO code and pure code

### IO unit

IO ()

placeholder for a thing in IO

### Sequencing in IO / IO actions / (imperitive) control flow

get\_and\_print :: IO ()
get\_and\_print = 
 do
  x <- getLine
  y <- getLine
  putStrLn (x ++ " " ++ y) 

  

ghci> get\_and\_print
hello
world
hello world

Genetal case:

**<function name>** =

do

**<IO action>**

**<IO action>**

. . .

**Could also write**

**<function name>** = do **<IO action>**

**<IO action>**

. . .

**because of the** Haskel lauout rule **things of the same level must start on exactly the same column**