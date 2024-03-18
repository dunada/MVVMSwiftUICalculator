//
//  MVVMSwiftUICalculatorApp.swift
//  MVVMSwiftUICalculator
//
//  Created by Eduardo Rodrigues on 08/03/24.
//

import SwiftUI

@main
struct MVVMSwiftUICalculatorApp: App {
    var body: some Scene {
        WindowGroup {
            CalculatorView().environmentObject(CalculatorViewModel())
        }
    }
}
