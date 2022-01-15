module Updates exposing (update)

-- import Json.Encode as E

import Actions exposing (..)
import Api exposing (..)
import Browser
import Browser.Navigation as Nav
import Helpers exposing (..)
import Ports
import RemoteData exposing (..)
import Routes exposing (Route(..), routeParser)
import Types exposing (..)
import Url
import Url.Parser



-- UPDATE


save_token_to_local_storage : WebData Token -> Cmd msg
save_token_to_local_storage token =
    case token of
        Success tok ->
            tok
                -- |> E.encode 0
                |> Ports.storeTokenData

        _ ->
            Cmd.none


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
            ( { model
                | url = url
                , route = Url.Parser.parse routeParser url
              }
            , Cmd.none
            )

        NoOp ->
            ( model, Cmd.none )

        GetWebDataExample _ ->
            ( model
            , Cmd.none
            )

        GetDetailedErrorActionExample _ ->
            ( model
            , Cmd.none
            )

        HelloWorld wb ->
            let
                _ =
                    Debug.log "wb" wb
            in
            ( model
            , Cmd.none
            )

        ReadLoginToken login_token ->
            let
                _ =
                    Debug.log "token" login_token
            in
            ( model
            , Cmd.none
            )

        SignupResponseAction resp ->
            let
                _ =
                    Debug.log "signup resp" resp
            in
            case resp of
                Success _ ->
                    ( { model
                        | route = Just HomeR
                        , signup_user =
                            { password = ""
                            , username = ""
                            }
                      }
                    , Cmd.none
                    )

                _ ->
                    ( model, Cmd.none )

        RegisterUserAction username password ->
            ( model
            , makeSignupRequest username password
            )

        UpdateSignupPassword password ->
            ( { model
                | signup_user =
                    { password = password
                    , username = model.signup_user.username
                    }
              }
            , Cmd.none
            )

        UpdateSignupUsername username ->
            ( { model
                | signup_user =
                    { password = model.signup_user.password
                    , username = username
                    }
              }
            , Cmd.none
            )

        LoginFormAction ->
            ( model
            , makeLoginRequest model.login_user.username model.login_user.password
            )

        LoginResponseAction resp ->
            let
                _ =
                    Debug.log "login resp" resp

                login_user =
                    model.login_user

                new_login_user =
                    { login_user
                        | username = ""
                        , password = ""
                    }

                clear_login_model =
                    { model | login_user = new_login_user }
            in
            case resp of
                Success maybe_tok ->
                    ( { clear_login_model | token = maybe_tok }, Nav.pushUrl model.key "/" )

                _ ->
                    ( model, Cmd.none )

        UpdateLoginUsername username ->
            let
                login_user =
                    model.login_user

                update_user =
                    { login_user
                        | username = username
                    }
            in
            ( { model
                | login_user = update_user
              }
            , Cmd.none
            )

        UpdateLoginPassword password ->
            let
                login_user =
                    model.login_user

                update_user =
                    { login_user
                        | password = password
                    }
            in
            ( { model
                | login_user = update_user
              }
            , Cmd.none
            )
