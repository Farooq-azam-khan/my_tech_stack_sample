module Main exposing (main)

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
        model =
            { url = url
            , key = key
            , route = parse routeParser url
            , token = flags.token
            , user = Nothing
            , user_todos = Loading
            , create_todo = { name = "" }
            , signup_user = SignupUserForm "" ""
            , login_user = LoginFormData "" ""
            }

        cmds =
            Cmd.batch
                [ case model.token of
                    Just token ->
                        get_user_data_request token

                    -- get user data
                    Nothing ->
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
