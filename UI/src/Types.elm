module Types exposing (..)

import Browser.Navigation as Nav
import RemoteData exposing (..)
import Routes exposing (Route)
import Url


type alias Token =
    { access_token: String
    , token_type: String
    }


type alias LoginForm =
    { name : String
    , password : String
    }


type alias Register =
    { name : String
    , password : String
    , email : String
    }


type alias User =
    { name : String
    , email : String
    , token : Token
    }


type alias Todo =
    { is_complete : Bool, name : String }



-- MODEL


type alias Model =
    { login_form : Maybe LoginForm
    , key : Nav.Key
    , url : Url.Url
    , token : WebData Token
    , route : Maybe Route
    }
