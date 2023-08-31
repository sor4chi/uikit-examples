//
//  ViewController.swift
//  21TI026-Timer
//
//  Created by 川村空千 on 2023/08/30.
//

import UIKit
import AudioToolbox
import UserNotifications

class ViewController: UIViewController {
    var timer: Timer?
    var currentSeconds = 0
    var backgroundTaskIdentifier: UIBackgroundTaskIdentifier = .invalid

    override func viewDidLoad() {
        super.viewDidLoad()
        label.font = UIFont.monospacedDigitSystemFont(ofSize: 64, weight: UIFont.Weight.regular)

        // Do any additional setup after loading the view.
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            if granted {
                print("通知の許可が得られました")
            } else {
                print("通知の許可が得られませんでした")
            }
        }
    }

    @IBOutlet weak var label: UILabel!

    @IBAction func startTimer(_ sender: Any) {
        if (self.timer?.isValid == true) {
            return
        }
        start(seconds: currentSeconds)
    }

    func setSeconds(seconds: Int) {
        currentSeconds = seconds
        label.text = serializeToHHMMSS(seconds: currentSeconds)
    }

    // Date Pickerの紐づいた関数
    @IBAction func timePicker(_ sender: Any) {
        let timePicker = sender as! UIDatePicker
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm:ss"
        let strDate = timeFormatter.string(from: timePicker.date)
        let date = timeFormatter.date(from: strDate)
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date!)
        let minute = calendar.component(.minute, from: date!)
        let second = calendar.component(.second, from: date!)
        let seconds = hour * 3600 + minute * 60 + second
        if (self.timer?.isValid == true) {
            showConfirmationAlert(title: "タイマーをリセットしますか？", message: "現在のタイマーをリセットして、\(strDate)から開始しますか？") { (isConfirmed) in
                if (isConfirmed) {
                    self.timer?.invalidate()
                    self.setSeconds(seconds: seconds)
                }
            }
        } else {
            self.setSeconds(seconds: seconds)
        }
    }

    @IBAction func tenSecButtonTapped(_ sender: UIButton) {
        if (self.timer?.isValid == true) {
            showConfirmationAlert(title: "タイマーをリセットしますか？", message: "現在のタイマーをリセットして、10秒から開始しますか？") { (isConfirmed) in
                if (isConfirmed) {
                    self.timer?.invalidate()
                    self.setSeconds(seconds: 10)
                }
            }
        } else {
            self.setSeconds(seconds: 10)
        }
    }

    @IBAction func threeMinButtonTapped(_ sender: UIButton) {
        if (self.timer?.isValid == true) {
            showConfirmationAlert(title: "タイマーをリセットしますか？", message: "現在のタイマーをリセットして、3分から開始しますか？") { (isConfirmed) in
                if (isConfirmed) {
                    self.timer?.invalidate()
                    self.setSeconds(seconds: 180)
                }
            }
        } else {
            self.setSeconds(seconds: 180)
        }
    }

    @IBAction func fiveMinButtonTapped(_ sender: UIButton) {
        if (self.timer?.isValid == true) {
            showConfirmationAlert(title: "タイマーをリセットしますか？", message: "現在のタイマーをリセットして、5分から開始しますか？") { (isConfirmed) in
                if (isConfirmed) {
                    self.timer?.invalidate()
                    self.setSeconds(seconds: 300)
                }
            }
        } else {
            self.setSeconds(seconds: 300)
        }
    }

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

    func start(seconds: Int) {
        backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask(withName: "Background Countdown") {
            UIApplication.shared.endBackgroundTask(self.backgroundTaskIdentifier)
            self.backgroundTaskIdentifier = .invalid

            // タイマーを停止
            self.timer?.invalidate()
        }

        timer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(ViewController.update),
            userInfo: nil,
            repeats: true
        )
    }

    func serializeToHHMMSS(seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = seconds / 60 % 60
        let seconds = seconds % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }

    @objc func update() {
        currentSeconds -= 1
        label.text = serializeToHHMMSS(seconds: currentSeconds)
        if (currentSeconds == 0) {
            timer?.invalidate()
            let soundId: SystemSoundID = 1005
            AudioServicesPlaySystemSound(soundId)

            UIApplication.shared.endBackgroundTask(self.backgroundTaskIdentifier)
            self.backgroundTaskIdentifier = .invalid

            self.sendNotification()
        }
    }

    func sendNotification() {
        let content = UNMutableNotificationContent()
        content.title = "タイマー終了"
        content.body = "指定時間が経過しました"
        content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "TimerNotification", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("通知の送信に失敗しました: \(error.localizedDescription)")
            } else {
                print("通知を送信しました")
            }
        }
    }
}

