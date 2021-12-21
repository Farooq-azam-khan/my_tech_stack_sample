module Types exposing (..)

import Browser.Navigation as Nav
import RemoteData exposing (..)
import Routes exposing (Route)
import Url


type alias Token =
    { access_token: String
    , token_type: String
    }

type alias Email = String 

type alias LoginForm =
    { name : String
    , password : String
    , email : Email 
    }

init_login_form : LoginForm 
init_login_form = 
    { name = ""
    , password = ""
    , email = ""
    }

type alias RegisterForm =
    { name : String
    , password : String
    , confirm_password : String 
    , email : Email
    }
    
init_register_form : RegisterForm
init_register_form = 
    { name = ""
    , password = ""
    , confirm_password = ""
    , email = ""
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
    { key : Nav.Key
    , url : Url.Url
    , token : WebData Token
    , route : Maybe Route
    }
