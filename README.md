# netopro

## 超雑なイメージ
![image](https://user-images.githubusercontent.com/12966452/33601139-b1561446-d9ee-11e7-9200-eadb88bfc2e9.png)

## 参加する
### request
`Client.join`

| フィールド    | タイプ | 説明     |
|----------|-----|--------|
| username | 文字列 | プレイヤー名 |

### response
`Server.on_join`

| フィールド    | タイプ  | 説明          |
|----------|------|-------------|
| status   | 数値   | 通信成否        |
| id       | UUID | プレイヤーid     |
| username | 文字列  | プレイヤー名      |
| color    | 数値   | 色 (-1 or 1) |

## ゲーム開始通知
### request
`Server.noti_start_game`

| フィールド | タイプ | 説明                   |
|-------|-----|----------------------|
| turn  | 文字列 | 手番 (first or second) |
| color | 数値  | 色 (-1 or 1)          |

### response
`Client.on_noti_start_game`

| フィールド | タイプ | 説明  |
|-------|-----|-----|
|       |     |     |
