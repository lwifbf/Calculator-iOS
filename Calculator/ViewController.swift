//
//  ViewController.swift
//  Calculator
//
//  Created by apple on 2015/5/31.
//  Copyright (c) 2015年 National Taiwan University. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var inputHistory: UILabel!
    
    var userHaveInsertedNumber: Bool = false
    var haveInsertPoint: Bool = false
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        
        inputHistory.text = inputHistory.text! + digit
        
        if digit == "." {
            if !haveInsertPoint{
                if userHaveInsertedNumber{
                    display.text = display.text! + digit
                }
                else{
                    display.text = "0."
                    userHaveInsertedNumber = true
                }
                
                haveInsertPoint = true
            }
        }
            
        else{
            if userHaveInsertedNumber{
                display.text = display.text! + digit
            }
            else{
                display.text = digit
                userHaveInsertedNumber = true
            }
        }

//        println("digit = \(digit)")
    }
    
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        
        if userHaveInsertedNumber{
            enter()
        }
        inputHistory.text = inputHistory.text! + operation
        
        switch operation{
            
            //--Closure advanced use
            //func multiply(op1:D, op2:D) -> D {return op1*op2}
            //  performOp(multiply)
            //performOp( { (op1:D, op2:D) -> D in return op1*op2} )
            //performOp( { (op1, op2)  in return op1*op2} )
            //performOp( { (op1, op2)  in op1*op2} )
            //performOp( { $0*$1 } )
            
            case "✕":   performOperationBinary{ $1 * $0 }
            case "÷":   performOperationBinary{ $1 / $0 }
            case "+":   performOperationBinary{ $1 + $0 }
            case "−":   performOperationBinary{ $1 - $0 }
            case "√":   performOperationUnary{ sqrt($0) }
            case "sin":     performOperationUnary{ sin($0) }
            case "cos":     performOperationUnary{ cos($0) }
            case "π":   let pi = M_PI
                        displayValue = pi
                        enter()
            case "C":   inputHistory.text = ""
                        display.text = "0"
                        operandStack.removeAll()
            default :   break
        }
    }
    
    func performOperationBinary(operation: (Double,Double) -> Double){
        if operandStack.count>=2{
            displayValue = operation(operandStack.removeLast(),operandStack.removeLast())
            enter()
        }
    }
    
    func performOperationUnary(operation: Double -> Double){
        if operandStack.count>=1{
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }
    
    
    var operandStack = Array<Double>()
    
    
    @IBAction func enter() {
        userHaveInsertedNumber = false
        haveInsertPoint = false
        
        brain.pushOperand(displayValue)
        operandStack.append(displayValue)
        println("operandStack = \(operandStack)")
        
        inputHistory.text = inputHistory.text! + " "
    }
    
    var displayValue: Double {
        get{
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set{
            display.text = "\(newValue)"
//            userHaveInsertedNumber = false
//            haveInsertPoint = false
        }
    }
}

