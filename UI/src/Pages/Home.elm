module Pages.Home exposing (..)

import Actions exposing (Msg(..))
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import RemoteData exposing (..)
import Types exposing (..)


home_page : Model -> FilterTodoType -> Html Msg
home_page model filter_todo =
    div
        [ class "max-w-2xl mx-auto" ]
        [ case model.user_auth of -- case model.token of
            LoggedIn _ _ _ -> 
            -- Just _ ->
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
                            , value model.user_model.create_todo.name
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
                    , case model.user_model.user_todos of
                        Success todos ->
                            if List.length todos == 0 then
                                no_todos_component

                            else
                                todo_list_component todos filter_todo

                        _ ->
                            div [] [ p [] [ text "no todos" ] ]
                    ]

            _ -> 
            -- Nothing ->
                div
                    [ class "mt-60 flex items-center justify-between"
                    ]
                    [ not_logged_in_card
                    ]
        ]


todo_list_component : List TodoData -> FilterTodoType -> Html Msg
todo_list_component todos filter_todo =
    div
        [ class "bg-gray-100 py-5 px-10 shadow-xl rounded-md w-full h-full" ]
        [ h1
            [ class "text-3xl font-bold" ]
            [ text "Here are you TODOS"
            ]
        , ol
            [ class "my-10 space-y-10" ]
            (case filter_todo of
                All ->
                    List.map todo_component todos

                Active ->
                    List.filter (\todo -> not todo.completed) todos |> List.map todo_component

                Completed ->
                    List.filter (\todo -> todo.completed) todos |> List.map todo_component
            )
        , todo_stas_componet todos filter_todo
        ]


get_not_completed_todos : List TodoData -> Int
get_not_completed_todos todos =
    List.filter (\todo -> not todo.completed) todos |> List.length


get_completed_todos : List TodoData -> Int
get_completed_todos todos =
    List.filter (\todo -> todo.completed) todos |> List.length


todo_stas_componet : List TodoData -> FilterTodoType -> Html Msg
todo_stas_componet todos filter_todo =
    let
        active_styles =
            "px-2 py-1 rounded-sm bg-white"

        inactive_styles =
            "px-2 py-1"
    in
    div
        [ class "flex items-center justify-between"
        ]
        [ div
            [ class "text-gray-600" ]
            [ text <| (get_not_completed_todos todos |> String.fromInt) ++ " items left" ]
        , div
            [ class "flex items-center justify-between space-x-5 text-gray-600" ]
            (case filter_todo of
                All ->
                    [ a
                        [ class active_styles, href "/all" ]
                        [ text "All" ]
                    , a [ class inactive_styles, href "/active" ] [ text "Active" ]
                    , a [ class inactive_styles, href "/completed" ] [ text "Completed" ]
                    ]

                Active ->
                    [ a
                        [ class inactive_styles, href "/all" ]
                        [ text "All" ]
                    , a [ class active_styles, href "/active" ] [ text "Active" ]
                    , a [ class inactive_styles, href "/completed" ] [ text "Completed" ]
                    ]

                Completed ->
                    [ a
                        [ class inactive_styles, href "/all" ]
                        [ text "All" ]
                    , a [ class inactive_styles, href "/active" ] [ text "Active" ]
                    , a [ class active_styles, href "/completed" ] [ text "Completed" ]
                    ]
            )
        , div
            [ class "text-gray-600" ]
            [ text <| "Clear Completed " ++ "(" ++ (get_completed_todos todos |> String.fromInt) ++ ")" ]
        ]


no_todos_component : Html Msg
no_todos_component =
    div
        [ class "flex items-center justify-center bg-gray-100 py-5 px-10 shadow-xl rounded-md w-full h-full"
        ]
        [ h2
            [ class "text-center font-semibold text-gray-700 text-xl" ]
            [ text "You do not have any todos. Make some." ]
        ]


todo_component : TodoData -> Html Msg
todo_component todo =
    li
        [ class "flex items-center justify-between bg-white rounded-md p-5" ]
        [ button
            [ class "px-3 py-2 rounded-md bg-indigo-500 text-white hover:text-indigo-900 hover:bg-indigo-100"
            , onClick <| UpdateTodoAction todo.id todo.completed
            ]
            [ text "Toggle TODO Completion" ]
        , h3
            [ class <|
                "text-lg hover:text-indigo-700 "
                    ++ (if todo.completed then
                            "line-through"

                        else
                            ""
                       )
            ]
            [ a [ class "", "/todo/" ++ String.fromInt todo.id |> href ] [ text todo.name ] ]

        -- todo modal (are you sure?)
        , button [ onClick <| DeleteTodo todo.id, class "text-white bg-indigo-700 hover:bg-indigo-900 px-3 py-2 rounded-md shadow-lg hover:shadow-xl" ] [ text "Delete" ]
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
                    [ href "/login"
                    ]
                    [ h5
                        [ class "text-gray-900 font-bold text-2xl tracking-tight mb-2"
                        ]
                        [ text "Welcome" ]
                    ]
                , p
                    [ class "font-normal text-gray-700 mb-3"
                    ]
                    [ text "This is a todo app. "
                    , a [ class "text-indigo-900", href "/signup" ] [ text "Sign up" ]
                    , text " or "
                    , a [ class "text-indigo-900", href "/login" ] [ text "Log In" ]
                    , text " to make a todo. Next, do the todo and mark it done."
                    ]
                ]
            ]
        ]
