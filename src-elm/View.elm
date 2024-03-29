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

                lazyViewSong : M.Song -> Html.Html M.Msg
                lazyViewSong song =
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
            Tuple.pair key <| Html.Lazy.lazy lazyViewSong songForKey
    in
    Html.Keyed.node
        "main"
        []
        (List.map keyedSong model.songsCurrent)
