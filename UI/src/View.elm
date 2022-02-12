module View exposing (..)

import Actions exposing (..)
import Api exposing (..)
import Components exposing (..)
import Helpers exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Pages.Home exposing (home_page)
import RemoteData exposing (..)
import Routes exposing (Route(..))
import Types exposing (..)
import Url


viewPage : Model -> Html Msg
viewPage model =
    main_ []
        [ case model.route of
            Just route ->
                div [ class "relative" ]
                    [ navbar_component model route
                    , case route of
                        HomeR ->
                            div
                                [ class "container" ]
                                [ home_page model All ]

                        ActiveR ->
                            div [ class "container" ] [ home_page model Active ]

                        CompletedR ->
                            div [ class "container" ] [ home_page model Completed ]

                        TodoR todo_id ->
                            div [] [ text <| "todo: " ++ String.fromInt todo_id ]

                        UserR user_name ->
                            div [] [ text <| "todo: " ++ user_name ]

                        LoginR ->
                            case model.user_auth of
                                LoggedIn _ _ _ ->
                                    logged_in_card

                                LoginUserAuth login_form ->
                                    div [] [ login_compnent <| login_form ]
                                _ -> text ""

                        LogoutR ->
                            div
                                [ class "aboslute inset-0 flex items-center justify-center" ]
                                [ div [ class "space-y-3" ]
                                    [ p
                                        []
                                        [ text "You have successfully logged out." ]
                                    , a
                                        [ href "/", class "hover:text-indigo-900 text-indigo-600 hover:bg-indigo-200 block font-semibold bg-indigo-100 text-center rounded-md px-2 py-3" ]
                                        [ text "Go home" ]
                                    ]
                                ]

                        RegisterR ->
                            case model.user_auth of
                                LoggedIn _ _
                                 _ ->
                                    text ""

                                SignupUserAuth signup_from ->
                                    div [] [ register_compnent  signup_from ]

                                _ -> text ""

                        ErrorR ->
                            div [] [ text <| "error occured trying to get to route: " ++ Url.toString model.url ]
                    ]

            Nothing ->
                div [] [ text <| "could not parse url: " ++ Url.toString model.url ]
        ]


viewLink : String -> Html msg
viewLink path =
    li [] [ a [ href path ] [ text path ] ]
