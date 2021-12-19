module Main exposing (..) 
import Html exposing (..)
import Browser 
import Http 
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as D 
import Json.Encode as E 

-- MAIN 
main : Program () Model Msg 
main = Browser.document 
    {init = init, view = view, update = update, subscriptions = subs}
subs _ = Sub.none 
-- MODEL
type alias Model = 
    {}

-- MSG 
type Msg 
    = NoOp 


-- INIT
init : () -> (Model, Cmd Msg)
init _ = ({}, getCustomers)

-- UPDATE 
update : Msg -> Model -> (Model, Cmd Msg)
update msg model = 
    case msg of 
        NoOp -> (model, Cmd.none)
        


--  VIEW 
view : Model -> Browser.Document Msg 
view model = {title = "App", body = [div [] []]} 
