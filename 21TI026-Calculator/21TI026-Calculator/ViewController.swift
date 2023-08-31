//
//  ViewController.swift
//  21TI026-Calculator
//
//  Created by 川村空千 on 2023/08/29.
//

import UIKit

enum Operator {
    case undefined
    case addition
    case subtraction
    case multiplication
    case division
}

class ViewController: UIViewController {
    var firstValue = 0
    var secondValue = 0
    var currentOperator = Operator.undefined

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var label: UILabel!

    @IBOutlet weak var beforeLabel: UILabel!

    @IBOutlet weak var equation: UILabel!

    @IBAction func numberButtonTapped(_ sender: UIButton) {
        var value = 0
        let number = sender.currentTitle ?? (sender.titleLabel?.text ?? "0")
        switch number {
            case "0":
                value = 0
            case "1":
                value = 1
            case "2":
                value = 2
            case "3":
                value = 3
            case "4":
                value = 4
            case "5":
                value = 5
            case "6":
                value = 6
            case "7":
                value = 7
            case "8":
                value = 8
            case "9":
                value = 9
            default:
                value = 0
        }
        if currentOperator == .undefined {
            firstValue = firstValue * 10 + value
            label.text = "\(firstValue)"
        } else {
            secondValue = secondValue * 10 + value
            label.text = "\(secondValue)"
        }
        equation.text = "\(equation.text ?? "")\(number)"
    }
    @IBAction func operatorButtonTapped(_ sender: UIButton) {
        let op = sender.currentTitle ?? (sender.titleLabel?.text ?? "")
        if firstValue == 0 {
            return
        }
        if currentOperator == .undefined {
            equation.text = "\(equation.text ?? "")\(op)"
        } else {
            if let equationText = equation.text, !equationText.isEmpty {
                let regex = try! NSRegularExpression(pattern: "[+\\-×÷]", options: [])
                let range = NSRange(location: 0, length: equationText.count)
                let newEquationText = regex.stringByReplacingMatches(in: equationText, options: [], range: range, withTemplate: op)
                equation.text = newEquationText
            }
        }
        switch op {
            case "+":
                currentOperator = .addition
            case "-":
                currentOperator = .subtraction
            case "×":
                currentOperator = .multiplication
            case "÷":
                currentOperator = .division
            default:
                currentOperator = .undefined
        }
    }
    @IBAction func equalButtonTapped(_ sender: UIButton) {
        if currentOperator == .undefined {
            return
        }
        var value = 0
        switch currentOperator {
            case .addition:
                value = firstValue + secondValue
            case .subtraction:
                value = firstValue - secondValue
            case .multiplication:
                value = firstValue * secondValue
            case .division:
                value = firstValue / secondValue
            case .undefined:
                value = firstValue
        }
        label.text = "\(value)"
        beforeLabel.text = "\(equation.text ?? "")=\(value)"
        firstValue = 0
        secondValue = 0
        currentOperator = .undefined
        equation.text  = ""
    }
    @IBAction func allClearButtonTapped(_ sender: UIButton) {
        firstValue = 0
        secondValue = 0
        currentOperator = .undefined
        label.text = "0"
        equation.text  = ""
    }
}

