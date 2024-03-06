module Model exposing (..)

import Http
import Time


type alias Artist =
    String


type alias Channel =
    String


type alias LatestFiveJsonRoot =
    { latestFive : Songs }


type alias Model =
    { channel : Channel
    , songsCurrent : Songs
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
    | GotTimeTick Time.Posix


slotsCount : Int
slotsCount =
    5



-- INITIALIZATION


init : Channel -> ( Model, Cmd Msg )
init channel =
    ( { channel = channel
      , songsCurrent = songsCurrentInit
      }
    , Cmd.none
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
        delaySeconds : Float
        delaySeconds =
            20.0
    in
    Time.every (delaySeconds * 1000.0) GotTimeTick
