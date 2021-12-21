module View exposing (..)

import Actions exposing (..)
import Api exposing (..)
import Components exposing (..)
import Helpers exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import RemoteData exposing (..)
import Routes exposing (Route(..))
import Types exposing (..)
import Url 

import Pages.Home exposing (home_page)

viewPage : Model -> Html Msg
viewPage model =
    main_ []
        [ case model.route of
            Just route ->
                div []
                    [ navbar_component route
                    , case route of
                        HomeR ->
                            div
                                [class "container"] [home_page model]

                        TodoR todo_id ->
                            div [] [ text <| "todo: " ++ String.fromInt todo_id ]

                        UserR user_name ->
                            div [] [ text <| "todo: " ++ user_name ]

                        LoginR ->
                            case model.token of 
                                Success _ -> 
                                    div []  [ text "you are already logged in"]
                                _ -> 
                                    div [] [  login_compnent <|  init_login_form ]

                        RegisterR ->
                            case model.token of 
                                Success _ -> 
                                    div [] [text "you are already logged in"]
                                _ -> 
                                    div [] [ register_compnent <| init_register_form ]

                        ErrorR ->
                            div [] [ text <| "error occured trying to get to route: " ++ Url.toString model.url ]
                    ]

            Nothing ->
                div [] [ text <| "could not parse url: " ++ Url.toString model.url ]
        ]



viewLink : String -> Html msg
viewLink path =
    li [] [ a [ href path ] [ text path ] ]
