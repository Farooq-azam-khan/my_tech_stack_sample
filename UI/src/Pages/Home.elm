module Pages.Home exposing (..)

import Actions exposing (Msg(..))
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import RemoteData exposing (..)
import Types exposing (..)


home_page : Model -> Html Msg
home_page model =
    div
        [ class "max-w-2xl mx-auto" ]
        [ case model.token of
            Just _ ->
                div
                    []
                    [ div
                        [ class "flex flex-col space-y-5 px-10 md:px-0 md:flex-row md:items-center md:justify-between md:space-x-3 my-10" ]
                        [ h2 [] [ text "Create Todo" ]
                        , input
                            [ class "shadow appearance-none border rounded w-full py-4 px-4 text-grey-darker"
                            , id "todo_name"
                            , placeholder "what would you like todo?"
                            , onInput UpdateTodoCreationName
                            , type_ "text"
                            ]
                            []
                        , button
                            [ class "bg-black text-white px-3 py-2 rounded-md uppercase text-sm shadow-md hover:shadow-xl font-semibold"
                            , type_ "button"
                            , onClick CreateTodoAction
                            ]
                            [ text "Create TODO"
                            ]
                        ]
                    , case model.user_todos of
                        Success todos ->
                            div
                                [ class "bg-gray-100 py-5 px-10 shadow-xl rounded-md" ]
                                [ h1
                                    [ class "text-3xl font-bold" ]
                                    [ text "Here are you TODOS"
                                    ]
                                , ol
                                    [ class "my-10 space-y-10" ]
                                    (List.map todo_component todos)
                                ]

                        _ ->
                            div [] [ p [] [ text "no todos" ] ]
                    ]

            Nothing ->
                not_logged_in_card
        ]


todo_component : TodoData -> Html msg
todo_component todo =
    li
        [ class "bg-white rounded-md p-5" ]
        [ h3
            [ class "text-lg hover:text-indigo-700" ]
            [ a [ class "", "/todo/" ++ String.fromInt todo.id |> href ] [ text todo.name ] ]
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
