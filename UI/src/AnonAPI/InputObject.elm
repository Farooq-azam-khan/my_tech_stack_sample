-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module AnonAPI.InputObject exposing (..)

import AnonAPI.Interface
import AnonAPI.Object
import AnonAPI.Scalar
import AnonAPI.ScalarCodecs
import AnonAPI.Union
import Graphql.Internal.Builder.Argument as Argument exposing (Argument)
import Graphql.Internal.Builder.Object as Object
import Graphql.Internal.Encode as Encode exposing (Value)
import Graphql.OptionalArgument exposing (OptionalArgument(..))
import Graphql.SelectionSet exposing (SelectionSet)
import Json.Decode as Decode


buildUser_insert_input : User_insert_input
buildUser_insert_input =
    {}


{-| Type for the User\_insert\_input input object.
-}
type alias User_insert_input =
    {}


{-| Encode a User\_insert\_input into a value that can be used as an argument.
-}
encodeUser_insert_input : User_insert_input -> Value
encodeUser_insert_input input____ =
    Encode.maybeObject
        []
