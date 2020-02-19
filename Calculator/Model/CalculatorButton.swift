//
//  CalculatorButton.swift
//  Calculator
//
//  Created by Mihai Leonte on 14/02/2020.
//  Copyright © 2020 Mihai Leonte. All rights reserved.
//

import Foundation
import SwiftUI

enum CalculatorButton {
    case zero, one, two, three, four, five, six, seven, eight, nine
    case multiply, minus, plus, plusminus, equals, decimal, ac
    case percent, divide
    
    var title: String {
        switch self {
            case .zero: return "0"
            case .one: return "1"
            case .two: return "2"
            case .three: return "3"
            case .four: return "4"
            case .five: return "5"
            case .six: return "6"
            case .seven: return "7"
            case .eight: return "8"
            case .nine: return "9"
            case .multiply: return "×"
            case .minus: return "-"
            case .plus: return "+"
            case .plusminus: return "±"
            case .equals: return "="
            case .decimal: return "."
            case .ac: return "AC"
            case .percent: return "%"
            case .divide: return "÷"
        }
    }
    
    var backgroundColor: Color {
        switch self {
            case .ac, .plusminus, .percent: return Color(.lightGray)
            case .divide, .multiply, .minus, .plus, .equals: return Color.orange
            default: return Color(.darkGray)
        }
    }
}
