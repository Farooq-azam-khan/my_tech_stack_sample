module Api exposing (..)

-- standard imports 
import Http 

import Json.Decode as D 
import Json.Encode as E

-- vendor imports
import RemoteData exposing (..)
import Http.Detailed 

-- custom imports 
import Actions exposing (Msg(..))
import Types exposing (..)

backend_host = "http://localhost:8000"

-- API 
get_example : Cmd Msg 
get_example = 
    Http.get 
        { url = backend_host ++ "/api/xyz"
        , expect = Http.expectJson (RemoteData.fromResult >> MsgAction) decodeAction
        }
        

post_example : SomeDataTypeToSend -> Cmd Msg 
post_example data = 
    Http.post
        { url = backend_host ++ "/api/xyz"
        , body = Http.jsonBody <| encode_data_type data
        , expect = Http.Detailed.expectJson (RemoteData.fromResult >> ReadPostResultAction) decode_post_result
        }
        
-- ENCODERS 
encode_data_type data = 
  E.object  [ ("datafield1", E.string data.x)
           , ("datafield2", E.string data.y)
           , ("boolean", E.bool data.b)
           ]

-- DECODERS
decodePartners : D.Decoder (List String)
decodePartners = D.list D.string

decode_post_result : D.Decoder (List Todo)
decode_post_result = D.list D.string 
