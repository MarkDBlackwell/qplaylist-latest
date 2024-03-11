module Model exposing (..)

import Http
import Task
import Time



-- ELM ARCHITECTURE


type alias Model =
    { channel : Channel
    , delaySeconds : Int
    , songsCurrent : Songs
    , timeNow : Time.Posix
    }


type Msg
    = GotSongsResponse (Result Http.Error Songs)
    | GotTimeNow Time.Posix
    | GotTimer Time.Posix



-- INITIALIZATION


init : Channel -> ( Model, Cmd Msg )
init channel =
    let
        songsCurrentInit : Songs
        songsCurrentInit =
            let
                songEmpty : Song
                songEmpty =
                    Song "" "" ""
            in
            List.repeat slotsCount songEmpty
    in
    ( { channel = channel
      , delaySeconds = delayStandard
      , songsCurrent = songsCurrentInit
      , timeNow = Time.millisToPosix 0
      }
    , Task.perform GotTimer Time.now
    )



-- APPLICATION-SPECIFIC


type alias Artist =
    String


type alias Channel =
    String


type alias LatestFiveJsonRoot =
    { latestFive : Songs }


type alias Song =
    { artist : Artist
    , time : SongTime
    , title : Title
    }


type alias Songs =
    List Song


type alias SongTime =
    String


type alias Title =
    String


delayStandard : Int
delayStandard =
    60


slotsCount : Int
slotsCount =
    5



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    let
        timerActivate : Sub Msg
        timerActivate =
            let
                milliseconds : Float
                milliseconds =
                    toFloat (model.delaySeconds * 1000)

                timeNotSet : Bool
                timeNotSet =
                    Time.posixToMillis model.timeNow < 1000
            in
            if timeNotSet then
                --Only when the program is freshly loaded.
                Sub.none

            else
                --The first tick happens after the delay.
                Time.every milliseconds GotTimer
    in
    timerActivate
