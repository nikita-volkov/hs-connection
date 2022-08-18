module Main where

import Debug.Trace
import Data.Default
import Prelude
import qualified Data.ByteString.Char8 as ByteString
import Network.Connection

main = do
  ctx <- initConnectionContext
  con <-
    connectTo ctx $
      ConnectionParams
        { connectionHostname = "d5dse1mp8tvk14hqu5cl.apigw.yandexcloud.net",
          connectionPort = 443,
          connectionUseSecure = Just $ def,
          connectionUseSocks = Nothing
        }
  traceM "+ send"
  connectionPut con $ ByteString.replicate 30000 'z'
  traceM "- send"
  traceM "+ recv"
  r <- connectionGetChunk con
  traceM "- recv"
  ByteString.putStrLn r
  connectionClose con
