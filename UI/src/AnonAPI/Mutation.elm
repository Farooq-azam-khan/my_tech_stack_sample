-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module AnonAPI.Mutation exposing (..)

import AnonAPI.InputObject
import AnonAPI.Interface
import AnonAPI.Object
import AnonAPI.Scalar
import AnonAPI.ScalarCodecs
import AnonAPI.Union
import Graphql.Internal.Builder.Argument as Argument exposing (Argument)
import Graphql.Internal.Builder.Object as Object
import Graphql.Internal.Encode as Encode exposing (Value)
import Graphql.Operation exposing (RootMutation, RootQuery, RootSubscription)
import Graphql.OptionalArgument exposing (OptionalArgument(..))
import Graphql.SelectionSet exposing (SelectionSet)
import Json.Decode as Decode exposing (Decoder)


type alias LoginRequiredArguments =
    { password : String
    , username : String
    }


login :
    LoginRequiredArguments
    -> SelectionSet decodesTo AnonAPI.Object.JsonWebToken
    -> SelectionSet (Maybe decodesTo) RootMutation
login requiredArgs____ object____ =
    Object.selectionForCompositeField "Login" [ Argument.required "password" requiredArgs____.password Encode.string, Argument.required "username" requiredArgs____.username Encode.string ] object____ (Basics.identity >> Decode.nullable)


type alias SignupRequiredArguments =
    { password : String
    , username : String
    }


signup :
    SignupRequiredArguments
    -> SelectionSet decodesTo AnonAPI.Object.CreateUserOutput
    -> SelectionSet (Maybe decodesTo) RootMutation
signup requiredArgs____ object____ =
    Object.selectionForCompositeField "Signup" [ Argument.required "password" requiredArgs____.password Encode.string, Argument.required "username" requiredArgs____.username Encode.string ] object____ (Basics.identity >> Decode.nullable)


type alias InsertUserRequiredArguments =
    { objects : List AnonAPI.InputObject.User_insert_input }


{-| insert data into the table: "user"

  - objects - the rows to be inserted

-}
insert_user :
    InsertUserRequiredArguments
    -> SelectionSet decodesTo AnonAPI.Object.User_mutation_response
    -> SelectionSet (Maybe decodesTo) RootMutation
insert_user requiredArgs____ object____ =
    Object.selectionForCompositeField "insert_user" [ Argument.required "objects" requiredArgs____.objects (AnonAPI.InputObject.encodeUser_insert_input |> Encode.list) ] object____ (Basics.identity >> Decode.nullable)