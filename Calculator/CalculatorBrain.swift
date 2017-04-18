//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Ruziev on 3/30/17.
//  Copyright © 2017 Ruziev. All rights reserved.
//

import Foundation

struct CalculatorBrain {
    
    private var accumulator: Double?
    
    private enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation( (Double, Double) -> Double )
        case equal
    }
    
    private var operations: Dictionary<String, Operation> = [
        "π": Operation.constant(Double.pi),
        "e": Operation.constant(M_E),
        "√": Operation.unaryOperation(sqrt),
        "cos": Operation.unaryOperation(cos),
        "±": Operation.unaryOperation({ -$0 }),
        "+": Operation.binaryOperation({ $0 + $1 }),
        "-": Operation.binaryOperation({ $0 - $1 }),
        "×": Operation.binaryOperation({ $0 * $1 }),
        "÷": Operation.binaryOperation({ $0 / $1 }),
        "=": Operation.equal
    ]
    
    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value):
                accumulator = value
            case .unaryOperation(let function):
                if accumulator != nil {
                    accumulator = function(accumulator!)
                }
            case .binaryOperation(let function):
                if accumulator != nil {
                    let currentAccumulator = accumulator!
                    pendingBinaryFunction = { function(currentAccumulator, $0) }
                    accumulator = nil
                }
            case .equal:
                if accumulator != nil && pendingBinaryFunction != nil {
                    accumulator = pendingBinaryFunction!(accumulator!)
                    pendingBinaryFunction = nil
                }
            }
        }
    }
    
    var pendingBinaryFunction: ((Double) -> Double)?
    
    mutating func setOperand(_ operand: Double) {
        accumulator = operand
    }
    
    var result: Double? {
        get {
            return accumulator
        }
    }
}
