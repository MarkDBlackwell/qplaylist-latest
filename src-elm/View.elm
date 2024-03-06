module View exposing (view)

import Html
import Html.Attributes as A
import Html.Keyed
import Html.Lazy
import Model as M


view : M.Model -> Html.Html M.Msg
view model =
    let
        keyedSong : M.Song -> ( String, Html.Html M.Msg )
        keyedSong songForKey =
            let
                key : String
                key =
                    String.concat
                        [ songForKey.artist
                        , ": "
                        , songForKey.time
                        , ": "
                        , songForKey.title
                        ]

                lazySong : M.Song -> Html.Html M.Msg
                lazySong song =
                    Html.div
                        []
                        [ Html.p
                            []
                            [ Html.text song.time ]
                        , Html.p
                            [ A.title song.title ]
                            [ Html.text song.title ]
                        , Html.p
                            [ A.title song.artist ]
                            [ Html.text song.artist ]
                        ]
            in
            Html.Lazy.lazy lazySong songForKey
                |> Tuple.pair key
    in
    Html.Keyed.node
        "main"
        []
        (model.songsCurrent
            |> List.map keyedSong
        )
