//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by apple on 2015/7/23.
//  Copyright (c) 2015年 National Taiwan University. All rights reserved.
//

import Foundation

class CalculatorBrain{
    
    private enum Op{
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double,Double) -> Double)
    }
    
    //Array<Op>() = [Op]()
    private var opStack = [Op]()
    
    //Dictionary<String, Op>() = [Sreing:Op]()
    private var knowOps = [String:Op]()
    
    init(){
        
        //Op.BinaryOperation("×", { $0*$1 })
        //Op.BinaryOperation("×") { $0*$1 }
        //Op.BinaryOperation("×", * )
        
        knowOps["×"] = Op.BinaryOperation("×", *)
        knowOps["÷"] = Op.BinaryOperation("÷") { $1 / $0 }
        knowOps["+"] = Op.BinaryOperation("+", +)
        knowOps["−"] = Op.BinaryOperation("−") { $1 - $0 }
        
        knowOps["√"] = Op.UnaryOperation("√", sqrt)
        knowOps["sin"] = Op.UnaryOperation("sin", sin)
        knowOps["cos"] = Op.UnaryOperation("cos", cos)
        
//        knowOps[""]
    }
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]){
        
        if !ops.isEmpty{
            var remainingOps = ops
            let op = remainingOps.removeLast()
            
            
            switch op{
            case .Operand(let operand):
                return (operand, remainingOps)
                
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result{
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let op1 = op1Evaluation.result{
                    
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let op2 = op2Evaluation.result{
                        return (operation(op1,op2), op2Evaluation.remainingOps)
                    }
                }
            }
        }
        
        return(nil, ops)
    }
    
    func evaluate() -> Double?{
        //remainder or _
        let (result, remainingOps) = evaluate(opStack)
        return result
    }
    
    func pushOperand(operand: Double) -> Double?{
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double?{
        if let operation = knowOps[symbol]{
            opStack.append(operation)
        }
        return evaluate()
    }
    
    func clearAll(){
        opStack.removeAll()
    }
    
}