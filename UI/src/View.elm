module View exposing (..)


-- standard imports 
import Html exposing (..)
import Html.Attributes as Attr exposing (..)
import Html.Events exposing (..)
import Browser 

import Http 

import Svg

import Svg.Attributes as SvgAttr

import Json.Decode as D 

import Json.Encode as E

-- vendor imports 
import RemoteData exposing (..)
import Http.Detailed 

-- custom imports
import Components exposing (..)
import Helpers exposing (..)
import Actions exposing (..)
import Types exposing (..)
import Api exposing (..)
import Updates as U

viewPage : Model -> Html Msg 
viewPage model = 
    main_ 
        [class "space-y-10 px-3 m-0 mx-auto "
        ]
        [
        ]
