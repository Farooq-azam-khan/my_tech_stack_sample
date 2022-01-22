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


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        UrlChanged url ->
            let
                new_model =
                    { model
                        | url = url
                        , route = Url.Parser.parse routeParser url
                    }
            in
            case new_model.route of
                Just route ->
                    case route of
                        LogoutR ->
                            logout_route_chage_update new_model

                        HomeR ->
                            home_route_change_update new_model

                        _ ->
                            ( new_model, Cmd.none )

                _ ->
                    ( new_model, Cmd.none )

        GetWebDataExample _ ->
            ( model
            , Cmd.none
            )

        GetDetailedErrorActionExample _ ->
            -- can debug.log the _
            ( model
            , Cmd.none
            )

        SignupResponseAction resp ->
            Maybe.map
                (\_ ->
                    ( { model
                        | route = Just HomeR
                        , signup_user =
                            { password = ""
                            , username = ""
                            }
                      }
                    , Cmd.none
                    )
                )
                (RemoteData.toMaybe resp)
                |> Maybe.withDefault ( model, Cmd.none )

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
            if model.user_model.create_todo.name == "" then
                ( model, Cmd.none )

            else
                ( model
                , case model.token of
                    Just token ->
                        case model.user_model.user_data of
                            Just user_data ->
                                makeTodoRequest model.user_model.create_todo token user_data

                            Nothing ->
                                get_user_data_request token

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
                        , Maybe.map
                            get_user_data_request
                            model.token
                            |> Maybe.withDefault Cmd.none
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
                                user_model =
                                    model.user_model

                                new_user_model =
                                    { user_model | user_data = Just user }
                            in
                            ( { model | user_model = new_user_model }
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
                user_model =
                    model.user_model

                new_user_model =
                    { user_model | user_todos = resp }
            in
            ( { model | user_model = new_user_model }, Cmd.none )

        GetTodoDataCreationResult resp ->
            let
                clear_create_form =
                    { name = "" }

                user_todos =
                    RemoteData.toMaybe model.user_model.user_todos
                        |> Maybe.map identity
                        |> Maybe.withDefault []

                new_user_todos =
                    case resp of
                        Success added_todos ->
                            Maybe.map
                                (\todo ->
                                    List.append user_todos [ todo ]
                                )
                                added_todos
                                |> Maybe.withDefault user_todos

                        _ ->
                            user_todos

                user_model =
                    model.user_model

                new_user_model =
                    { user_model
                        | user_todos = Success new_user_todos
                        , create_todo = clear_create_form
                    }
            in
            ( { model | user_model = new_user_model }
            , Cmd.none
            )

        UpdateTodoCreationName todo_name ->
            let
                user_model =
                    model.user_model

                new_user_model =
                    { user_model | create_todo = { name = todo_name } }
            in
            ( { model | user_model = new_user_model }
            , Cmd.none
            )

        DeleteTodo todo_id ->
            ( model
            , Maybe.map
                (\token -> delete_user_todo token todo_id)
                model.token
                |> Maybe.withDefault Cmd.none
            )

        TodoDataDeletionResult resp ->
            let
                todo_list =
                    RemoteData.toMaybe model.user_model.user_todos |> Maybe.withDefault []

                new_todo_list =
                    case resp of
                        Success maybe_todos ->
                            Maybe.map
                                (\todo ->
                                    List.filter (\t -> t.id == todo.id |> not) todo_list
                                )
                                maybe_todos
                                |> Maybe.withDefault todo_list

                        _ ->
                            todo_list

                user_model =
                    model.user_model

                new_user_model =
                    { user_model | user_todos = Success new_todo_list }
            in
            ( { model | user_model = new_user_model }, Cmd.none )

        UpdateTodoAction todo_id current_completed_value ->
            ( model
            , Maybe.map
                (\token -> update_todo_completion token todo_id (not current_completed_value))
                model.token
                |> Maybe.withDefault Cmd.none
            )

        TodoDataUpdateResult resp ->
            let
                updated_todo =
                    case RemoteData.toMaybe resp of
                        Just maybe_todo ->
                            Maybe.map2
                                replace_todo_with_updated_value
                                maybe_todo
                                (RemoteData.toMaybe model.user_model.user_todos)
                                |> Maybe.withDefault []

                        Nothing ->
                            []

                user_model =
                    model.user_model

                new_user_model =
                    { user_model | user_todos = Success updated_todo }
            in
            ( { model | user_model = new_user_model }, Cmd.none )



-- Route Updates


home_route_change_update : Model -> ( Model, Cmd Msg )
home_route_change_update model =
    Maybe.map
        (\token ->
            let
                user_model =
                    model.user_model

                new_user_model =
                    { user_model | user_todos = Loading }
            in
            ( { model | user_model = new_user_model }
            , get_todo_data_request token
            )
        )
        model.token
        |> Maybe.withDefault ( model, Cmd.none )


logout_route_chage_update : Model -> ( Model, Cmd Msg )
logout_route_chage_update model =
    ( { model
        | token = Nothing
        , user_model = { user_data = Nothing, user_todos = NotAsked, create_todo = { name = "" } }
      }
    , Ports.logoutUser ()
    )
