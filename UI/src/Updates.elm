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
import Json.Encode as E
import Ports 

-- UPDATE
save_token_to_local_storage : WebData Token -> Cmd msg 
save_token_to_local_storage token = 
    case token of 
        Success tok -> 
            tok 
                -- |> E.encode 0
                |> Ports.storeTokenData
        _ -> Cmd.none 

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
            (model, Cmd.none) -- Debug.todo "branch 'GetWebDataExample _' not implemented"

        GetDetailedErrorActionExample _ ->
            (model, Cmd.none) -- Debug.todo "branch 'GetDetailedErrorActionExample _' not implemented"
        
        HelloWorld wb -> 
            let
                _ = Debug.log "wb" wb
            in
                (model, Cmd.none)
        
        ReadLoginToken login_token -> 
            let
                _ = Debug.log "token" login_token
                
            in
                ({model | token = login_token}, save_token_to_local_storage login_token)
            
            
