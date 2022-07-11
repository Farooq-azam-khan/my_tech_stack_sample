module AdminMain exposing (..)
import Html exposing (..)
import Browser

type alias AdminModel = {a_state : Int} 
type AdminMsg = NoOp 
main : Program () AdminModel AdminMsg
main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }

init : AdminModel 
init = {a_state=1}

update : AdminMsg -> AdminModel -> AdminModel 
update _ model = model 

view : AdminModel -> Html AdminMsg 
view _ = div [] [text "Admin Page"]