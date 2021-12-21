module Components exposing (..)

-- standard imports
-- vendor imports
-- custom imports

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


navbar_component : Route -> Html Msg
navbar_component route =
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
                    [ href "#"
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
                [ class "flex-col flex-grow pb-4 md:pb-0 hidden md:flex md:justify-end md:flex-row"
                ]
                (case route of
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


login_compnent : Types.LoginForm -> Html Msg
login_compnent login_form =
    Html.form [ class "max-w-xl mx-auto bg-white shadow-md rounded px-8 pt-6 pb-8 mb-4 flex flex-col" ]
        [ div [ class "mb-4" ]
            [ label [ class "block text-grey-darker text-sm font-bold mb-2", for "name" ]
                [ text "Name" ]
            , input [ class "shadow appearance-none border rounded w-full py-2 px-3 text-grey-darker", id "username", placeholder "What should I call You?", type_ "text", value login_form.name ]
                []
            ]
        , div [ class "mb-6" ]
            [ label [ class "block text-grey-darker text-sm font-bold mb-2", for "password" ]
                [ text "Password" ]
            , input [ class "shadow appearance-none border border-red rounded w-full py-2 px-3 text-grey-darker mb-3", id "password", placeholder "******************", type_ "password", value login_form.password ]
                []
            , p [ class "text-red text-xs italic" ]
                [ text "Please choose a password." ]
            ]
        , div [ class "flex items-center justify-between" ]
            [ button [ class "bg-black text-white px-3 py-2 rounded-md", type_ "submit" ]
                [ text "Sign In" ]
            , a [ class "inline-block align-baseline font-bold text-sm text-blue hover:text-blue-darker", href "#" ]
                [ text "Forgot Password?" ]
            ]
        ]


register_compnent : Types.RegisterForm -> Html Msg
register_compnent register_form =
    Html.form [ class "max-w-xl mx-auto bg-white shadow-md rounded px-8 pt-6 pb-8 mb-4 flex flex-col" ]
        [ div [ class "mb-4" ]
            [ label [ class "block text-grey-darker text-sm font-bold mb-2", for "name" ]
                [ text "Name" ]
            , input [ class "shadow appearance-none border rounded w-full py-2 px-3 text-grey-darker", id "username", placeholder "What should I call You?", type_ "text", value register_form.name ]
                []
            ]
        , div [ class "mb-6" ]
            [ label [ class "block text-grey-darker text-sm font-bold mb-2", for "password" ]
                [ text "Password" ]
            , input [ class "shadow appearance-none border border-red rounded w-full py-2 px-3 text-grey-darker mb-3", id "password", placeholder "******************", type_ "password", value register_form.password ]
                []
            , p [ class "text-red text-xs italic" ]
                [ text "Please choose a password." ]
            ]
        , div [ class "mb-6" ]
            [ label [ class "block text-grey-darker text-sm font-bold mb-2", for "c-password" ]
                [ text "Confirm Password" ]
            , input [ class "shadow appearance-none border border-red rounded w-full py-2 px-3 text-grey-darker mb-3", id "pc-assword", placeholder "******************", type_ "password", value register_form.confirm_password ]
                []
            , p [ class "text-red text-xs italic" ]
                [ text "Please confirm your password." ]
            ]
        , div [ class "flex items-center justify-between" ]
            [ button [ class "bg-black text-white px-3 py-2 rounded-md", type_ "submit" ]
                [ text "Sign Up" ]
            , a [ class "inline-block align-baseline font-bold text-sm text-blue hover:text-blue-darker", href "#" ]
                [ text "Forgot Password?" ]
            ]
        ]
