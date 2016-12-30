-- declaration of a method to remove lowercase chars
removeLowerCase :: [Char] -> [Char]

-- now actually implement the function
removeLowerCase str = [ c | c <- str, c `elem` ['A'..'Z'] ]
