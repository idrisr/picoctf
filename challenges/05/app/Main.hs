{-# LANGUAGE OverloadedStrings #-}

module Main where

import Data.Text (Text, unpack)
import qualified ExifTool as ET
import Data.Text.Encoding.Base64
import System.Environment

-- ExifTool Version Number         : 12.62
-- File Name                       : cat.jpg
-- Directory                       : .
-- File Size                       : 878 kB
-- File Modification Date/Time     : 2021:03:15 13:24:46-05:00
-- File Access Date/Time           : 2023:07:01 11:35:17-05:00
-- File Inode Change Date/Time     : 2023:07:01 11:35:04-05:00
-- File Permissions                : -rw-r--r--
-- File Type                       : JPEG
-- File Type Extension             : jpg
-- MIME Type                       : image/jpeg
-- JFIF Version                    : 1.02
-- Resolution Unit                 : None
-- X Resolution                    : 1
-- Y Resolution                    : 1
-- Current IPTC Digest             : 7a78f3d9cfb1ce42ab5a3aa30573d617
-- Copyright Notice                : PicoCTF
-- Application Record Version      : 4
-- XMP Toolkit                     : Image::ExifTool 10.80
-- License                         : cGljb0NURnt0aGVfbTN0YWRhdGFfMXNfbW9kaWZpZWR9
-- Rights                          : PicoCTF
-- Image Width                     : 2560
-- Image Height                    : 1598
-- Encoding Process                : Baseline DCT, Huffman coding
-- Bits Per Sample                 : 8
-- Color Components                : 3
-- Y Cb Cr Sub Sampling            : YCbCr4:2:0 (2 2)
-- Image Size                      : 2560x1598
-- Megapixels                      : 4.1

data Foo = Foo
    { license :: Text
    , rights :: Text
    , version :: Integer
    }
    deriving (Show)

myDecode:: Maybe Foo ->  Either Text Text
myDecode (Just x) = decodeBase64 $ rights x
myDecode Nothing = Left ""

printer :: Either Text Text -> Text
printer (Left _) = ""
printer (Right x) = x

tags :: ET.Metadata -> Maybe Foo
tags m =
    Foo
        <$> ET.get (ET.Tag "Rights") m
        <*> ET.get (ET.Tag "License") m
        <*> ET.get (ET.Tag "ColorComponents") m

main :: IO ()
main =  do
    (x:_) <- getArgs
    ET.withExifTool $ \et -> do
        m <- ET.readMeta et [] x
        putStrLn $ unpack $ (printer . myDecode . tags) m
