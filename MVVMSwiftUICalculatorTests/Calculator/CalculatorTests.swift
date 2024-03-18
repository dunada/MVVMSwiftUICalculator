//
//  CalculatorTests.swift
//  MVVMSwiftUICalculatorTests
//
//  Created by Eduardo Rodrigues on 16/03/24.
//

import XCTest
@testable import MVVMSwiftUICalculator

final class CalculatorTests: XCTestCase {

    private var calculator: Calculator!

    override func setUpWithError() throws {
        calculator = Calculator()
    }

    func testAddition() throws {
        calculator.performAction(for: .digit(.five))
        calculator.performAction(for: .operation(.addition))
        calculator.performAction(for: .digit(.two))
        calculator.performAction(for: .equals)
        XCTAssertEqual(calculator.displayText, "7")
    }

    func testSubtraction() throws {
        calculator.performAction(for: .digit(.five))
        calculator.performAction(for: .operation(.subtraction))
        calculator.performAction(for: .digit(.two))
        calculator.performAction(for: .equals)
        XCTAssertEqual(calculator.displayText, "3")
    }

    func testMultiplication() throws {
        calculator.performAction(for: .digit(.five))
        calculator.performAction(for: .operation(.multiplication))
        calculator.performAction(for: .digit(.two))
        calculator.performAction(for: .equals)
        XCTAssertEqual(calculator.displayText, "10")
    }

    func testDivision() throws {
        calculator.performAction(for: .digit(.six))
        calculator.performAction(for: .operation(.division))
        calculator.performAction(for: .digit(.two))
        calculator.performAction(for: .equals)
        XCTAssertEqual(calculator.displayText, "3")
    }
    
    func testDecimal() throws {
        calculator.performAction(for: .digit(.six))
        calculator.performAction(for: .decimal)
        XCTAssertEqual(calculator.displayText, "6.")
    }


    func testClear() throws {
        calculator.performAction(for: .digit(.six))
        calculator.performAction(for: .operation(.addition))
        calculator.performAction(for: .digit(.six))
        calculator.performAction(for: .clear)
        XCTAssertEqual(calculator.displayText, "0")
        calculator.performAction(for: .digit(.four))
        calculator.performAction(for: .equals)
        XCTAssertEqual(calculator.displayText, "10")
    }

    func testAllClear() throws {
        calculator.performAction(for: .digit(.six))
        calculator.performAction(for: .operation(.addition))
        calculator.performAction(for: .digit(.six))
        calculator.performAction(for: .clear)
        calculator.performAction(for: .allClear)
        XCTAssertEqual(calculator.displayText, "0")
        calculator.performAction(for: .digit(.one))
        calculator.performAction(for: .equals)
        XCTAssertEqual(calculator.displayText, "1")
    }

    func testNegative() throws {
        calculator.performAction(for: .digit(.six))
        calculator.performAction(for: .negative)
        XCTAssertEqual(calculator.displayText, "-6")
        calculator.performAction(for: .negative)
        XCTAssertEqual(calculator.displayText, "6")
        calculator.performAction(for: .operation(.addition))
        calculator.performAction(for: .digit(.one))
        calculator.performAction(for: .equals)
        calculator.performAction(for: .negative)
        XCTAssertEqual(calculator.displayText, "-7")
    }

    func testPercentage() throws {
        calculator.performAction(for: .digit(.six))
        calculator.performAction(for: .percent)
        calculator.performAction(for: .operation(.multiplication))
        calculator.performAction(for: .digit(.one))
        calculator.performAction(for: .digit(.zero))
        calculator.performAction(for: .digit(.zero))
        calculator.performAction(for: .equals)
        XCTAssertEqual(calculator.displayText, "6")
    }

    func testPercentageTotal() throws {
        calculator.performAction(for: .digit(.six))
        calculator.performAction(for: .operation(.addition))
        calculator.performAction(for: .digit(.six))
        calculator.performAction(for: .equals)
        calculator.performAction(for: .percent)
        calculator.performAction(for: .operation(.multiplication))
        calculator.performAction(for: .digit(.one))
        calculator.performAction(for: .digit(.zero))
        calculator.performAction(for: .digit(.zero))
        calculator.performAction(for: .equals)
        XCTAssertEqual(calculator.displayText, "12")
    }

    func testOperationIsHighlighted() throws {
        calculator.performAction(for: .digit(.six))
        calculator.performAction(for: .operation(.multiplication))
        XCTAssertTrue(calculator.operationIsHighlighted(.multiplication))
    }

    func testHistory() throws {
        try testAddition()
        calculator.performAction(for: .digit(.one))
        calculator.performAction(for: .operation(.addition))
        calculator.performAction(for: .digit(.one))
        calculator.performAction(for: .equals)
        try testMultiplication()
        try testSubtraction()
        try testAddition()
        try testSubtraction()
        XCTAssertEqual(calculator.history.count, 5)
        XCTAssertEqual(calculator.history.first, "1 + 1 = 2")
    }

    func testEvaluateWithoutEquals() throws {
        calculator.performAction(for: .digit(.six))
        calculator.performAction(for: .operation(.multiplication))
        calculator.performAction(for: .digit(.six))
        calculator.performAction(for: .operation(.multiplication))
        XCTAssertEqual(calculator.displayText, "36")
    }

    func testSetOperationIsNotHighlighted() throws {
        calculator.performAction(for: .operation(.multiplication))
        XCTAssertFalse(calculator.operationIsHighlighted(.multiplication))
        XCTAssertEqual(calculator.displayText, "0")
    }

}
