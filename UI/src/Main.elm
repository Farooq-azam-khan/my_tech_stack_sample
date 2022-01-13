module Main exposing (main)

-- import AnonAPI.Mutation exposing (SignupRequiredArguments, signup)
-- import AnonAPI.Object exposing (CreateUserOutput)
-- import AnonAPI.Object.CreateUserOutput as CreateUserOutputObj
-- import Graphql.Http
-- import Graphql.Operation exposing (RootMutation)
-- import Graphql.SelectionSet as SelectionSet exposing (SelectionSet)
-- import Json.Decode as D

import Actions exposing (Msg(..), onUrlChange, onUrlRequest)
import Api exposing (..)
import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import RemoteData exposing (RemoteData(..))
import Routes exposing (Route(..), routeParser)
import Types exposing (..)
import Updates exposing (update)
import Url
import Url.Parser exposing (parse)
import View exposing (viewPage)



-- graphql_url : String
-- graphql_url =
--     "http://localhost:8080/v1/graphql"
-- signupArgs : String -> String -> SignupRequiredArguments
-- signupArgs un pswd =
--     { password = pswd
--     , username = un
--     }
-- type alias Flag =
--     { token : Maybe Token }
-- signup_decoder : SelectionSet SignupResponse CreateUserOutput
-- signup_decoder =
--     SelectionSet.map3
--         Types.SignupResponse
--         CreateUserOutputObj.username
--         CreateUserOutputObj.password
--         CreateUserOutputObj.id
-- signupMutation : SelectionSet MaybeSignupResponse RootMutation
-- signupMutation =
--     signup
--         (signupArgs "test_user" "test_user")
--         signup_decoder
-- makeRequest : Cmd Msg
-- makeRequest =
--     signupMutation
--         |> Graphql.Http.mutationRequest graphql_url
--         |> Graphql.Http.send (RemoteData.fromResult >> SignupResponseAction)


main : Program Flag Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subs
        , onUrlChange = onUrlChange
        , onUrlRequest = onUrlRequest
        }


subs : a -> Sub msg
subs _ =
    Sub.none



-- INIT


init : Flag -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    let
        _ =
            Debug.log "flags" flags

        model =
            { url = url
            , key = key
            , route = parse routeParser url
            , token = NotAsked
            , signup_user = SignupUserForm "" ""
            }

        token =
            case flags.token of
                Just tok ->
                    Success tok

                Nothing ->
                    Loading

        -- cmd =
        --     if token == Loading then
        --         login_action
        --     else
        --         Cmd.none
    in
    ( { model | token = token }, Cmd.none )



--  VIEW


view : Model -> Browser.Document Msg
view model =
    { title = "App"
    , body = [ viewPage model ]
    }
