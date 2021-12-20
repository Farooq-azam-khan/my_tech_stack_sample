module Api exposing (..)

import Http
-- import Http.Detailed
import Json.Decode as D
-- import Json.Encode as E

import Actions exposing (Msg(..))
import RemoteData exposing (..)
import Types exposing (..)


backend_host : String
backend_host =
    "http://localhost:8000"



-- -- API
get_hw : Cmd Msg
get_hw =
    Http.get
        { url = backend_host ++ "/hw"
        , expect = Http.expectJson (RemoteData.fromResult >> HelloWorld) decodeHW
        }
-- post_example : SomeDataTypeToSend -> Cmd Msg
-- post_example data =
--     Http.post
--         { url = backend_host ++ "/api/xyz"
--         , body = Http.jsonBody <| encode_data_type data
--         , expect = Http.Detailed.expectJson (RemoteData.fromResult >> ReadPostResultAction) decode_post_result
--         }
-- -- ENCODERS
-- encode_data_type data =
--   E.object  [ ("datafield1", E.string data.x)
--            , ("datafield2", E.string data.y)
--            , ("boolean", E.bool data.b)
--            ]
-- DECODERS
decodeHW : D.Decoder String 
decodeHW = D.string 
-- decode_post_result : D.Decoder (List Todo)
-- decode_post_result = D.list D.string
