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


save_token_to_local_storage : MaybeLoginResponse -> Cmd msg
save_token_to_local_storage token =
    case token of
        Just tok ->
            Ports.storeTokenData tok

        Nothing ->
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
            let
                new_model =
                    { model | url = url, route = Url.Parser.parse routeParser url }
            in
            case new_model.route of
                Just route ->
                    case route of
                        LogoutR ->
                            ( { new_model | token = Nothing }, Ports.logoutUser () )

                        _ ->
                            ( new_model, Cmd.none )

                _ ->
                    ( new_model, Cmd.none )

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

        -- ReadLoginToken _ ->
        --     ( model
        --     , Cmd.none
        --     )
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
            case resp of
                Success maybe_tok ->
                    ( { model | token = maybe_tok }
                    , Cmd.batch
                        [ save_token_to_local_storage maybe_tok
                        , Nav.pushUrl model.key "/"
                        , case model.token of
                            Just token ->
                                get_user_data_request token

                            -- get user data
                            Nothing ->
                                Cmd.none
                        ]
                    )

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

        GetUserDataResult resp ->
            case resp of
                Success users ->
                    case List.head users of
                        Just user ->
                            let
                                _ =
                                    Debug.log "user" user
                            in
                            ( { model | user = Just user }
                            , case model.token of
                                Just token ->
                                    get_todo_data_request token

                                Nothing ->
                                    Cmd.none
                            )

                        Nothing ->
                            ( { model | token = Nothing }, Cmd.none )

                _ ->
                    ( { model | token = Nothing }, Cmd.none )

        GetTodoDataResult resp ->
            let
                _ =
                    Debug.log "todo resp" resp
            in
            ( { model | user_todos = resp }, Cmd.none )
