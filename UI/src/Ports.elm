port module Ports exposing (..)

import Types exposing (..)


port storeTokenData : LoginResponse -> Cmd msg
port logoutUser : () -> Cmd msg 