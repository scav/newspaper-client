module Style exposing (..)

import Css exposing (..)
import Css.Elements exposing (..)
import Css.Namespace exposing (..)
import Css.File


-- https://coolors.co/2f6690-3a7ca5-d9dcd6-16425b-81c3d7


type CssClasses
    = Content
    | Title
    | Footer
    | InputBar
    | FetchButton
    | ArticleContainer
    | ArticleImage
    | ArticleImageLarge
    | Error


style : Stylesheet
style =
    (stylesheet << namespace "newspaper")
        [ body
            [ backgroundColor (rgb 217 220 214)
            , overflowX auto
            , overflowY auto
            , padding (px 10)
            ]
        , class Content
            [ margin auto
            , width (pct 50)
            , height (pct 100)
            , padding (px 10)
            ]
        , id InputBar
            [ margin auto
            , width (pct 90)
            , padding (px 20)
            , fontSize (px 40)
            ]
        , input
            [ borderStyle solid
            , borderWidth (px 3)
            , borderColor (rgb 74 111 165)
            , color (rgb 22 96 136)
            , backgroundColor (rgb 192 214 223)
            , focus
                [ borderColor (rgb 92 143 94)
                ]
            ]
        , id Title
            [ color (rgb 92 143 94)
            , textAlign center
            ]
        , class ArticleContainer
            [ color (rgb 92 143 94)

            --, fontSize (px 10)
            , float left
            , marginTop (px 20)
            , marginLeft (px 80)
            ]
        , id ArticleImage
            [ width (pct 50)
            , height (pct 50)
            , hover
                [ transform (scale 1.5)
                ]
            ]
        , id Error
            [ backgroundColor (rgb 225 100 100)
            , color (rgb 255 255 255)
            , width (pct 90)
            , padding (px 22)
            ]
        ]


css : String
css =
    [ style ]
        |> Css.File.compile
        |> .css
