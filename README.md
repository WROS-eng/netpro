# netopro

## 超雑なイメージ
![image](https://user-images.githubusercontent.com/12966452/33601139-b1561446-d9ee-11e7-9200-eadb88bfc2e9.png)

## 雑な説明
- Serverがプレイヤー参加受付開始
- Clientが参加リクエスト送る(といってもユーザー名のjson)
- Serverは受取、GameController(以下GC)にプレイヤー登録を依頼
- GCはプレイヤーリストにプレイヤー追加。Serverに追加成功可否を送る
- Serverは追加成功可否をClientへ送り返す
- 参加したClientは開始通知が来るまで待機
- Serverは人数が揃ったら、ゲーム開始通知依頼をGCへ行う
- GCはゲーム開始を行い、各プレイヤーの色と手番を送る
- Serverはそれを各Clientへ送る
- 受け取ったClientはそれを表示

## 雑なクラス図
![image](https://user-images.githubusercontent.com/12966452/33793640-3ebc8754-dcfe-11e7-8032-7a3bcc541455.png)


## 参加する
#### Parameters
`Client.join`

| フィールド    | タイプ | 説明     |
|----------|-----|--------|
| username | 文字列 | プレイヤー名 |

#### Response
`Server.on_join`

| フィールド   | タイプ | 説明      |
|---------|-----|---------|
| status  | 数値  | 通信成否    |
| message | 文字列 | 参加成功可否文 |

## ゲーム開始通知
#### Parameters
`Server.noti_start_game`

| フィールド        | タイプ  | 説明                   |
|--------------|------|----------------------|
| `turn_order` | `string`  | 手番 (first or second) |
| `id`           | `string` | プレイヤーid              |
| `username`     | `string`  | プレイヤー名               |
| `color`        | `int`   | 色 (-1 or 1)          |

#### Response
`Client.on_noti_start_game`

| フィールド | タイプ | 説明  |
|-------|-----|-----|
|       |     |     |


## 手番通知
#### Parameters
`Server.noti_play_turn`

| フィールド        | タイプ  | 説明                   |
|--------------|------|----------------------|
| `turn_count`   | `string`  | ターン数 |
| `is_play_turn` | `bool` | 手番かどうか              |

#### Response
`Client.on_noti_play_turn`

| フィールド | タイプ | 説明  |
|-------|-----|-----|
|       |     |     |
