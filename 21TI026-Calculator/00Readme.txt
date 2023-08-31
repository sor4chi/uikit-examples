# アプリケーションの改良点

## 計算式の表示

計算式の表示は、ボタンが押されるたびにその値が追加されます。演算子ボタンが押された場合は、計算式の中に演算子が表示されます。
教科書のアプリケーションの挙動では複数回演算子ボタンが押された場合は上書きを行うという仕様になっています。
それに則して複数回演算子ボタンが押された場合は正規表現を行なって演算子を置換するようにしました。

```swift
if let equationText = equation.text, !equationText.isEmpty {
    let regex = try! NSRegularExpression(pattern: "[+\\-×÷]", options: [])
    let range = NSRange(location: 0, length: equationText.count)
    let newEquationText = regex.stringByReplacingMatches(in: equationText, options: [], range: range, withTemplate: op)
    equation.text = newEquationText
}
```

## 前ですが式とその計算結果の表示

教科書のアプリケーションでは計算結果が表示された後にもう一度計算しようとすると、元の結果が消えるという仕様になっています。
ですが多くの場合、計算を連続して行いたいケースというのが多いと思います。
そこで、計算結果が表示された後にもう一度計算しようとすると、前の計算式とその計算結果を表示するようにしました。

## UIの改良 - 色

全てのボタンが単調な色だと、ボタンの印象が均一になっており、UXが悪いと感じました。
そこで、Operation操作をするボタンは安全な操作なので「青色」、AC操作をするボタンは危険な操作なので「赤色」、それ以外のボタンは「灰色」にして、ユーザーに操作の重要性や危険性を直感的に伝えるようにしました。

## UIの改良 - レイアウト

教科書のアプリケーションではレイアウトが縦横揃っていなかったり、ボタンの大きさが縦横揃っていなかったりと配置的なバランスが悪いと感じました。
そこで、ボタンの縦横を揃えてStackのSpacingやSpace Equallyを調整し、グリッド状に配置することで、ボタンの配置を整えました。
ここに関してはStackを使わなくともCollectionViewを使う方が保守的で良かったなと思いました。

## UIの改良 - カスタムボタン

UIKitには角丸ボタンを実現するために少し手間がかかります。
私の場合、`RoundedButton.swift`にて`UIButton`を継承して、`bounds`から取得した`width`と`height`を使って`cornerRadius`を動的に設定するようなカスタムクラスを作成しました。
そして既存のボタンを紐づけることで、自動的に角丸ボタンになるような仕組みを作りました。

```swift
class RoundedButton: UIButton {
    // ...

    layer.cornerRadius = min(bounds.width, bounds.height) / 2
}
```

