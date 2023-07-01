import System.Environment
import Data.Char

rotRel :: Char -> Int -> Char -> Char
rotRel b n c = chr z
    where x = (-) (ord c) (ord b)
          y = (x + n) `mod` 26
          z = ord b + y

rotUpper :: Int -> Char -> Char
rotUpper = rotRel 'A'

rotLower :: Int -> Char -> Char
rotLower = rotRel 'a'

rot :: Int -> Char -> Char
rot n x | isUpper x = rotUpper n x
        | isLower x = rotLower n x
        | otherwise = x

rot13 :: Char -> Char
rot13 = rot 13

main :: IO ()
main = do
    x:_ <- getArgs
    lines <- readFile x
    putStrLn $ map rot13 lines
