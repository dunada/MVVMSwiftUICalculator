//
//  Calculator.swift
//  MVVMSwiftUICalculator
//
//  Created by Eduardo Rodrigues on 08/03/24.
//

import Foundation
import SwiftUI

enum Digit: Int, CaseIterable, CustomStringConvertible {
    case zero, one, two, three, four, five, six, seven, eight, nine

    var description: String {
        "\(rawValue)"
    }
}

enum Operation: CaseIterable, CustomStringConvertible {
    case addition, subtraction, multiplication, division

    var description: String {
        switch self {
        case .addition:
            return "+"
        case .subtraction:
            return "−"
        case .multiplication:
            return "×"
        case .division:
            return "÷"
        }
    }
}

private struct Expression: Equatable {
    var number: Decimal
    var operation: Operation

    func evaluate(with secondNumber: Decimal) -> Decimal {
        switch operation {
        case .addition:
            return number + secondNumber
        case .subtraction:
            return number - secondNumber
        case .multiplication:
            return number * secondNumber
        case .division:
            return number / secondNumber
        }
    }
}

enum ActionType: Hashable, CustomStringConvertible {

    case digit(_ digit:Digit)
    case operation(_ operation:Operation)
    case negative
    case percent
    case decimal
    case equals
    case allClear
    case clear

    var description: String {
        switch self {
        case .digit(let digit):
            return digit.description
        case .operation(let operation):
            return operation.description
        case .negative:
            return "±"
        case .percent:
            return "%"
        case .decimal:
            return "."
        case .equals:
            return "="
        case .allClear:
            return "AC"
        case .clear:
            return "C"
        }
    }
    var backgroundColor: Color {
        switch self {
        case .allClear, .clear, .negative, .percent:
            return Color(.lightGray)
        case .operation, .equals:
            return .orange
        case .digit, .decimal:
            return .secondary
        }
    }

    var foregroundColor: Color {
        switch self {
        case .allClear, .clear, .negative, .percent:
            return .black
        default:
            return .white
        }
    }
}

struct Calculator {

    private var decimalSeparator: Bool = false
    private var expression: Expression?
    private var result: Decimal?
    private var carryingNegative: Bool = false
    private var pressedClear: Bool = false
    private (set) var history = [String]()

    var displayText:String {
        return getNumberString(forNumber: number, withCommas: true)
    }

    private var number: Decimal? {
        if pressedClear || decimalSeparator {
            return newNumber
        }
        return newNumber ?? expression?.number ?? result
    }

    private var newNumber: Decimal? {
        didSet {
            guard newNumber != nil else { return }
            carryingNegative = false
            decimalSeparator = false
            pressedClear = false
        }
    }
    private var containsDecimal: Bool {
        return getNumberString(forNumber: number).contains(".")
    }
    var showAllClear: Bool {
        newNumber == nil && expression == nil && result == nil || pressedClear
    }

    private mutating func setDigit(_ digit:Digit) {
        let numberString = getNumberString(forNumber: newNumber)
        newNumber = Decimal(string: numberString.appending("\(digit.rawValue)"))
    }

    private mutating func setOperation(_ operation: Operation) {
        guard var number = newNumber ?? result else { return }
        if let existingExpression = expression {
            number = existingExpression.evaluate(with: number)
            saveToHistory(result: number)
        }
        expression = Expression(number: number, operation: operation)
        newNumber = nil
    }

    private mutating func toggleSign() {
        if let number = newNumber {
            newNumber = -number
            return
        }
        if let number = result {
            result = -number
            return
        }
        carryingNegative.toggle()
    }

    private mutating func setPercent() {
        if let number = newNumber {
            newNumber = number / 100
            return
        }

        if let number = result {
            result = number / 100
            return
        }
    }

    private mutating func setDecimal() {
        if containsDecimal { return }
        decimalSeparator = true
    }

    private mutating func evaluate() {
        guard let number = newNumber, let existingExpression = expression else { return }
        result = existingExpression.evaluate(with: number)
        saveToHistory(result: result)
        expression = nil
        newNumber = nil
    }

    private mutating func allClear() {
        newNumber = nil
        expression = nil
        result = nil
        carryingNegative = false
        decimalSeparator = false
        history = []
    }

    private mutating func clear() {
        newNumber = nil
        carryingNegative = false
        decimalSeparator = false
        pressedClear = true
        history = []
    }

    mutating func saveToHistory(result: Decimal?) {
        guard let newNumber = newNumber, let existingExpression = expression, let result = result else {
            return
        }
        if history.count >= 5 {
            history.removeFirst()
        }
        history.append("\(existingExpression.number) \(existingExpression.operation) \(newNumber) = \(result)")
    }


    private func getNumberString(forNumber number: Decimal?, withCommas: Bool = false) -> String {
        var numberString = (withCommas ? number?.formatted(.number) : number.map(String.init)) ?? "0"

        if carryingNegative {
            numberString.insert("-", at: numberString.startIndex)
        }

        if decimalSeparator {
            numberString.insert(".", at: numberString.endIndex)
        }
        return numberString
    }

    func operationIsHighlighted(_ operation: Operation) -> Bool {
        return expression?.operation == operation && newNumber == nil
    }

    mutating func performAction(for actionType: ActionType) {
        switch actionType {
        case .digit(let digit):
            self.setDigit(digit)
        case .operation(let operation):
            self.setOperation(operation)
        case .negative:
            self.toggleSign()
        case .percent:
            self.setPercent()
        case .decimal:
            self.setDecimal()
        case .equals:
            self.evaluate()
        case .allClear:
            self.allClear()
        case .clear:
            self.clear()
        }
    }
}
