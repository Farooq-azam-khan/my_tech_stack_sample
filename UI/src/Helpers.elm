module Helpers exposing (..)

import RemoteData exposing (..)
import Types exposing (..)
import Ports

replace_todo_with_updated_value : TodoData -> List TodoData -> List TodoData
replace_todo_with_updated_value updated_todo todos =   
    List.append (List.filter (\t -> not <| t.id == updated_todo.id) todos) [updated_todo]



save_token_to_local_storage : MaybeToken -> Cmd msg
save_token_to_local_storage maybetoken =
    Maybe.map (\token -> Ports.storeTokenData token) maybetoken
        |> Maybe.withDefault Cmd.none 