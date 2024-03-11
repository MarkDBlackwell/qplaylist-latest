module Main exposing (main)

import Browser
import Decode as D
import Http
import Model as M
import Task
import Time
import Url.Builder as U
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
            let
                basename : String
                basename =
                    String.concat
                        [ "LatestFive"
                        , model.channel
                        , ".json"
                        ]
            in
            U.relative
                [ "..", "playlist", "dynamic", basename ]
                []
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
                    ( model
                    , Cmd.none
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
                                nowSeconds : Int
                                nowSeconds =
                                    let
                                        milliseconds : Int
                                        milliseconds =
                                            Time.posixToMillis timeNow
                                    in
                                    milliseconds // 1000

                                phase : Int
                                phase =
                                    if String.isEmpty model.channel then
                                        0

                                    else
                                        standard // 2
                            in
                            nowSeconds - phase |> modBy standard

                        standard : Int
                        standard =
                            M.delayStandard
                    in
                    standard - over
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
