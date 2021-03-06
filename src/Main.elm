module Main exposing (..)

import Html.CssHelpers
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onFocus, onInput, onSubmit)
import Keyboard
import Html.CssHelpers as CSSH exposing (..)
import Models exposing (..)
import Style as Style exposing (..)
import Http
import Json.Decode as Decode
import Json.Decode.Pipeline as Pipeline exposing (..)
import Debug exposing (log)


-- MAIN


main : Program Never Model Msg
main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }


init : ( Model, Cmd Msg )
init =
    ( initialModel, Cmd.none )



-- MESSAGES


type Msg
    = KeyMsg Keyboard.KeyCode
    | Input String
    | Location String
    | Fetch
    | FetchArticle (Result Http.Error Models.Articles)



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Input input ->
            ( { model | input = input }, Cmd.none )

        Location location ->
            ( { model | location = location }, Cmd.none )

        Fetch ->
            ( model, (getArticle model.location model.input) )

        FetchArticle (Ok res) ->
            ( Model "" "" res Nothing, Cmd.none )

        FetchArticle (Err err) ->
            httpError model err

        --UnexpectedPayload
        KeyMsg keyCode ->
            ( model, Cmd.none )


{-| Just some simple error handling.
Probably NetworkError will be the only error we are looking at.
-}
httpError : Model -> Http.Error -> ( Model, Cmd Msg )
httpError model err =
    case err of
        Http.NetworkError ->
            ( { model | error = Just (ErrorM (toString err) "Unable to reach service.") }
            , Cmd.none
            )

        Http.BadUrl badUrl ->
            ( { model | error = Just (ErrorM (toString err) "Did you supply a correct target location?") }
            , Cmd.none
            )

        Http.Timeout ->
            ( { model | error = Just (ErrorM (toString err) "Connection timed out.") }
            , Cmd.none
            )

        Http.BadStatus status ->
            ( { model | error = Just (ErrorM (toString err) (toString status)) }
            , Cmd.none
            )

        Http.BadPayload s payload ->
            ( { model | error = Just (ErrorM (toString err) (s ++ toString payload)) }
            , Cmd.none
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Keyboard.downs KeyMsg
        ]



-- VIEW CODE


{ id, class, classList } =
    Html.CssHelpers.withNamespace "newspaper"


view : Model -> Html Msg
view model =
    body []
        [ Html.CssHelpers.style Style.css
        , div [ class [ Style.Content ] ]
            [ h1 [ id [ Style.Title ] ] [ text config.appName ]
            , Html.form [ onSubmit Fetch ]
                [ input [ id [ Style.InputBar ], onInput Location, onSubmit Fetch, placeholder "API location (e.g. localhost:5000)" ] [] ]
            , Html.form [ onSubmit Fetch ]
                [ input [ id [ Style.InputBar ], onInput Input, onSubmit Fetch, placeholder "Target location (e.g. nrk.no)" ] [] ]
            , div [] (List.map resultView model.articles.content)
            , errorView model
            ]
        , div [] [ text (toString model.location) ]
        ]


resultView : Article -> Html Msg
resultView article =
    div [ class [ Style.ArticleContainer ] ]
        [ h1 [] [ text article.title ]
        , h4 [] [ text article.summary ]
        , img [ id [ Style.ArticleImage ], src article.top_image ] []
        , p []
            [ a [ href article.url ] [ text "Les mer..." ]
            ]
        ]


errorView : Model -> Html Msg
errorView model =
    case model.error of
        Nothing ->
            div [] []

        Just err ->
            div [ id [ Style.Error ] ]
                [ h4 [] [ text (toString err.errorType) ]
                , text (toString err.errorMessage)
                ]



-- HTTP


getArticle : String -> String -> Cmd Msg
getArticle location input =
    let
        url =
            config.endpointHead ++ location ++ config.endpointTail ++ input
    in
        log location
            Http.send
            FetchArticle
            (Http.get url decodeResult)


decodeResult : Decode.Decoder Models.Articles
decodeResult =
    Decode.map
        Models.Articles
        (Decode.field "content" (Decode.list articleDecoder))


articleDecoder : Decode.Decoder Models.Article
articleDecoder =
    Pipeline.decode Models.Article
        |> Pipeline.optional "authors" (Decode.list Decode.string) [ "" ]
        |> Pipeline.required "summary" Decode.string
        |> Pipeline.required "text" Decode.string
        |> Pipeline.required "title" Decode.string
        |> Pipeline.required "top_image" Decode.string
        |> Pipeline.required "url" Decode.string
