module Types exposing (..)

import Browser.Navigation as Nav
import Graphql.Http
import RemoteData exposing (..)
import Routes exposing (Route)
import Url



-- type alias Token =
--     { access_token : String
--     , token_type : String
--     }


type alias Email =
    String



-- type alias LoginForm =
--     { name : String
--     , password : String
--     , email : Email
--     }
-- init_login_form : LoginForm
-- init_login_form =
--     { name = ""
--     , password = ""
--     , email = ""
--     }


type alias Token =
    String


type alias Username =
    String


type alias Password =
    String


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



-- type alias User =
--     { name : String
--     , email : String
--     , token : Token
--     }


type alias Todo =
    { is_complete : Bool, name : String }



-- MODEL


type alias SignupUserForm =
    { username : String, password : String }


type alias SignupResponse =
    { username : String, password : String, id : Int }


type alias MaybeSignupResponse =
    Maybe SignupResponse


type alias LoginResponse =
    { token : Token }


type alias MaybeLoginResponse =
    Maybe LoginResponse


type alias LoginFormData =
    { username : Username
    , password : Password
    }


type alias UserData =
    { id : Int, username : Username }


type alias TodoData =
    { id : Int, name : String }


type alias Flag =
    { token : MaybeLoginResponse }


type alias CreateTodo =
    { name : String }


type alias Model =
    { key : Nav.Key
    , url : Url.Url
    , token : MaybeLoginResponse
    , user : Maybe UserData
    , user_todos : RemoteData (Graphql.Http.Error (List TodoData)) (List TodoData)
    , route : Maybe Route
    , create_todo : CreateTodo
    , signup_user : SignupUserForm
    , login_user : LoginFormData
    }
