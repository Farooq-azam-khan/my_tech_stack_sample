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
import AnonAPI.Mutation exposing (login)



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
                        
                        RegisterR -> 
                            ({new_model | user_auth = SignupUserAuth {username="", password=""}}, Cmd.none)

                        LoginR -> 
                            ({new_model | user_auth = LoginUserAuth {username="", password=""}}, Cmd.none)
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
            case resp of 
                Success _ -> 
                    case model.user_auth of 
                        SignupUserAuth _ -> 
                            ({model | user_auth = SignupUserAuth ({username="", password=""})}, Cmd.none)
                        _ -> (model, Cmd.none)
                _ -> (model, Cmd.none)

        RegisterUserAction username password ->
            ( model
            , makeSignupRequest username password
            )

        UpdateSignupPassword password ->
            case model.user_auth of 
                SignupUserAuth signup_form -> 
                    ({model | user_auth = SignupUserAuth {username=signup_form.username, password=password}}, Cmd.none)
                _ -> (model, Cmd.none)
         

        UpdateSignupUsername username ->
            case model.user_auth of 
                SignupUserAuth signup_form -> 
                    ({model | user_auth = SignupUserAuth {username=username, password=signup_form.password}}, Cmd.none)
                _ -> (model, Cmd.none)

        LoginFormAction ->
            case model.user_auth of 
                LoginUserAuth login_form -> 
                    ( model
                    , makeLoginRequest login_form.username login_form.password
                    )
                _ -> (model, Cmd.none)

        CreateTodoAction ->
            case model.user_auth of 
                LoggedIn token (Just user_data) (Just user_model) -> 
                    if user_model.create_todo.name == "" then
                        ( model, Cmd.none )

                    else
                        ( model
                        , makeTodoRequest user_model.create_todo token user_data
                        )
                _ -> (model, Cmd.none)

        LoginResponseAction resp ->
            case model.user_auth of
                LoginUserAuth _ -> 
                    case resp of 
                        Success maybe_tok -> 
                            let
                                token = (Maybe.withDefault {token=""} maybe_tok)
                            in
                            
                            ({model | user_auth = LoggedIn token Nothing Nothing}
                            , Cmd.batch [get_user_data_request token, Nav.pushUrl model.key "/"]

                            )

                        _ -> (model, Cmd.none)
                _ -> (model, Cmd.none)

            -- case resp of
            --     Success maybe_tok ->
            --         case model.user_auth of 
            --             LoggedIn _ _ _ -> 
            --                 (model, Cmd.none)
            --             _ -> 
            --                 ( { model | user_auth = LoggedIn (Maybe.withDefault {token=""} maybe_tok) Nothing Nothing }
            --                 , Cmd.batch
            --                     [ save_token_to_local_storage maybe_tok
            --                     , Nav.pushUrl model.key "/"
            --                     , case model.user_auth of 
            --                         LoggedIn token Nothing _ -> 
                                        
            --                             get_user_data_request token
            --                         _ -> Cmd.none 
            --                     ]
            --                 )

            --     _ ->
            --         ( model, Cmd.none )

        UpdateLoginUsername username ->
            case model.user_auth of 
                LoginUserAuth login_form -> 
                    ({model | user_auth = LoginUserAuth {username=username, password=login_form.password}}, Cmd.none)
                _ -> (model, Cmd.none)


        UpdateLoginPassword password ->
            case model.user_auth of 
                LoginUserAuth login_form -> 
                    ({model | user_auth = LoginUserAuth {password=password, username=login_form.username}}, Cmd.none)
                _ -> (model, Cmd.none)


        GetUserDataResult resp ->
            case resp of
                Success users ->
                    case model.user_auth of 
                        LoggedIn token _ user_model -> 
                            ({model | user_auth = LoggedIn token (List.head users) user_model}, Cmd.none)
                        _ -> (model, Cmd.none)
                _ -> (model, Cmd.none)

        GetTodoDataResult resp ->
            case model.user_auth of 
                LoggedIn token user_data user_model -> 
                    let
                        just_user_model =
                            Maybe.withDefault { user_todos=resp, create_todo={name=""}} user_model
                        new_user_model = {just_user_model | user_todos = resp, create_todo={name=""} }
                        
                    in
                    ({model | user_auth = LoggedIn token user_data (Just new_user_model) }, Cmd.none)
                _ -> (model, Cmd.none)

        GetTodoDataCreationResult resp ->
            case model.user_auth of 
                LoggedIn token user_data maybe_user_model -> 
                    
                    let
                        clear_create_form =
                            { name = "" }
                        user_model = Maybe.withDefault {user_todos=Loading, create_todo=clear_create_form} maybe_user_model
                        

                        user_todos =
                            RemoteData.toMaybe user_model.user_todos
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


                        new_user_model =
                            { user_model
                                | user_todos = Success new_user_todos
                                , create_todo = clear_create_form
                            }
                    in
                    ( { model | user_auth = LoggedIn token user_data (Just new_user_model) }
                    , Cmd.none
                    )
                
                _ -> (model, Cmd.none)

        UpdateTodoCreationName todo_name ->
            case model.user_auth of 
                LoggedIn token user_data maybe_user_model -> 
                    let
                        user_model = Maybe.withDefault {user_todos=NotAsked, create_todo={name=todo_name}} maybe_user_model

                        new_user_model =
                            { user_model | create_todo = { name = todo_name } }
                    in
                    ( { model | user_auth =  LoggedIn token user_data (Just new_user_model) }
                    , Cmd.none
                    )
                _ -> (model, Cmd.none)

        DeleteTodo todo_id ->
            ( model
            , case model.user_auth of 
                LoggedIn token _ _ -> 
                    
                    delete_user_todo token todo_id
                _ -> Cmd.none 
            )

        TodoDataDeletionResult resp ->
            case model.user_auth of 
                LoggedIn token user_data maybe_user_model -> 
                    let
                        user_model = Maybe.withDefault {user_todos=NotAsked, create_todo={name=""}} maybe_user_model
                        todo_list =
                            RemoteData.toMaybe user_model.user_todos |> Maybe.withDefault []

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

                        

                        new_user_model =
                            { user_model | user_todos = Success new_todo_list }
                    in
                    ( { model | user_auth = LoggedIn token user_data (Just new_user_model) }, Cmd.none )
                _ -> (model, Cmd.none)

        UpdateTodoAction todo_id current_completed_value ->
            ( model
            , case model.user_auth of 
                LoggedIn token _ _ -> 
                    update_todo_completion token todo_id (not current_completed_value)
                _ -> Cmd.none 
            )

        TodoDataUpdateResult resp ->
            case model.user_auth of 
                LoggedIn token user_auth maybe_user_model -> 
                    let
                        user_model = Maybe.withDefault {user_todos=NotAsked, create_todo={name=""}} maybe_user_model
                        updated_todo =
                            case RemoteData.toMaybe resp of
                                Just maybe_todo ->
                                    Maybe.map2
                                        replace_todo_with_updated_value
                                        maybe_todo
                                        (RemoteData.toMaybe user_model.user_todos)
                                        |> Maybe.withDefault []

                                Nothing ->
                                    []


                        new_user_model =
                            { user_model | user_todos = Success updated_todo }
                    in
                    ( { model | user_auth = LoggedIn token user_auth (Just new_user_model)}, Cmd.none )
                _ -> (model, Cmd.none)



-- Route Updates


home_route_change_update : Model -> ( Model, Cmd Msg )
home_route_change_update model =
    case model.user_auth of     
        LoggedIn token user_data maybe_user_model -> 
            let
                user_model =
                    Maybe.withDefault {user_todos=NotAsked, create_todo={name=""}} maybe_user_model

                new_user_model =
                    { user_model | user_todos = Loading }
            in
            ( { model | user_auth = LoggedIn token user_data (Just new_user_model) }
            , get_todo_data_request token
            )
        
        _ -> ( model, Cmd.none )


logout_route_chage_update : Model -> ( Model, Cmd Msg )
logout_route_chage_update model =
    ( { model
        | user_auth = Anonymous 
      }
    , Ports.logoutUser ()
    )
