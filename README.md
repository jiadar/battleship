# Battleship
A rails-backed API for networked battleship

## Gameplay
To play, you need to create an account or log in to an existing one. See table below for API endpoints.

Once you have an account, you can `POST` to `api/v1/games` to create a new game lobby. The response will
contain a game GUID which you can use to invite another player. To join an existing game, you can `PUT` to
`api/v1/games/:guid/join`. Once two players have joined a game lobby, the game state will change from `waiting`
to `placing`. At this point, both players can `POST` a nested array of their ships to `api/v1/games/:guid/board`.
For an example of what a ship placement JSON request should look like, see [the example below](#ship-placement).
Once both players have placed their ships, the game state will change from `placing` to `playing` and players can
then alternate `POST`ing shot coordinates to `api/v1/games/:guid/board` as seen in [the example below](#shot-placement).
The game will end when a user has all of their ships sunk. At this point, the game will move to the `finished` and no more
shots can be fired. However, you can still view game and board state by `GET`ing `api/v1/games/:guid/board`.

## API

Below is a table of available API endpoints, the parameters they take, a successful response example and brief
usage description.

| Path                            | Params `{key: value}`                         | Success Response    | Use   |
|---------------------------------|-----------------------------------------------|---------------------|-------|
| [POST] /users                   | {usernamename: "Colin", password: "p4ssw0rd"} | User JSON object    | Create account |
| [POST] /sessions                | {usernamename: "Colin", password: "p4ssw0rd"} | User JSON object    | Log in to account |
| [DELETE] /sessions              | {}                                            | Success JSON message| Log out of account |
| [POST] /api/v1/games            | {}                                            | Game JSON object    | Create a new game lobby|
| [GET] /api/v1/games/:guid       | {}                                            | Game JSON object    | Get game state from a game GUID|
| [PUT] /api/v1/games/:guid/join  | {}                                            | Game JSON object    | Join an existing game from a supplied GUID
| [PUT] /api/v1/games/:guid/board | {shot: [0,0]} or {ships: [...]}               | Game & Board JSON objects, shot result | Send a move to your game board|
| [GET] /api/v1/games/:guid/board |{}                                             | Game & Board JSON objects | Get the board status of a game you are playing|

## Shot Placement
Below is an example of placing a shot on the board. The response will be `hit`, `miss`, or `already targeted`.
Shot coordinates are specified as X,Y and begin at the top-most left-most corner of a board. In other words,
0,0 is the top left corner and 10,10 is the bottom right corner. Positive Y coordinates are offsets from the top,
positive X coordinates are offsets from the left. You may not use negative coordinates.

```
{
    "board": {
       "shot": [0,1]
    }
}
```

## Ship Placement

Below is an example of placing ships on a board. You must place 5 ships of the following lengths:
| Size | Number of Ships|
|------|----------------|
| 2    | 1              |
| 3    | 2              |
| 4    | 1              |
| 5    | 1              |

Ship coordinates are specified as X,Y and begin at the top-most left-most corner of a board. In other words,
0,0 is the top left corner and 10,10 is the bottom right corner. Positive Y coordinates are offsets from the top,
positive X coordinates are offsets from the left. You may not use negative coordinates.

```
{
    "board": {
        "ships": [
            {"ship": [
                {"coord": [0,0]},
                {"coord": [0,1]}
                ]
            },
            {"ship": [
                {"coord": [1,0]},
                {"coord": [1,1]},
                {"coord": [1,2]}
                ]
            },
            {"ship": [
                {"coord": [2,0]},
                {"coord": [2,1]},
                {"coord": [2,2]}
                ]
            },
            {"ship": [
                {"coord": [3,0]},
                {"coord": [3,1]},
                {"coord": [3,2]},
                {"coord": [3,3]}
                ]
            },
            {"ship": [
                {"coord": [4,0]},
                {"coord": [4,1]},
                {"coord": [4,2]},
                {"coord": [4,3]},
                {"coord": [4,4]}
                ]
            }
        ]
    }
}
```
