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
    
    var brain = CalculatorBrain()
    
    
    
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
    
    @IBAction func appendConstant(sender: UIButton) {
        
        if userHaveInsertedNumber{
            enter()
        }
        
        let const = sender.currentTitle!
        
        inputHistory.text = inputHistory.text! + const
        
        if let result = brain.pushConstant(const){
            displayValue = result
        }
        else{
            displayValue = 0
        }
        
    }

    
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        
        if userHaveInsertedNumber{
            enter()
        }
        inputHistory.text = inputHistory.text! + operation
        
        if let result = brain.performOperation(operation){
            displayValue = result
        }
        else{
            displayValue = 0
        }
        
    }
    
    
    
    @IBAction func clearCalculator(sender: UIButton) {
        inputHistory.text = ""
        displayValue = 0
        brain.clearAll()
    }
    
    @IBAction func enter() {
        
        if userHaveInsertedNumber{
            
            userHaveInsertedNumber = false
            haveInsertPoint = false
            
            if let result = brain.pushOperand(displayValue) {
                displayValue = result
            }
            else{
                displayValue = 0
            }
            
            inputHistory.text = inputHistory.text! + " "
        }
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

