module InteropDefinitions exposing (Flags, FromElm(..), ToElm(..), interop)

import Json.Encode
import TsJson.Decode as TsDecode exposing (Decoder)
import TsJson.Encode as TsEncode exposing (Encoder, optional, required)
import Types exposing (..)


interop :
    { toElm : Decoder ToElm
    , fromElm : Encoder FromElm
    , flags : Decoder Flags
    }
interop =
    { toElm = toElm
    , fromElm = fromElm
    , flags = flags
    }


type FromElm
    = Alert String


type ToElm
    = AuthenticatedUser User


type alias User =
    { username : String }


fromElm : Encoder FromElm
fromElm =
    TsEncode.union
        (\vAlert value ->
            case value of
                Alert string ->
                    vAlert string
        )
        |> TsEncode.variantTagged "alert"
            (TsEncode.object [ required "message" identity TsEncode.string ])
        |> TsEncode.buildUnion


toElm : Decoder ToElm
toElm =
    TsDecode.discriminatedUnion "tag"
        [ ( "authenticatedUser"
          , TsDecode.map AuthenticatedUser
                (TsDecode.map User
                    (TsDecode.field "username" TsDecode.string)
                )
          )
        ]


type Os
    = Mac
    | Windows
    | Linux
    | Unknown


type alias Flags =
    { os : Os, token : MaybeToken }



-- flags : Decoder Flags


os_decoder : TsDecode.Decoder Os
os_decoder =
    TsDecode.oneOf
        [ TsDecode.literal Windows (Json.Encode.string "Windows")
        , TsDecode.literal Mac (Json.Encode.string "MacOs")
        , TsDecode.literal Linux (Json.Encode.string "Linux")
        , TsDecode.literal Unknown (Json.Encode.string "Mobile/Unknown")
        ]


token_decoder : TsDecode.Decoder Token
token_decoder =
    TsDecode.field "token" TsDecode.string |> TsDecode.map Token


flags : TsDecode.Decoder Flags
flags =
    TsDecode.map2
        (\v1 v2 -> { os = v1, token = v2 })
        (TsDecode.field "os" os_decoder)
        (TsDecode.optionalField "token" token_decoder)
