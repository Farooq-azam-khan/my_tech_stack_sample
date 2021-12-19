module Main exposing (..)

import Actions exposing (Msg(..), onUrlChange, onUrlRequest)
import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Routes exposing (Route(..), routeParser)
import Types exposing (..)
import Updates exposing (update)
import Url
import Url.Parser exposing (parse)
import View exposing (viewPage)


main : Program () Model Msg
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


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init _ url key =
    ( { login_form = Just (LoginForm "asd" "asdf")
      , url = url
      , key = key
      , route = parse routeParser url
      }
    , Cmd.none
    )



--  VIEW


view : Model -> Browser.Document Msg
view model =
    { title = "App"
    , body = [ viewPage model ]
    }
