//
//  CalculatorViewModel.swift
//  MVVMSwiftUICalculatorTests
//
//  Created by Eduardo Rodrigues on 16/03/24.
//

import XCTest
@testable import MVVMSwiftUICalculator

final class CalculatorViewModelTests: XCTestCase {

    private var calculatorViewModel: CalculatorViewModel!


    override func setUpWithError() throws {
        calculatorViewModel = CalculatorViewModel()
    }


    func testPerformAction() throws {
        calculatorViewModel.performAction(for: .digit(.one))
        calculatorViewModel.performAction(for: .operation(.addition))
        calculatorViewModel.performAction(for: .digit(.one))
        calculatorViewModel.performAction(for: .equals)
        XCTAssertEqual(calculatorViewModel.displayText, "2")
    }

    func testIsHighlighted() throws {
        calculatorViewModel.performAction(for: .digit(.one))
        calculatorViewModel.performAction(for: .operation(.addition))
        XCTAssertTrue(calculatorViewModel.isHighlighted(actionType: .operation(.addition)))
    }

    func testHistoryText() throws {
        calculatorViewModel.performAction(for: .digit(.one))
        calculatorViewModel.performAction(for: .operation(.addition))
        calculatorViewModel.performAction(for: .digit(.one))
        calculatorViewModel.performAction(for: .equals)
        calculatorViewModel.performAction(for: .digit(.two))
        calculatorViewModel.performAction(for: .operation(.addition))
        calculatorViewModel.performAction(for: .digit(.two))
        calculatorViewModel.performAction(for: .equals)
        XCTAssertEqual(calculatorViewModel.historyText, "1 + 1 = 2\n2 + 2 = 4")
    }

    func testActionTypeClear() throws {
        XCTAssertEqual(calculatorViewModel.actionTypes.first?.first, .allClear)
        calculatorViewModel.performAction(for: .digit(.one))
        XCTAssertEqual(calculatorViewModel.actionTypes.first?.first, .clear)
    }




}
