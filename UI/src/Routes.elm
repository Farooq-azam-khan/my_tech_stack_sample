module Routes exposing (..)

import Url.Parser exposing ((</>), Parser, int, map, oneOf, s, string, top)


type Route
    = TodoR Int
    | HomeR
    | UserR String
    | LoginR
    | RegisterR
    | ErrorR


routeParser : Parser (Route -> a) a
routeParser =
    oneOf
        [ map TodoR (s "todo" </> int)
        , map UserR (s "user" </> string)
        , map HomeR (s "home")
        , map HomeR top
        , map LoginR (s "login")
        , map LoginR (s "sign-in")
        , map LoginR (s "signin")
        , map RegisterR (s "register")
        , map RegisterR (s "sign-up")
        , map RegisterR (s "signup")
        ]
