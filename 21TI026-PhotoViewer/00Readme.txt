# アプリケーションの改良点

## 詳細画像の表示

一覧画像から各Collection Itemをクリックすると、`DetailViewController`に遷移し、詳細画像を表示するようにしました。
このときに`PHAsset`を使用して、遷移時に画像を渡すように実装しました。

## 作成時刻の表示

`PHAsset.creationDate`を使用して、作成時刻を上に表示するようにしました。

## ページネーション

下部分に`Prev`と`Next`のボタンを追加し、それぞれ前の画像と次の画像を表示するようにしました。
`navigationController.pushViewController`は通常右向きのアニメーションですが、`CATransition`を使用して`Prev`の時は左向き、`Next`の時は右向きのアニメーションにしました。

中央には現在のページ数/総ページ数を表示するようにしました。
