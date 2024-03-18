//
//  CalculatorView.swift
//  MVVMSwiftUICalculator
//
//  Created by Eduardo Rodrigues on 08/03/24.
//
import Foundation
import SwiftUI

struct CalculatorView: View {

    struct Constants {
        static let padding: CGFloat = 12.0
    }

    @EnvironmentObject private var viewModel: CalculatorViewModel

    var body: some View {
        GeometryReader { proxy in
            if proxy.size.height < proxy.size.width {
                HStack {
                    buttonArea
                        .frame(width: proxy.size.width / 2, height: proxy.size.height)
                    Spacer()
                    VStack {
                        display
                        historyArea
                        Spacer()
                    }
                }
                .padding(CalculatorView.Constants.padding)
                .background(.black)
            } else {
                VStack {
                    historyArea
                    Spacer()
                    display
                    buttonArea
                        .frame(width: proxy.size.width, height: proxy.size.height * 0.6)
                }
                .padding(CalculatorView.Constants.padding)
                .background(.black)
            }
        }
    }

    private var display: some View {
        Text(viewModel.displayText)
            .padding()
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, alignment: .trailing)
            .font(.system(size: 88, weight:.light))
            .lineLimit(1)
            .minimumScaleFactor(0.2)
    }

    private var buttonArea: some View {
        GeometryReader { proxy in
            VStack(spacing: CalculatorView.Constants.padding) {
                ForEach(viewModel.actionTypes, id: \.self) { row in
                    HStack(spacing: CalculatorView.Constants.padding) {
                        ForEach (row, id: \.self) { actionType in
                            CalculatorButton(actionType: actionType, proxy: proxy)
                        }
                    }
                }
            }
        }
    }

    private var historyArea: some View {
        VStack(spacing: CalculatorView.Constants.padding) {
            Text(viewModel.historyText)
                .padding()
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.system(size: 15, weight:.light))
        }
    }
}

extension CalculatorView {
    struct CalculatorButton: View {

        let actionType: ActionType
        let proxy: GeometryProxy
        @EnvironmentObject private var viewModel: CalculatorViewModel

        var body: some View {

            Button(actionType.description) {
                viewModel.performAction(for: actionType)
            }
            .buttonStyle(
                RoundedButtonStyle(
                    size: getButtonSize(),
                    backgroundColor: viewModel.isHighlighted(actionType: actionType) ? actionType.foregroundColor : actionType.backgroundColor,
                    foregroundColor: viewModel.isHighlighted(actionType: actionType) ? actionType.backgroundColor : actionType.foregroundColor,
                    isBig: actionType == .digit(.zero))
            )
        }

        private func getButtonSize() -> CGFloat {
            let buttonCount: CGFloat = 4.0
            let spacingCount = buttonCount + 1
            return (proxy.size.width - (spacingCount * CalculatorView.Constants.padding)) / buttonCount

        }
    }
}

#Preview {
    CalculatorView().environmentObject(CalculatorViewModel())
}

