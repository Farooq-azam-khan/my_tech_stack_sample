module Components exposing (..)

import Actions exposing (..)
import Helpers exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import RemoteData exposing (..)
import Routes exposing (Route(..))
import Types exposing (..)


active_route : String -> String -> Html Msg
active_route route_name path =
    a
        [ class "px-4 py-2 mt-2 text-sm font-semibold bg-indigo-900 text-white rounded-lg md:mt-0 hover:text-indigo-900 hover:bg-indigo-200"
        , href path
        ]
        [ text route_name ]


inactive_route : String -> String -> Html Msg
inactive_route route_name path =
    a
        [ class "px-4 py-2 mt-2 text-sm font-semibold rounded-lg dark-mode:bg-transparent dark-mode:hover:bg-gray-600 dark-mode:focus:bg-gray-600 dark-mode:focus:text-white dark-mode:hover:text-white dark-mode:text-gray-200 md:mt-0 md:ml-4 hover:text-gray-900 focus:text-gray-900 hover:bg-gray-200 focus:bg-gray-200 focus:outline-none focus:shadow-outline"
        , href path
        ]
        [ text route_name ]


navbar_component : Model -> Route -> Html Msg
navbar_component model route =
    div
        [ class "w-full text-gray-700 bg-white dark-mode:text-gray-200 dark-mode:bg-gray-800"
        ]
        [ div
            [ class "flex flex-col max-w-screen-xl px-4 mx-auto md:items-center md:justify-between md:flex-row md:px-6 lg:px-8"
            ]
            [ div
                [ class "p-4 flex flex-row items-center justify-between"
                ]
                [ a
                    [ href "/"
                    , class "text-lg font-semibold tracking-widest text-gray-900 uppercase rounded-lg dark-mode:text-white focus:outline-none focus:shadow-outline"
                    ]
                    [ text "TECH UI" ]
                , button
                    [ class "md:hidden rounded-lg focus:outline-none focus:shadow-outline"
                    ]
                    [ text "icon"
                    ]
                ]
            , nav
                [ class "flex-col space-x-3 flex-grow pb-4 md:pb-0 hidden md:flex md:justify-end md:flex-row"
                ]
                (case model.user_auth of
                    LoggedIn token _ _ -> 
                    -- Just _ ->
                        [ active_route "Home" "home"
                        , inactive_route "Logout" "logout"
                        ]

                    -- Nothing ->
                    _ -> 
                        case route of
                            HomeR ->
                                [ active_route "Home" "home"
                                , inactive_route "Login" "login"
                                , inactive_route "Register" "register"
                                ]

                            LoginR ->
                                [ inactive_route "Home" "home"
                                , active_route "Login" "login"
                                , inactive_route "Register" "register"
                                ]

                            RegisterR ->
                                [ inactive_route "Home" "home"
                                , inactive_route "Login" "login"
                                , active_route "Register" "register"
                                ]

                            _ ->
                                [ active_route "Home" "home"
                                , inactive_route "Login" "login"
                                , inactive_route "Register" "register"
                                ]
                )
            ]
        ]


login_compnent : Types.LoginFormData -> Html Msg
login_compnent login_form =
    Html.div
        -- todo: form later
        [ class "max-w-xl mx-auto bg-white shadow-md rounded px-8 pt-6 pb-8 mb-4 flex flex-col"
        ]
        [ div
            [ class "mb-4" ]
            [ label
                [ class "block text-grey-darker text-sm font-bold mb-2"
                , for "name"
                ]
                [ text "Name" ]
            , input
                [ class "shadow appearance-none border rounded w-full py-2 px-3 text-grey-darker"
                , id "username"
                , placeholder "what is your username?"
                , type_ "text"
                , value login_form.username
                , onInput UpdateLoginUsername
                ]
                []
            ]
        , div [ class "mb-6" ]
            [ label
                [ class "block text-grey-darker text-sm font-bold mb-2", for "password" ]
                [ text "Password" ]
            , input
                [ class "shadow appearance-none border border-red rounded w-full py-2 px-3 text-grey-darker mb-3"
                , id "password"
                , placeholder "******************"
                , type_ "password"
                , value login_form.password
                , onInput UpdateLoginPassword
                ]
                []
            , p [ class "text-red text-xs italic" ]
                [ text "Please choose a password." ]
            ]
        , div [ class "flex flex-col md:block space-y-2" ]
            [ button
                [ class "bg-indigo-600 hover:bg-indigo-800 text-white px-3 py-2 rounded-md"
                , type_ "button"
                , onClick LoginFormAction
                ]
                [ text "Sign In"
                ]
            , div [] [ a [ href "/signup", class "text-indigo-600 hover:text-indigo-800" ] [ text "Not logged in, Sign Up" ] ]

            -- , a [ class "inline-block align-baseline font-bold text-sm text-blue hover:text-blue-darker", href "#" ]
            --     [ text "Forgot Password?" ]
            ]
        ]


register_compnent : Types.SignupUserForm -> Html Msg
register_compnent register_form =
    Html.div
        [ class "max-w-xl mx-auto bg-white shadow-md rounded px-8 pt-6 pb-8 mb-4 flex flex-col"

        -- , onSubmit (RegisterUserAction register_form.username register_form.password)
        ]
        [ div
            [ class "mb-4" ]
            [ label
                [ class "block text-grey-darker text-sm font-bold mb-2"
                , for "name"
                ]
                [ text "Name" ]
            , input
                [ class "shadow appearance-none border rounded w-full py-2 px-3 text-grey-darker"
                , id "username"
                , placeholder "What should I call You?"
                , type_ "text"
                , value register_form.username
                , onInput UpdateSignupUsername
                ]
                []
            ]
        , div [ class "mb-6" ]
            [ label [ class "block text-grey-darker text-sm font-bold mb-2", for "password" ]
                [ text "Password" ]
            , input
                [ class "shadow appearance-none border border-red rounded w-full py-2 px-3 text-grey-darker mb-3"
                , id "password"
                , placeholder "******************"
                , type_ "password"
                , value register_form.password
                , onInput UpdateSignupPassword
                ]
                []
            , p [ class "text-red text-xs italic" ]
                [ text "Please choose a password." ]
            ]

        -- , div [ class "mb-6" ]
        --     [ label [ class "block text-grey-darker text-sm font-bold mb-2", for "c-password" ]
        --         [ text "Confirm Password" ]
        --     , input [ class "shadow appearance-none border border-red rounded w-full py-2 px-3 text-grey-darker mb-3", id "pc-assword", placeholder "******************", type_ "password", value register_form.confirm_password ]
        --         []
        --     , p [ class "text-red text-xs italic" ]
        --         [ text "Please confirm your password." ]
        --     ]
        , div [ class "flex items-center justify-between" ]
            [ button
                [ class "bg-indigo-600 hover:bg-indigo-800 text-white px-3 py-2 rounded-md"
                , type_ "button"
                , onClick <| RegisterUserAction register_form.username register_form.password
                ]
                [ text "Sign Up" ]

            -- , a [ class "inline-block align-baseline font-bold text-sm text-blue hover:text-blue-darker", href "#" ]
            --     [ text "Forgot Password?" ]
            ]
        ]


logged_in_card : Html msg
logged_in_card =
    div
        [ class "max-w-lg mx-auto"
        ]
        [ div
            [ class "bg-white shadow-md border border-gray-200 rounded-lg max-w-sm mb-5"
            ]
            [ a
                [ href "#"
                ]
                [ img
                    [ class "rounded-t-lg"
                    , src "https://flowbite.com/docs/images/blog/image-1.jpg"
                    , alt ""
                    ]
                    []
                ]
            , div
                [ class "p-5"
                ]
                [ a
                    [ href "/login"
                    ]
                    [ h5
                        [ class "text-gray-900 font-bold text-2xl tracking-tight mb-2"
                        ]
                        [ text "Login Page" ]
                    ]
                , p
                    [ class "font-normal text-gray-700 mb-3"
                    ]
                    [ text "You are already logged in"
                    ]
                ]
            ]
        ]
