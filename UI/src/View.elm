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
import Updates as U
import Url


viewPage : Model -> Html Msg
viewPage model =
    main_ []
        [ h1 [class "text-2xl font-bold text-indigo-900"] [text "Testing Tailiwnd with docker 2xl"]
        , case model.route of
            Just route ->
                div []
                    [ navbar_component route
                    , case route of
                        HomeR ->
                            div
                                []
                                [ text "Home"
                                ]

                        TodoR todo_id ->
                            div [] [ text <| "todo: " ++ String.fromInt todo_id ]

                        UserR user_name ->
                            div [] [ text <| "todo: " ++ user_name ]

                        LoginR ->
                            div []
                                [ case model.login_form of
                                    Just lf ->
                                        login_page lf

                                    Nothing ->
                                        login_page <| LoginForm "" ""
                                ]

                        RegisterR ->
                            div [] [ text <| "register" ]

                        ErrorR ->
                            div [] [ text <| "error occured trying to get to route: " ++ Url.toString model.url ]
                    ]

            Nothing ->
                div [] [ text <| "could not parse url: " ++ Url.toString model.url ]
        ]



-- [ b [ class "text-bold" ] [ text (Url.toString model.url) ]
-- , ul []
--     [ viewLink "/home"
--     , viewLink "/profile"
--     , viewLink "/reviews/the-century-of-the-self"
--     , viewLink "/reviews/public-opinion"
--     , viewLink "/reviews/shah-of-shahs"
--     ]
-- , case model.login_form of
--     Just login_form ->
--         login_page login_form
--     Nothing ->
--         text ""
-- ]


viewLink : String -> Html msg
viewLink path =
    li [] [ a [ href path ] [ text path ] ]
