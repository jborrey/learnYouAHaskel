-- Pattern matching, common way to write function in Haskell.

-- Basic example case.
sevenFunction :: (Integral a) => a -> String
sevenFunction 7 = "you have 7"       -- most specific cases first
sevenFunction x = "you don't have 7" -- end with the catch all

-- We can define recursion through this too. Order of patterns matter!
factorial :: (Integral a) => a -> a
factorial 0 = 1
factorial n = n * factorial (n-1)

-- PM can also be seen as exploding complex inputs and then directly computing the output.
-- Non-PM way to add coordinates together.
addCoords :: (Num a) => (a, a) -> (a, a) -> (a, a)
addCoords a b = (fst a + fst b, snd a + snd b)

-- The PM way.
addCoords2 :: (Num a) => (a, a) -> (a, a) -> (a, a)
addCoords2 (x1, y1) (x2, y2) = (x1 + x2, y1 + y2)

-- PM works on lists too.
second :: [a] -> a
second []      = error "ERROR: < 1 element in list."
second (_:[])  = error "NERP"
second (_:b:_) = b

-- Can also write the patterns a bit differently.
second2 :: [a] -> a
second2 []     = error "Fail 0"
second2 [_]    = error "Fail 1"
second2 [_, b] = b
-- The failure here is that [1,2] is a non-exhaustive input, cannot pattern match the tail.

-- pattern matching to make a "middle" function.
middle :: [a] -> [a]
middle []     = []                -- even length list
middle (a:[]) = [a]               -- odd length list
middle a = middle (tail (init a)) -- recurse

-- gaurds example
printSign :: (RealFloat a) => a -> String
printSign a
  | a < 0     = "negative"
  | a == 0    = "zero"
  | a > 0     = "positive"
  | otherwise = "NAN"

-- big or small area
areaSize :: (RealFloat a) => a -> a -> String
areaSize a b
  | area < 100 = "small"
  | otherwise    = "big"
  where area = a * b

-- initials function with pattern matchins
initials :: String -> String -> String
initials firstname lastname = [f] ++ "." ++ [l] ++ "."
  where (f:_) = firstname
        (l:_) = lastname

-- where binding a function
coincap :: (RealFloat a) => [(a, a)] -> [a]
coincap coins = [ marketCap price numCoins | (price, numCoins) <- coins]
  where marketCap p nc = p * nc

-- let binding as a block
coneVol :: (RealFloat a) => a -> a -> a
coneVol r h = 
  let baseArea = pi * (r^2)
      adjustedHeight = (1/3) * h
  in  baseArea * adjustedHeight

-- let binding as a crammed expression
rectVol :: (RealFloat a) => a -> a -> a -> a
rectVol l w h = let base = l * h in base * h
















