# [learnYouAHaskell](http://learnyouahaskell) - work from learning Haskell

Thank you Miran Lipovača!

### Contents
* [Lesson 1 - Starting Out](/lesson1_startingOut)


### The repl
* Start with `ghci`.
* Load and _compile_ a source code file into the process' address space - `:l <file_path>`.
* Reload currently linked files - `:r`.
* Display the type of a piece of data - `:t <data>`. `<data>` can also be a function name.

## General Notes

#### Two function types:
  - _prefix_ which is like a traditional function name followed by arguments (`fx_name A B C`). The function is prefix to the data.
  - _infix_ which is like an _operator_ such as `A + B`. The function is _inbetween_ the data. With backticks, we can usa a binomial function as an _infix_ or even define _infix_ functions(`div A B` → ``A `div` B``).
  - Functions/operators of only special characters (`+`, `*`, `/=` ...) are considered _infix_ by default. To write them as _prefix_ we must surround them in parentheses, `(+) 1 2` gives 3.
  - _polymorphic_ when a function uses a _type variable_ and therefore has a loose declaration.

#### Some translations from C:
  - `!=` → `/=`
  - Functions/names are immutable. So a function without arguments is a `#define`.
  - array → list - use when you have an arbitrary amount of a type of data.
  - struct → tuple - use when you have structured data representing a specific thing (like a coordinate).
  - void pointer → _type variable_

## Data interface:
  - All hard data types (not variable) have capitalized names.
  - _unit_ is just saying that it is actual data.
  - _constuct_ is some organization of _units_.
  - Later one, we need to discuss/add notes for _boxed_ and _unboxed_ types.
  - Not only can data be variable, but also the types. These are called _type variables_ and functions could be variable in their arguments and return values but have a consistent flow for the types.
    - e.g. `:t fst` → `fst :: (a,b) -> a` which means the return value has the same type as the first value.
    - Allows you to write functions which are a notion around data rather than looking at the actual data. The `head` function is simply "give me the first element of a list" but cares not for the type of the element. So `:t head` → `head :: [a] -> a` where `a` is any type.

|Name|Level|Typeclass (some)|Example|Range|Note|
|----|-----|---------|-------|-----|----|
|Boolean|unit|Enum|`True`, `False`|[`True`,`False`]||
|Int|unit|Enum, Num, Integral|`1`, `7`|\[-2^63, 2^63] (64 bit machine)|Will adapt to float in cases like `1 + 1.0`|
|Integer|unit|Enum, Num, Integeral|`1`, `7`|(-INF, INF)|less efficient than Int|
|Float|unit|Enum, Num, Floating|`3.14`, `1.62`|(-INF, INF)||
|Double|unit|Enum, Num, Floating|`3.14`, `1.62`|(-INF, INF)|Float with double the precision|
|Char|unit|Enum|`'a', `'\11111'`|['\NUL', '\1114111'`|Default supports unicode|
|List|construct||`[1,2,3]`, `['a', 'b', 'c']` → `"abc"`|unbounded|all units have the same type, String is a List of Char|
|Tuple|construct||`(1,2,3)`, `(1, 1.1, 'a')`|single units|heterogeneous types allowed|
|Ordering|construct|Takes elements of Ord|`LT`, `GT` & `EQ`|unbounded|Essentially an enum which denotes order|


### Type Classes

A _type classes_ is a are interfaces that types may implement such that they can be used with functions that have _class constraints_. They specify properties about the data type.
- e.g. `:t (==)` gives `(==) :: (Eq a) => a -> a -> Bool`. The `==` function can only operate on arguments which have types from which bear the Eq type class.
  - The first part of `(Eq a) =>` is a _class constraint_ saying that `a` needs to have the type class for `Eq`.
  - The second part of `a -> a -> Bool` just means the 2 args must have the same type and the return value is a Boolean.
- `:t elem` → `(Eq a) => a -> [a] -> Bool` since it uses `(==)` to determine if an element is in a list.
  - `Eq` supported types implement `==` and `/=`.
  - `Ord` supported types implement `>`, `>=`, `<=`, `<` (ordering stuff). Requires that `Eq` is already satisfied.
  - `Show` supported types can be printed (output in String form). To print, use `show 3` → `"3"`.
  - `Read` (accompanied with function `read`) is the opposite of `Show`. `read` is basically `eval` (Ruby). e.g. `read "3" + 2` gives `5`.
    - Function `read` is a bit special. `:t read` → `read :: (Read a) => String -> a` which means the return value could be anything.
    - If we don't use it directly with another defined type, it won't know how to interpret the returned value and a `no parse` exception.
    - To solve this, we use a _type annotation_ which declares how we want the output to be interpreted. e.g. `read "3" :: Int` gives `3` as type Int.
  - `Enum` are sequentially ordered. Can use `succ`, `pred`, etc.
  - `Bounded` are types with bounds. They are polymorphic since they work on many types. `minBound :: Int` → `-9223372036854775808`, `minBound :: Char` → `'\NUL'`.
  - `Num` are _number like_ classes. Requires that `Eq` and `Show` are already satisfied.
  - `Integral`, as expected, is whole numbers and contains `Int` and `Integer`.
  - `Floating` includes `Float` and `Double`.
- `fromIntegral` is a function to turn (cast) an Integral type into a `Num` so that you can use it with `Floating`. While a piece of data, say `5`, might have a strictest definition of something like `Int` it can be treated with broader definitions right up to type classes themselves which are just interfaces (like `Num`).

## Syntax

* Declarations:
  - You can explicitly declare the IO types of a function (the mapping type) before writing out the function (likes headers in C) (see [def.hs](def.hs)).
  - The difference between `Int -> Int -> Int` and `Int, Int -> Int` is ...
* Functions:
  - `<function name> arg1 arg2 arg3 = <stuff with args>`
  - Function names must start with a lowercase character because ...
* IF:
  - _IF_ branches must always have an `else` claws. This ensures that the _IF_ block is an _expression_ (code that always returns something).

## Lists
- Lists are inherent data structures to the language.
- They can be of any type but must be homogeneous.
- Lists of lists can be of different lengths but not different types of lists. Think about casted pointers in C!
- Concatenation of lists `A` and `B` is defined as `A ++ B` (`O(|A|)`).
- `cons` operator is a perpend insert of a single character. `1:[2,3,4] --> [1,2,3,4]` (`O(1)`).
- You can then assume that `[1,2,3]` is equivalent to `1:2:3:[]`.
- Indexing into a list is with `!!` such that `"abc" !! 1 --> 'b'`.
- Operators `<`, `>`, `<=`, `>=` are defined as working from the head of the list and breaking _on first win_. i.e. `[3,2,1] > [3,2,0] --> True`.
- `head` returns the first element.
- `tail` returns everything after the first element (the head).
- `last` returns the last element.
- `init` returns everything before the last element.
- ^ all of these throw exceptions on empty lists. For the functions below, you don't need to check for the length.
- `length` returns the number (integer) of elements in the list.
- `null` returns `True` if the list is empty.
- `reverse` reverses a list.
- `take <int> <list>` returns the first \<int> number elements for \<list>.
- `drop <int> <list>` returns \<list> without the first \<int> elements.
- `minimum` returns the min element.
- `maximum` returns the max element.
- `sum` returns the sum of all the elements.
- `product` is the production of all elements.
- ``A `elem` B`` tells us if `A` is in the list `B`.
- `[A..B]` returns all sequential elements (if that is defined) from `A` to `B`.
- `[A,B..C]` returns a linear spacing of `A` to `C` with step size of deduced as `B-A`. Floats in these devices often have funky precision errors.
- `cycle` returns an infinite repetition of the list (flattened).
- `repeat <element>` returns an infinite list of the element or is the same as `cycle [<element>]`.
- `replicate A B` returns a list of length `A` with every element being `B`.
- We can write _list comprehensions_ or _mappings_ like so `[x*x | x <- [1..5]]`  which returns `[1,4,9,16,15]`.
  - Predicates can be added (aka _filtering_). `[x*x | x <- [1..5], even (x*x)]` gives all the even squares.
  - Multiple predicates/filters can be added. `[x*x | x <- [1..10], even (x*x), x*x < 50]` gives `[4,16,36]`.
- You should see by now that list comprehensions are a way to implement _loops_. This is also true when it comes to double loops where we supply 2 lists.
  - `[x*y | x <- [1,2,3], y <- [2,2,0]]` gives `[2,2,0,4,4,0,6,6,0]`.
  - A loop is required to compute length, but the element-iterator is not used in the mapping so we denote it as `_`. `length' x = sum[1 | _ <- x]

## Laziness:
- Haskell will operate on actual data and evaluate expressions only when absolutely necessary (when it needs to make a decision).
- We can define infinite lists like `take 3 [1..]`. `[1..]` never finishes computing but since `take 3` requires only a piece, it will finish and return `[1,2,3]`.

## Tuples:
- Length and types (at each index) define the type of tuple.
- There is no _empty_ or _null_ tuple.
- Comparators are defined.
- `fst x` returns the first _component_ of tuple `x`.
- `snd x` returns the second _componet_ of tuple `x`.
- ^ these only work on _pairs_ (tuples with only two components).
- `zip A B` will return a list of pairs where the elements of `A` are paired up with the elements of `B`.

## Calculation by filtering:
- This is common practice in functional programming.
- How do we calculate all the right triangles with integer sides <= 10 and perimetre = 24.
- In an imperative language we would probably have to triple loop and check for both right-ness and the length of the perimeter.
- In Haskell, building from the initial full space to a specific result is a bit more elegant.

```haskell
-- all triangles of integer sides <= 10
[(a,b,c) | a <- [1..10], b <- [1..10], c <- [1..10]]

-- remove the duplicates
[(a,b,c) | a <- [1..10], b <- [1..a], c <- [1..b]]

-- make the triangles right again
[(a,b,c) | c <- [1..10], b <- [1..c], a <- [1..b], a^2 + b^2 == c^2]

-- remove the ones without the target perimeter
[(a,b,c) | c <- [1..10], b <- [1..c], a <- [1..b], a^2 + b^2 == c^2, a+b+c == 24]
```

## Pattern Matching, Guards, Lets & Cases:
- These are concise _case_ statments.
- They should alwasys have a _catch all_ claws at the end to ensure they don't throw exceptions from non-exhaustive pattern input.
- _as patterns_ are patterns which are matched but you also get a reference to the original input - `all@(pieces:of:all)`.
- Guards are the pattern matching version of boolean checks. If one is true, we output that clause.
- We can also name things in guards and define them later (`where` keyword).
- _where bindings_ can even be defined by pattern matching (see the _initials_ function).
- _where bindings_ can also defined entire fuctions which can then be called during the function's block.
- _where bindings_ are local to the function but _let bindings_ are local to only an expression in the function.
- _let_ syntax is `let <bindings> in <expression>`. Because they are _expressions_ you can cram these anywhere in code.
- We also have a _case_ expression (which is really what pattern matchin is) and it can be thrown in anywhere.

## Follow ups
  - Do infinite recursions in haskell stay memory constant as a result of lazy evaluation? Run an experiement with 1 C program and 1 haskell program that both leave out the base case. For haskell, this may simply be an infinite loop.
