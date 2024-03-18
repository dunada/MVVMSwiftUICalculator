//
//  CalculatorViewTests.swift
//  MVVMSwiftUICalculatorTests
//
//  Created by Eduardo Rodrigues on 18/03/24.
//

import XCTest
import SnapshotTesting
@testable import MVVMSwiftUICalculator


final class CalculatorViewTests: XCTestCase {

    func testCalculatorView() throws {
        let vc = CalculatorView().environmentObject(CalculatorViewModel())
        assertSnapshot(of: vc, as: .image)
    }

}
