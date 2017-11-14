module Models exposing (..)


type Content
    = Search
    | News


type alias Model =
    { input : String
    , articles : Articles
    , error : Maybe ErrorM
    }


type alias Config =
    { appName : String
    , version : String
    , endpoint : String
    }


type alias ErrorM =
    { errorType : String
    , errorMessage : String
    }


type alias Articles =
    { content : List Article }


type alias Article =
    { authors : List String
    , canonical_link : String
    , download_state : Int
    , keywords : List String
    , link_hash : String
    , meta_description : String
    , meta_favicon : String
    , meta_img : String
    , meta_keywords : List String
    , meta_lang : String
    , source_url : String
    , summary : String
    , text : String
    , title : String
    , top_image : String
    , top_img : String
    , url : String
    }



-- INIT MODELS


initialModel : Model
initialModel =
    { input = ""
    , articles = Articles []
    , error = Nothing
    }


config : Config
config =
    { appName = "NewsApp"
    , version = "1.0.0"
    , endpoint = "http://localhost:5000/?url="
    }
