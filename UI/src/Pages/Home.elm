module Pages.Home exposing (..)

import Actions exposing (Msg(..))
import Html exposing (..)
import Html.Attributes exposing (..)
import RemoteData exposing (..)
import Types exposing (..)


home_page : Model -> Html Msg
home_page model =
    div
        []
        [ case model.token of
            Just _ ->
                div
                    []
                    [ h1
                        []
                        [ text "Here are you TODOS"
                        ]
                    ]

            Nothing ->
                not_logged_in_card
        ]


not_logged_in_card : Html msg
not_logged_in_card =
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
                    [ href "#"
                    ]
                    [ h5
                        [ class "text-gray-900 font-bold text-2xl tracking-tight mb-2"
                        ]
                        [ text "Welcome" ]
                    ]
                , p
                    [ class "font-normal text-gray-700 mb-3"
                    ]
                    [ text "This is a todo app. Sign up, login, make a todo. Do the todo and mark it done."
                    ]
                ]
            ]
        ]
