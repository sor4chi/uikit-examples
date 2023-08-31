# アプリケーションの改良点

## バックグラウンド動作

教科書通りのアプリケーション実装だと、アプリケーションを起動している間でしかタイマーが動作しない。
そこで、`UIApplication.shared.beginBackgroundTask`を用いて、アプリケーションがバックグラウンドに移行した際にもタイマーが動作するように改良した。

```swift
let id: UIBackgroundTaskIdentifier = .invalid

func startBackgroundTask() {
    id = UIApplication.shared.beginBackgroundTask(expirationHandler: {
        self.endBackgroundTask()
    })
}

func endBackgroundTask() {
    UIApplication.shared.endBackgroundTask(id)
    id = .invalid
}
```

このような構造で、`startBackgroundTask`を呼び出すことでバックグラウンドタスクを開始し、`endBackgroundTask`を呼び出すことでバックグラウンドタスクを終了する。idをフィールドに持っておくことで任意の関数からバックグラウンドタスクを終了できるようにしている。

## ローカル通知

タイマーが終了した際に、ローカル通知を送信するように改良した。
iOSは通知の送信にユーザーの許可が必要であるため、`UNUserNotificationCenter.current().requestAuthorization`を用いて許可を取得する。

```swift
UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (granted, error) in
    if granted {
        print("通知の許可が得られました")
    } else {
        print("通知の許可が得られませんでした")
    }
}
```

許可が得られたら、`UNMutableNotificationContent`を用いて通知の内容を設定し、`UNNotificationRequest`を用いて通知を送信する。

## タイマーの上書きバリデーション

実行中のタイマーにさらに実行アクションを発火した場合、タイマーを上書きするかどうかをユーザーに問うように改良した。
`UIAlertController`を用いて、ユーザーに上書きするかどうかを問うアラートを表示する。

```swift
func showConfirmationAlert(title: String, message: String, completion: @escaping (Bool) -> Void) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
        completion(false)
    }

    let confirmAction = UIAlertAction(title: "OK", style: .default) { _ in
        completion(true)
    }

    alertController.addAction(cancelAction)
    alertController.addAction(confirmAction)

    present(alertController, animated: true, completion: nil)
}
```

このように関数化しておくことで、アラートを表示する際に簡単に呼び出せるようになる。

```swift
showConfirmationAlert(title: "確認", message: "現在実行中のタイマーを上書きしますか？") { [weak self] (isConfirmed) in
    if isConfirmed {
        // タイマーを上書きする
    }
}
```

## 時刻表示の改良

教科書通りのアプリケーション実装だと、時刻表示が`残り⚪︎秒`となっている。
そこで、`残り⚪︎秒`の代わりに`HH:mm:ss`の形式で時刻を表示するように改良した。
それ用に、`Int`型の秒数を`HH:mm:ss`の形式の文字列に変換する関数を実装した。

```swift
func serializeToHHMMSS(seconds: Int) -> String {
    let hours = seconds / 3600
    let minutes = seconds / 60 % 60
    let seconds = seconds % 60
    return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
}
```

また、デフォルトのシステムフォントでは数字の幅によって変わってしまう問題があるため、`UIFont.monospacedDigitSystemFont(ofSize: 64, weight: UIFont.Weight.regular)`で等幅システムフォントの取得設定を行った。
こうすることで数字が変化した時のガタつきを防ぐことができた。

## Time Pickerの導入

教科書通りのアプリケーション実装だと、タイマーの時間はこちらが用意したボタンを押して決定する必要がある。
任意のタイマーを設定できるようにするために、`UIDatePicker`を用いて時間を選択できるように改良した。
