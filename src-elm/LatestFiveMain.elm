module LatestFiveMain exposing (main)

import Browser
import Http
import Json.Decode as D
import Model as M
import Port as P
import Task
import Time
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
                    , Task.perform M.GotTimeNow Time.now
                    )

        M.GotTimeNow timeNow ->
            let
                delaySeconds : Int
                delaySeconds =
                    let
                        over : Int
                        over =
                            let
                                start : Int
                                start =
                                    Time.posixToMillis timeNow // 1000
                            in
                            start
                                |> modBy standard

                        phase : Int
                        phase =
                            if String.isEmpty model.channel then
                                0

                            else
                                standard // 2

                        standard : Int
                        standard =
                            60
                    in
                    standard - over + phase
            in
            ( { model
                | delaySeconds = delaySeconds
                , timeNow = timeNow
              }
            , Cmd.none
            )

        M.GotTimer _ ->
            ( model
            , Cmd.batch
                [ Task.perform M.GotTimeNow Time.now
                , latestFiveGet model
                ]
            )
