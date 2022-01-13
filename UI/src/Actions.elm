module Actions exposing (..)

-- standard imports
-- vendor imports
-- custom imports

import Browser
import Graphql.Http
import Http
import Http.Detailed
import RemoteData exposing (..)
import Types exposing (..)
import Url



-- MSG


onUrlRequest : Browser.UrlRequest -> Msg
onUrlRequest req =
    LinkClicked req


onUrlChange : Url.Url -> Msg
onUrlChange url =
    UrlChanged url


type Msg
    = NoOp
    | HelloWorld (WebData String)
    | ReadLoginToken (WebData Token)
    | LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | GetWebDataExample (WebData (List Todo))
    | GetDetailedErrorActionExample (RemoteData (Http.Detailed.Error String) ( Http.Metadata, Bool ))
    | SignupResponseAction (RemoteData (Graphql.Http.Error MaybeSignupResponse) MaybeSignupResponse)
    | RegisterUserAction String String
    | UpdateSignupUsername String
    | UpdateSignupPassword String
