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
    var previouslyPressed: CalculatorButton = .ac
    var leftMember: Double = 0
    var rightMember: Double = 0
    var isLeftMemberFilled: Bool = false
    var currentOperator: CalculatorButton = .plus
    
    func buttonPressed(button: CalculatorButton) {
        previouslyPressed = button
        
        switch button {
        case .ac:
            display = "0"
            leftMember = 0.0
            rightMember = 0.0
            isLeftMemberFilled = false
        case .zero, .one, .two, .three, .four, .five, .six, .seven, .eight, .nine:
            if !isLeftMemberFilled {
                leftMember = leftMember * 10 + Double(button.title)!
                display = String(format: "%g", leftMember)
            } else {
                rightMember = rightMember * 10 + Double(button.title)!
                display = String(format: "%g", rightMember)
            }
        case .plus, .minus, .multiply, .divide:
            isLeftMemberFilled = true
            currentOperator = button
        case .equals:
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
                                    .font(.system(size: 40))
                                    .foregroundColor(Color.white)
                                    .frame(width: self.buttonWidth(for: button), height: self.buttonHeight())
                                    .background(button.backgroundColor)
                                    .cornerRadius(self.buttonHeight())
                            }
                            
                        }
                    }
                    
                }
            }
        }
    }
    
    func buttonHeight() -> CGFloat {
        return (UIScreen.main.bounds.width - 5*12) / 4
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
