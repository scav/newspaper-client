module Models exposing (..)


type Content
    = Search
    | News


type alias Model =
    { location : String
    , input : String
    , articles : Articles
    , error : Maybe ErrorM
    }


type alias Config =
    { appName : String
    , version : String
    , endpointHead : String
    , endpointTail : String
    }


type alias ErrorM =
    { errorType : String
    , errorMessage : String
    }


type alias Articles =
    { content : List Article }


type alias Article =
    { authors : List String
    , summary : String
    , text : String
    , title : String
    , top_image : String
    , url : String
    }



-- INIT MODELS


initialModel : Model
initialModel =
    { location = ""
    , input = ""
    , articles = Articles []
    , error = Nothing
    }


config : Config
config =
    { appName = "NewsApp"
    , version = "1.0.0"
    , endpointHead = "http://"
    , endpointTail = "/?url="
    }
