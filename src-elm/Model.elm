module Model exposing (..)

import Http
import Task
import Time


type alias Artist =
    String


type alias Channel =
    String


type alias LatestFiveJsonRoot =
    { latestFive : Songs }


type alias Model =
    { channel : Channel
    , delaySeconds : Int
    , songsCurrent : Songs
    , timeStart : Time.Posix
    }


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


type Msg
    = GotSongsResponse (Result Http.Error Songs)
    | GotTimeStart Time.Posix
    | GotTimeTick Time.Posix


delaySecondsStandard : Int
delaySecondsStandard =
    20


slotsCount : Int
slotsCount =
    5



-- INITIALIZATION


init : Channel -> ( Model, Cmd Msg )
init channel =
    ( { channel = channel
      , delaySeconds = 0
      , songsCurrent = songsCurrentInit
      , timeStart = Time.millisToPosix 0
      }
    , Task.perform GotTimeStart Time.now
    )


songsCurrentInit : Songs
songsCurrentInit =
    let
        songEmpty : Song
        songEmpty =
            Song "" "" ""
    in
    List.repeat slotsCount songEmpty



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    let
        subs : Sub Msg
        subs =
            let
                delay : Float
                delay =
                    toFloat (model.delaySeconds * 1000)
            in
            if Time.posixToMillis model.timeStart < 1000 then
                Sub.none

            else
                --The first tick happens after the delay.
                Time.every delay GotTimeTick
    in
    subs
