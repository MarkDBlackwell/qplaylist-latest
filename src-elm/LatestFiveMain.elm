module LatestFiveMain exposing (main)

import Browser
import Http
import Json.Decode as D
import Model as M
import Port as P
import View


latestFiveGet : M.Model -> Cmd M.Msg
latestFiveGet model =
    let
        url : String
        url =
            String.concat
                [ "../playlist/dynamic/LatestFive"
                , model.channel
                , ".json"
                ]
    in
    Http.get
        { expect = Http.expectJson M.GotSongsResponse latestFiveJsonDecoder
        , url = url
        }


latestFiveJsonDecoder : D.Decoder M.Songs
latestFiveJsonDecoder =
    D.map (List.take M.slotsCount << .latestFive << M.LatestFiveJsonRoot)
        (D.field "latestFive" <| D.list songJsonDecoder)


main : Program M.Channel M.Model M.Msg
main =
    Browser.element
        { init = M.init
        , update = update
        , subscriptions = M.subscriptions
        , view = View.view
        }


songJsonDecoder : D.Decoder M.Song
songJsonDecoder =
    D.map3 M.Song
        (D.field "artist" D.string)
        (D.field "time" D.string)
        (D.field "title" D.string)



-- UPDATE


update : M.Msg -> M.Model -> ( M.Model, Cmd M.Msg )
update msg model =
    case msg of
        M.GotSongsResponse songsResult ->
            case songsResult of
                Err err ->
                    let
                        --ignored =
                        --Debug.log message err
                        message : String
                        message =
                            "songsResult error"
                    in
                    ( model
                    , P.logConsole message
                    )

                Ok songsCurrent ->
                    ( { model
                        | songsCurrent = songsCurrent
                      }
                    , Cmd.none
                    )

        M.GotTimeStart timeStart ->
            let
                delaySeconds : Int
                delaySeconds =
                    30

            in
            ( { model
                | delaySeconds = delaySeconds
                , timeStart = timeStart
              }
            , latestFiveGet model
            )

        M.GotTimeTick _ ->
            ( { model
                | delaySeconds = M.delaySecondsStandard
              }
            , latestFiveGet model
            )
