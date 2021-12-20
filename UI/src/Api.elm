module Api exposing (..)

import Http
-- import Http.Detailed
import Json.Decode as D
import Json.Encode as E

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

login_dummy_data : List (String, String)
login_dummy_data = 
    [ ("grant_type", "")
    , ("username", "farooq")
    , ("password", "secret")
    , ("scope", "")
    , ("client_id", "")
    , ("client_secret", "")
    ]

login_action : Cmd Msg 
login_action = 
    Http.post 
        { url = backend_host ++ "/user/token"
        , body = Http.stringBody  "application/x-www-form-urlencoded" (formUrlencoded login_dummy_data) 
        , expect = Http.expectJson (RemoteData.fromResult >> ReadLoginToken) decode_login_token
        }
-- post_example : SomeDataTypeToSend -> Cmd Msg
-- post_example data =
--     Http.post
--         { url = backend_host ++ "/api/xyz"
--         , body = Http.jsonBody <| encode_data_type data
--         , expect = Http.Detailed.expectJson (RemoteData.fromResult >> ReadPostResultAction) decode_post_result
--         }
-- -- ENCODERS

formUrlencoded : List ( String, String ) -> String
formUrlencoded object =
    object
        |> List.map
            (\( name, value ) ->
                name ++ "=" ++ value
            )
        |> String.join "&"
-- encode_login_data = 
--     let
--         obj = E.object [("username", E.string "farooq")
--              , ("password", E.string "secret" )
--              ]
--         _ = Debug.log "long data" obj 
--     in
--         obj 
    
-- encode_data_type data =
--   E.object  [ ("datafield1", E.string data.x)
--            , ("datafield2", E.string data.y)
--            , ("boolean", E.bool data.b)
--            ]

token_encoder : Token -> E.Value
token_encoder token = 
    E.object [("access_token", E.string token.access_token)
             , ("token_type", E.string token.token_type)
             ]

-- DECODERS
decodeHW : D.Decoder String 
decodeHW = D.string 

decode_login_token : D.Decoder Token 
decode_login_token = D.map2 Token (D.field "access_token" D.string) (D.field "token_type" D.string)
-- decode_post_result : D.Decoder (List Todo)
-- decode_post_result = D.list D.string
