module Pages.Home exposing (..)

import Html exposing (..)
import Types exposing (..)
import Actions exposing (Msg(..))
import RemoteData exposing (..)

home_page : Model -> Html Msg 
home_page model = 
  div 
    [] 
    [ case model.token of 
        Success _ -> div [] [h1 [] [text "welcome "]]
        _ -> div [] [h1 [] [text "hello there"]]
    ]