import Control.Monad (unless)
import qualified Data.ByteString.Char8 as BS
import Data.Char (isSpace, chr)
import Network.Socket
import Network.Socket.ByteString (recv)
import Data.List.Split

processIntegers :: Socket -> IO ()
processIntegers sock = loop
  where
    loop = do
        -- Read a line from the socket
        line <- recv sock 1024
        unless (BS.null line) $ do
            -- Process the integer
            let number = mapM (fmap chr) $ processLine line
            case number of
                Just n -> putStrLn n
                Nothing -> putStrLn "Invalid format"
            loop

processLine :: BS.ByteString -> [Maybe Int]
processLine s = fmap readInt xs
    where xs = endBy "\n" $ BS.unpack s

readInt :: String -> Maybe Int
readInt str = case reads str of
    [(n, rest)] | all isSpace rest -> Just n
    _ -> Nothing

main :: IO ()
main = do
    -- Connect to the server
    addrInfo <- head <$> getAddrInfo Nothing (Just "mercury.picoctf.net") (Just "43239")
    sock <- socket (addrFamily addrInfo) Stream defaultProtocol
    connect sock $ addrAddress addrInfo
    -- Read and process integers
    processIntegers sock
    -- Close the socket
    close sock
