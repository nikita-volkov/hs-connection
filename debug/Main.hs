module Main where

import Debug.Trace
import Data.Default
import Prelude
import qualified Data.ByteString.Char8 as ByteString
import Network.Connection
import System.Exit
import System.Timeout

main = do
  test 1000
  test 30000

test requestSize = do
    putStrLn $ "Testing with request of size " <> show requestSize
    ctx <- initConnectionContext
    con <-
      connectTo ctx $
        ConnectionParams
          { connectionHostname = "apigw.yandexcloud.net",
            connectionPort = 443,
            connectionUseSecure = Just $ def,
            connectionUseSocks = Nothing
          }
    connectionPut con $ ByteString.replicate requestSize 'z'

    res <- timeoutInSeconds 15 $ connectionGetChunk con
    res <- case res of
      Nothing -> die "Timeout"
      Just res -> return res

    putStrLn "Printing response:"
    ByteString.putStrLn res

timeoutInSeconds seconds =
  timeout (seconds * 1000000)

