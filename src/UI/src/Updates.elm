module Updates exposing (update)

-- vendor imports 
import RemoteData exposing (..)

-- custom imports 
import Types exposing (..)
import Actions exposing (..)
import Api exposing (..)
import Helpers exposing (..)

-- UPDATE 
update : Msg -> Model -> (Model, Cmd Msg)
update msg model = 
    case msg of 
      NoOp -> (model, Cmd.none)
