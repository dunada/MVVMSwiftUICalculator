//
//  CalculatorViewModel.swift
//  MVVMSwiftUICalculator
//
//  Created by Eduardo Rodrigues on 08/03/24.
//

import Foundation
import Combine

final class CalculatorViewModel: ObservableObject {

    @Published private var calculator = Calculator()

    var displayText: String {
        return calculator.displayText
    }

    var historyText: String {
        return calculator.history.joined(separator: "\n")
    }

    var actionTypes: [[ActionType]] {
        let clearType: ActionType = calculator.showAllClear ? .allClear : .clear
        return [
            [clearType, .negative, .percent, .operation(.division)],
            [.digit(.seven), .digit(.eight), .digit(.nine), .operation(.multiplication)],
            [.digit(.four), .digit(.five), .digit(.six), .operation(.subtraction)],
            [.digit(.one), .digit(.two), .digit(.three), .operation(.addition)],
            [.digit(.zero), .decimal, .equals]
        ]
    }

    func performAction(for actionType: ActionType) {
        calculator.performAction(for: actionType)
    }

    func isHighlighted(actionType: ActionType) -> Bool {
        guard case .operation(let operation) = actionType else { return false}
        return calculator.operationIsHighlighted(operation)
    }
}

