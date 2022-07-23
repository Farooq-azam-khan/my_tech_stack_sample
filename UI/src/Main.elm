module Main exposing (main)

import Actions exposing (Msg(..), onUrlChange, onUrlRequest)
import Api exposing (..)
import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
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
        route =
            parse routeParser url

        user_auth =
            case Maybe.withDefault ErrorR route of
                RegisterR ->
                    SignupUserAuth { username = "", password = "" }

                LoginR ->
                    LoginUserAuth { username = "", password = "" }

                _ ->
                    Anonymous

        model =
            case InteropPorts.decodeFlags flags of
                Err _ ->
                    { url = url
                    , key = key
                    , route = route
                    , user_auth = user_auth
                    }

                Ok flgs ->
                    { url = url
                    , key = key
                    , route = route
                    , user_auth = LoggedIn (Maybe.withDefault { token = "" } flgs.token) Nothing Nothing
                    }

        cmds =
            Cmd.batch
                [ case model.user_auth of
                    LoggedIn token _ _ ->
                        get_user_data_request token

                    _ ->
                        Cmd.none
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
