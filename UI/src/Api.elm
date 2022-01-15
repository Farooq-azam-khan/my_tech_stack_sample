module Api exposing (..)

-- import Http.Detailed

import Actions exposing (Msg(..))
import AnonAPI.Mutation exposing (LoginRequiredArguments, SignupRequiredArguments, login, signup)
import AnonAPI.Object exposing (CreateUserOutput, JsonWebToken)
import AnonAPI.Object.CreateUserOutput as CreateUserOutputObj
import AnonAPI.Object.JsonWebToken as JsonWebTokenObj
import Graphql.Http
import Graphql.Operation exposing (RootMutation)
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet)
import Http
import Json.Decode as D
import Json.Encode as E
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


login_dummy_data : List ( String, String )
login_dummy_data =
    [ ( "grant_type", "" )
    , ( "username", "farooq" )
    , ( "password", "secret" )
    , ( "scope", "" )
    , ( "client_id", "" )
    , ( "client_secret", "" )
    ]


login_action : Cmd Msg
login_action =
    Http.post
        { url = backend_host ++ "/user/token"
        , body = Http.stringBody "application/x-www-form-urlencoded" (formUrlencoded login_dummy_data)
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
    E.object
        [ ( "access_token", E.string token.access_token )
        , ( "token_type", E.string token.token_type )
        ]



-- DECODERS


decodeHW : D.Decoder String
decodeHW =
    D.string


decode_login_token : D.Decoder Token
decode_login_token =
    D.map2 Token (D.field "access_token" D.string) (D.field "token_type" D.string)



-- Graphql


graphql_url : String
graphql_url =
    "http://localhost:8080/v1/graphql"


signupArgs : String -> String -> SignupRequiredArguments
signupArgs un pswd =
    { password = pswd
    , username = un
    }


loginArgs : String -> String -> LoginRequiredArguments
loginArgs un pswd =
    { password = pswd
    , username = un
    }


type alias Flag =
    { token : MaybeLoginResponse }


signup_decoder : SelectionSet SignupResponse CreateUserOutput
signup_decoder =
    SelectionSet.map3
        Types.SignupResponse
        CreateUserOutputObj.username
        CreateUserOutputObj.password
        CreateUserOutputObj.id


login_decoder : SelectionSet LoginResponse JsonWebToken
login_decoder =
    SelectionSet.map
        Types.LoginResponse
        JsonWebTokenObj.token


signupMutation : String -> String -> SelectionSet MaybeSignupResponse RootMutation
signupMutation username password =
    signup
        (signupArgs username password)
        signup_decoder


makeSignupRequest : String -> String -> Cmd Msg
makeSignupRequest username password =
    signupMutation username password
        |> Graphql.Http.mutationRequest graphql_url
        |> Graphql.Http.send (RemoteData.fromResult >> SignupResponseAction)



-- login


loginMutation : String -> String -> SelectionSet MaybeLoginResponse RootMutation
loginMutation username password =
    login
        (loginArgs username password)
        login_decoder


makeLoginRequest : String -> String -> Cmd Msg
makeLoginRequest username password =
    loginMutation username password
        |> Graphql.Http.mutationRequest graphql_url
        |> Graphql.Http.send (RemoteData.fromResult >> LoginResponseAction)



-- get logged in user todos
