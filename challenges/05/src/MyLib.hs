module MyLib where

import ExifTool

main :: IO ()
main = withExifTool $ \et -> do
    m <- readMeta et [] "cat.jpg"
    print m
