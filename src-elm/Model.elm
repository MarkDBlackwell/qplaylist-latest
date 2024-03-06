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


cmdMsg2Cmd : Msg -> Cmd Msg
cmdMsg2Cmd msg =
    --See:
    --  http://github.com/billstclair/elm-dynamodb/blob/7ac30d60b98fbe7ea253be13f5f9df4d9c661b92/src/DynamoBackend.elm
    --For wrapping a message as a Cmd:
    msg
        |> Task.succeed
        |> Task.perform
            identity


slotsCount : Int
slotsCount =
    5



-- INITIALIZATION


init : Channel -> ( Model, Cmd Msg )
init channel =
    ( { channel = channel
      , songsCurrent = songsCurrentInit
      }
    , Time.millisToPosix 0
        |> GotTimeTick
        |> cmdMsg2Cmd
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
    --The first tick happens after the delay.
    Time.every (delaySeconds * 1000.0) GotTimeTick
