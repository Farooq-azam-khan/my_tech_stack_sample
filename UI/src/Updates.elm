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
                            ( { new_model | token = Nothing, user_todos = NotAsked, user = Nothing }, Ports.logoutUser () )

                        HomeR ->
                            case model.token of
                                Just token ->
                                    ( { new_model | user_todos = Loading }, get_todo_data_request token )

                                -- get user data
                                Nothing ->
                                    ( new_model, Cmd.none )

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

        CreateTodoAction ->
            -- if String.length model.create_todo.name <= 2 then
            --     ( model, Cmd.none )
            -- else
            ( model
            , case model.token of
                Just token ->
                    case model.user of
                        Just user ->
                            if model.create_todo.name == "" then
                                Cmd.none

                            else
                                makeTodoRequest token model.create_todo user

                        Nothing ->
                            Cmd.none

                Nothing ->
                    Cmd.none
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

        GetTodoDataCreationResult resp ->
            let
                clear_create_form =
                    { name = "" }

                user_todos =
                    case model.user_todos of
                        Success todos ->
                            todos

                        _ ->
                            []

                new_user_todos =
                    case resp of
                        Success added_todos ->
                            case added_todos of
                                Just todo ->
                                    List.append user_todos [ todo ]

                                Nothing ->
                                    user_todos

                        _ ->
                            user_todos

                _ =
                    Debug.log "todo creation" resp
            in
            ( { model | user_todos = Success new_user_todos, create_todo = clear_create_form }, Cmd.none )

        UpdateTodoCreationName todo_name ->
            let
                ct =
                    model.create_todo

                new_ct =
                    { ct | name = todo_name }
            in
            ( { model | create_todo = new_ct }, Cmd.none )

        DeleteTodo todo_id ->
            let
                _ =
                    Debug.log "deleting" todo_id
            in
            ( model
            , case model.token of
                Just token ->
                    delete_user_todo token todo_id

                Nothing ->
                    Cmd.none
            )

        TodoDataDeletionResult resp ->
            let
                _ =
                    Debug.log "result" resp

                todo_list =
                    case model.user_todos of
                        Success todos ->
                            todos

                        _ ->
                            []

                new_todo_list =
                    case resp of
                        Success maybe_todos ->
                            case maybe_todos of
                                Just todo ->
                                    List.filter (\t -> not <| t.id == todo.id) todo_list

                                Nothing ->
                                    todo_list

                        _ ->
                            todo_list
            in
            ( { model | user_todos = Success new_todo_list }, Cmd.none )
