//
//  ContentView.swift
//  Calculator
//
//  Created by Mihai Leonte on 13/02/2020.
//  Copyright © 2020 Mihai Leonte. All rights reserved.
//

import SwiftUI
import Combine

class UserCalculator: ObservableObject {
    @Published var display: String = "0"
    @Published var currentOperator: CalculatorButton?
    var previouslyPressed: CalculatorButton = .ac
    var leftMember: Double = 0
    var rightMember: Double = 0
    var isLeftMemberFilled: Bool = false
    var isDecimalNumber: Bool = false
    var decimalPlace: Double = 10
    
    func buttonPressed(button: CalculatorButton) {
        func compute(input: Double) -> Double {
            var output = 0.0
            if !isDecimalNumber {
                output = input * 10 + Double(button.title)!
            } else {
                output = input + Double(button.title)! / decimalPlace
                decimalPlace *= 10
            }
            
            return output
        }
        
        func disableDecimal() {
            isDecimalNumber = false
            decimalPlace = 10
        }
        
        previouslyPressed = button
        
        switch button {
        case .ac:
            display = "0"
            leftMember = 0.0
            rightMember = 0.0
            isLeftMemberFilled = false
            currentOperator = nil
            disableDecimal()
        case .zero, .one, .two, .three, .four, .five, .six, .seven, .eight, .nine:
            if !isLeftMemberFilled {
                leftMember = compute(input: leftMember)
                display = String(format: "%g", leftMember)
            } else {
                rightMember = compute(input: rightMember)
                display = String(format: "%g", rightMember)
            }
        case .decimal:
            isDecimalNumber = true
            display += "."
        case .percent:
            if isLeftMemberFilled {
                rightMember = rightMember / 100.0
                display = String(format: "%g", rightMember)
            } else {
                leftMember = leftMember / 100.0
                display = String(format: "%g", leftMember)
            }
        case .plusminus:
            if isLeftMemberFilled {
                rightMember = rightMember * -1
                display = String(format: "%g", rightMember)
            } else {
                leftMember = leftMember * -1
                display = String(format: "%g", leftMember)
            }
        case .plus, .minus, .multiply, .divide:
            currentOperator = button
            if isLeftMemberFilled {
                
            } else {
                
            }
            isLeftMemberFilled = true
            disableDecimal()
        case .equals:
            if isLeftMemberFilled {
                var result: Double = 0.0
                
                switch currentOperator {
                case .plus:
                    result = leftMember + rightMember
                case .multiply:
                    result = leftMember * rightMember
                case .divide:
                    result = leftMember / rightMember
                case .minus:
                    result = leftMember - rightMember
                default:
                    result = leftMember + rightMember
                }
                display = String(format: "%g", result)
                leftMember = result
                rightMember = 0.0
                disableDecimal()
            }
        default:
            display = "0"
        }
    }
}

struct ContentView: View {
    @ObservedObject var calculator = UserCalculator()
    let buttons: [[CalculatorButton]] = [
        [.ac, .plusminus, .percent, .divide],
        [.seven, .eight, .nine, .multiply],
        [.four, .five, .six, .minus],
        [.one, .two, .three, .plus],
        [.zero, .decimal, .equals]
    ]
    
    var body: some View {
        ZStack(alignment: Alignment.bottom) {
            Color.black
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 12) {
                HStack {
                    Spacer()
                    
                    Text(calculator.display)
                        .foregroundColor(Color.white)
                        .font(.system(size: 64))
                }.padding()
                
                ForEach(buttons, id: \.self) { row in
                    
                    HStack(spacing: 12) {
                        ForEach(row, id: \.self) { button in
                            Button(action: {
                                self.calculator.buttonPressed(button: button)
                            }) {
                                Text(button.title)
                                    .font(.system(size: 32))
                                    .foregroundColor(self.calculator.currentOperator == button ? button.backgroundColor : button.foregroundColor)
                                    .frame(width: self.buttonWidth(for: button), height: self.buttonHeight())
                                    .background(self.calculator.currentOperator == button ? Color.white : button.backgroundColor)
                                    .cornerRadius(self.buttonHeight())
                            }
                            
                        }
                    }
                    
                }
            }
        }
    }
    
    func buttonHeight() -> CGFloat {
        return (UIScreen.main.bounds.width - 5 * 12) / 4
    }
    
    func buttonWidth(for button: CalculatorButton) -> CGFloat {
        if button == .zero {
            return (UIScreen.main.bounds.width - 4*12) / 2
        }
        return buttonHeight()
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
