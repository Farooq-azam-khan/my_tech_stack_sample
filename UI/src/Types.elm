module Types exposing (..)

import Http 

-- vendor imports 
import RemoteData exposing (..)
import Http.Detailed

type alias Token = String 

type alias Login = 
    { name : String
    , password : String
    }
type alias Register = 
    { name : String
    , password : String
    , email    : String
    }

type alias User = 
    { name : String
    , email : String
    , token: Token 
    }

-- MODEL
type alias Model = 
    {}
