-- Making a max function recursively.
-- In the imperative language, we write down an algorithm which is based on how 
-- you might do the manual search for a maximum object in a list. Imagine you 
-- have an array of numbers, you go through each number and update the max seen 
-- so far as you go. But the definition of maximum is:
--   "biggest element of the list"
--   "for any sections of the list, max of the whole is the max of the max of sections"
maximum' :: (Ord a) => [a] -> a
maximum' []  = error "No maximum or empty list."
maximum' [x] = x -- base case
maximum' (x:rest)
  | x > maxOfRest = x
  | otherwise     = maxOfRest
  where maxOfRest = maximum' rest

-- since Haskell supports infinite lists, we can write infinite recurssions and use them
repeat' :: a -> [a]
repeat' a = a:repeat' a

-- This notion of writing the definition rather than writing an algotihm leads 
-- to very powerful and elegant ways of expressing typically complex things.
-- Here we implement quick sort, a classic of Haskell.
-- Quick sort is, this definition of a sorted list:
--   A sorted list is one where for an element you chose, the things to the left
--   are less than it and in order (sorted), the things to the right are bigger 
--   and in order (also sorted). But empty is just empty.
quickSort :: (Ord a) => [a] -> [a]
quickSort [] = []
quickSort (x:rest) = 
  let leftSmallerStuff = quickSort [ a | a <- rest, a <= x]
      rightBiggerStuff = quickSort [ a | a <- rest, a > x]
  in  leftSmallerStuff ++ [x] ++ rightBiggerStuff
