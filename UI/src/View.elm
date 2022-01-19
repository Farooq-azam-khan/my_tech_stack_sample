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
                div []
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
                            case model.token of
                                Just _ ->
                                    logged_in_card

                                Nothing ->
                                    div [] [ login_compnent <| model.login_user ]

                        RegisterR ->
                            case model.token of
                                Just _ ->
                                    text ""

                                _ ->
                                    div [] [ register_compnent <| model.signup_user ]

                        ErrorR ->
                            div [] [ text <| "error occured trying to get to route: " ++ Url.toString model.url ]

                        _ ->
                            div [] []
                    ]

            Nothing ->
                div [] [ text <| "could not parse url: " ++ Url.toString model.url ]
        ]


viewLink : String -> Html msg
viewLink path =
    li [] [ a [ href path ] [ text path ] ]
