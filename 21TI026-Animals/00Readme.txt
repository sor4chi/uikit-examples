# アプリケーションの改良点

## 詳細画像の表示

詳細画像を表示するために、`AnimalInfo`に`imageUrl`を追加しました。
今回は`unsplash`のリソースを利用しています。

UXの観点から、画像のアスペクト比は一定、画像ローディング時/完了時のレイアウトシフトが起きないようにスケルトンローディングを実装しました。

また、今回は「URLから画像を取得する」という処理が必要だったのですが、これをいちいち書くのが面倒だったので`URLImageView`というカスタムクラスを作成しました。

## お気に入り機能

お気に入り機能を実装しました。詳細画面の右下にある星マークをタップすると、お気に入り状態が切り替わります。
`AnimalInfo`に`favorite`、`id`を追加しました。
これは`ViewController`の`AnimalInfoDelegate`を利用して`id`を指定するとそのidの`AnimalInfo`の`favorite`が切り替わるようにしています。

また、お気に入りかどうかで、星マークの画像を`star`と`star.fill`で切り替えています。

## お気に入りフィルタ

一覧画面上部に「お気に入りのみ表示」のスイッチを追加しました。
これは`ViewController`の`AnimalInfoDelegate`を利用して、`favorite`が`true`の`AnimalInfo`のみを表示するようにしています。

表示する`items`配列は`ViewController`の`baseItems`を`switch.isOn`で動的に算出しています。

