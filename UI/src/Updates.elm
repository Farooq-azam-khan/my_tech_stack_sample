module Updates exposing (update)

-- vendor imports
-- custom imports

import Actions exposing (..)
import Api exposing (..)
import Browser
import Browser.Navigation as Nav
import Helpers exposing (..)
import RemoteData exposing (..)
import Routes exposing (routeParser)
import Types exposing (..)
import Url
import Url.Parser



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        UrlChanged url ->
            ( { model | url = url, route = Url.Parser.parse routeParser url }, Cmd.none )

        NoOp ->
            ( model, Cmd.none )

        GetWebDataExample _ ->
            Debug.todo "branch 'GetWebDataExample _' not implemented"

        GetDetailedErrorActionExample _ ->
            Debug.todo "branch 'GetDetailedErrorActionExample _' not implemented"
