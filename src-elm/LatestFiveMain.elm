--TODO: Rename to Main, but keep the compiler output as LatestFiveMain.js.


module LatestFiveMain exposing (main)

import Browser
import Decode as D
import Http
import Model as M
import Port as P
import Task
import Time
import View



-- ELM ARCHITECTURE


main : Program M.Channel M.Model M.Msg
main =
    Browser.element
        { init = M.init
        , update = update
        , subscriptions = M.subscriptions
        , view = View.view
        }



-- APPLICATION-SPECIFIC


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
        { expect = Http.expectJson M.GotSongsResponse D.latestFiveJsonDecoder
        , url = url
        }



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
