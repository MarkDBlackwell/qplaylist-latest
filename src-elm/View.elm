module View exposing (view)

import Html
import Model as M


view : M.Model -> Html.Html M.Msg
view model =
    Html.main_
        []
        [ Html.text "hello"
        ]
