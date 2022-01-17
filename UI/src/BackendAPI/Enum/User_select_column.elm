-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module BackendAPI.Enum.User_select_column exposing (..)

import Json.Decode as Decode exposing (Decoder)


{-| select columns of table "user"

  - Id - column name
  - Username - column name

-}
type User_select_column
    = Id
    | Username


list : List User_select_column
list =
    [ Id, Username ]


decoder : Decoder User_select_column
decoder =
    Decode.string
        |> Decode.andThen
            (\string ->
                case string of
                    "id" ->
                        Decode.succeed Id

                    "username" ->
                        Decode.succeed Username

                    _ ->
                        Decode.fail ("Invalid User_select_column type, " ++ string ++ " try re-running the @dillonkearns/elm-graphql CLI ")
            )


{-| Convert from the union type representing the Enum to a string that the GraphQL server will recognize.
-}
toString : User_select_column -> String
toString enum____ =
    case enum____ of
        Id ->
            "id"

        Username ->
            "username"


{-| Convert from a String representation to an elm representation enum.
This is the inverse of the Enum `toString` function. So you can call `toString` and then convert back `fromString` safely.

    Swapi.Enum.Episode.NewHope
        |> Swapi.Enum.Episode.toString
        |> Swapi.Enum.Episode.fromString
        == Just NewHope

This can be useful for generating Strings to use for <select> menus to check which item was selected.

-}
fromString : String -> Maybe User_select_column
fromString enumString____ =
    case enumString____ of
        "id" ->
            Just Id

        "username" ->
            Just Username

        _ ->
            Nothing