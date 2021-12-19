module Actions exposing (..)

-- standard imports
import Http 

-- vendor imports 
import RemoteData exposing (..)
import Http.Detailed

-- custom imports 
import Types exposing (..)


-- MSG 
type Msg 
    = GetWebDataExample (WebData (List Todo))
    | NoOp
    | GetDetailedErrorActionExample (RemoteData (Http.Detailed.Error String) (Http.Metadata, Bool))
