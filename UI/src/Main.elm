module Main exposing (main)

import Actions exposing (Msg(..), onUrlChange, onUrlRequest)
import Api exposing (..)
import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import InteropDefinitions
import InteropPorts
import Json.Decode
import RemoteData exposing (RemoteData(..))
import Routes exposing (Route(..), routeParser)
import Types exposing (..)
import Updates exposing (update)
import Url
import Url.Parser exposing (parse)
import View exposing (viewPage)


main : Program Json.Decode.Value Model Msg
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


init : Json.Decode.Value -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    let
        _ =
            case InteropPorts.decodeFlags flags of
                Err error ->
                    let
                        _ =
                            Debug.log "error parsing flags" error
                    in
                    ""

                Ok flgs ->
                    let
                        _ =
                            Debug.log "flags parsed" flgs
                    in
                    ""

        model =
            { url = url
            , key = key
            , route = parse routeParser url
            , token = Nothing -- flags.token
            , user_model =
                { user_data = Nothing
                , user_todos = NotAsked
                , create_todo = { name = "" }
                }
            , signup_user = SignupUserForm "" ""
            , login_user = LoginFormData "" ""
            }

        cmds =
            Cmd.batch
                [ Maybe.map (\token -> get_user_data_request token) model.token
                    |> Maybe.withDefault Cmd.none
                ]
    in
    ( model
    , cmds
    )



--  VIEW


view : Model -> Browser.Document Msg
view model =
    { title = "App"
    , body = [ viewPage model ]
    }
