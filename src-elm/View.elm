module View exposing (view)

import Html
import Html.Attributes as A
import Model as M


view : M.Model -> Html.Html M.Msg
view model =
    Html.main_
        []
        [ Html.div
            []
            [ Html.p
                []
                [ Html.text "5:07 AM" ]
            , Html.p
                [ A.title "Lose It /this song title is longer than the prescribed width" ]
                [ Html.text "Lose It /this song title is longer than the prescribed width" ]
            , Html.p
                [ A.title "Fetcher /this artist is longer than the prescribed width" ]
                [ Html.text "Fetcher /this artist is longer than the prescribed width" ]
            ]
        , Html.div
            []
            [ Html.p
                []
                [ Html.text "5:03 AM" ]
            , Html.p
                [ A.title "Slow Train /this song title is much longer than the prescribed width" ]
                [ Html.text "Slow Train /this song title is much longer than the prescribed width" ]
            , Html.p
                [ A.title "Pressing Strings /this artist is much longer than the prescribed width" ]
                [ Html.text "Pressing Strings /this artist is much longer than the prescribed width" ]
            ]
        , Html.div
            []
            [ Html.p
                []
                [ Html.text "5:00 AM" ]
            , Html.p
                [ A.title "Walker" ]
                [ Html.text "Walker" ]
            , Html.p
                [ A.title "Animal Collective" ]
                [ Html.text "Animal Collective" ]
            ]
        , Html.div
            []
            [ Html.p
                []
                [ Html.text "4:59 AM" ]
            , Html.p
                [ A.title "Baby I Love You" ]
                [ Html.text "Baby I Love You" ]
            , Html.p
                [ A.title "Modern Nomad" ]
                [ Html.text "Modern Nomad" ]
            ]
        , Html.div
            []
            [ Html.p
                []
                [ Html.text "4:55 AM" ]
            , Html.p
                [ A.title "Peach by Elm" ]
                [ Html.text "Peach by Elm" ]
            , Html.p
                [ A.title "Future Islands" ]
                [ Html.text "Future Islands" ]
            ]
        ]
