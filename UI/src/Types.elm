module Types exposing (..)

import Browser.Navigation as Nav
import Graphql.Http
import RemoteData exposing (..)
import Routes exposing (Route)
import Url


type alias Email =
    String


type alias Username =
    String


type alias Password =
    String


type FilterTodoType
    = All
    | Active
    | Completed


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


type alias Todo =
    { is_complete : Bool, name : String }



-- MODEL


type alias SignupUserForm =
    { username : String, password : String }


type alias SignupResponse =
    { username : String, password : String, id : Int }


type alias MaybeSignupResponse =
    Maybe SignupResponse


type alias Token =
    { token : String }


type alias MaybeToken =
    Maybe Token


type alias LoginFormData =
    { username : Username
    , password : Password
    }


type alias UserData =
    { id : Int, username : Username }


type alias TodoId =
    Int


type alias TodoData =
    { id : TodoId
    , name : String
    , completed : Bool
    }


type alias Flag =
    { token : MaybeToken }


type alias CreateTodo =
    { name : String }


type alias UserModel =
    { user_data : Maybe UserData
    , user_todos : RemoteData (Graphql.Http.Error (List TodoData)) (List TodoData)
    , create_todo : CreateTodo
    }


type alias Model =
    { key : Nav.Key
    , url : Url.Url
    , token : MaybeToken
    , user_model : UserModel
    , route : Maybe Route
    , signup_user : SignupUserForm
    , login_user : LoginFormData
    }
