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


## 参加する
### request
`Client.join`

| フィールド    | タイプ | 説明     |
|----------|-----|--------|
| username | 文字列 | プレイヤー名 |

### response
`Server.on_join`

| フィールド   | タイプ | 説明      |
|---------|-----|---------|
| status  | 数値  | 通信成否    |
| message | 文字列 | 参加成功可否文 |

## ゲーム開始通知
### request
`Server.noti_start_game`

| フィールド    | タイプ  | 説明                   |
|----------|------|----------------------|
| turn     | 文字列  | 手番 (first or second) |
| id       | UUID | プレイヤーid              |
| username | 文字列  | プレイヤー名               |
| color    | 数値   | 色 (-1 or 1)          |

### response
`Client.on_noti_start_game`

| フィールド | タイプ | 説明  |
|-------|-----|-----|
|       |     |     |
