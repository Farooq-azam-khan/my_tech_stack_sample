module Routes exposing (..)

import Url.Parser exposing ((</>), Parser, int, map, oneOf, s, string, top)


type Route
    = TodoR Int
    | HomeR
    | ActiveR
    | CompletedR
    | UserR String
    | LoginR
    | RegisterR
    | ErrorR
    | LogoutR


routeParser : Parser (Route -> a) a
routeParser =
    oneOf
        [ map HomeR top
        , map HomeR (s "home")
        , map HomeR (s "all")
        , map ActiveR (s "active")
        , map CompletedR (s "completed")
        , map LoginR (s "login")
        , map LoginR (s "sign-in")
        , map LoginR (s "signin")
        , map RegisterR (s "register")
        , map RegisterR (s "sign-up")
        , map RegisterR (s "signup")
        , map LogoutR (s "logout")
        , map TodoR (s "todo" </> int)
        , map UserR (s "user" </> string)
        ]
