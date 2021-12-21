module Main exposing (main)

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
import Api exposing (..)
import RemoteData exposing (RemoteData(..))
import Json.Decode as D 

type alias Flag = {token: Maybe Token}

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
        _ = Debug.log "flags" flags
        model = { url=url, key=key
                , route = parse routeParser url, token=NotAsked}
        token =  case flags.token of 
            Just tok -> Success tok 
            Nothing -> Loading
        cmd = if token == Loading then login_action else Cmd.none 
    in
        ({model | token = token}, cmd)



--  VIEW


view : Model -> Browser.Document Msg
view model =
    { title = "App"
    , body = [ viewPage model ]
    }
