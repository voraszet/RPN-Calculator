//
//  CalculatorEngine.swift
//  CalculatorRPN
//
//  Created by Adrijus Zelinskis on 21/02/2017.
//  Copyright © 2017 Adrijus Zelinskis. All rights reserved.
//

import Foundation
import UIKit

class CalculatorEngine: NSObject
{
    
    var operandStack = Array<Double>()
    var globalNumber:Double = 0
    var isRadian:Bool = false
    
    var fullTape = [String]()
    
    func updateStackWithValue(value: Double){
        self.operandStack.append(value)
    }
    
    
    func operate(operation:String) -> Double{
        
        switch operation 
        {
        case "+":
            if operandStack.count >= 2
            {   
                globalNumber = self.operandStack.removeLast() + self.operandStack.removeLast() 
                return globalNumber
            }
            
        case "-":
            if operandStack.count >= 2
            {
                globalNumber = self.operandStack.removeLast() - self.operandStack.removeLast()
                return globalNumber
            }
            
        case "x":
            if operandStack.count >= 2
            {
                globalNumber = self.operandStack.removeLast() * self.operandStack.removeLast()
                return globalNumber
            }
            
        case "÷":
            if operandStack.count >= 2
            {
                globalNumber = self.operandStack.removeFirst() / self.operandStack.removeLast() 
                return globalNumber
            }
        case "AC":
            
            globalNumber = 0
            if operandStack.count >= 1{
                self.operandStack.removeAll()
            }
            return 0
            
        case "sin":
            if(!isRadian){
                if operandStack.count >= 1 {
                    var tmp:Double = self.operandStack.last!
                    tmp = sin((tmp * 3.14159265) / 180)
                    self.operandStack.removeLast()
                    self.operandStack.append(tmp)
                    return tmp
                } 
            }else{
                if operandStack.count >= 1 {
                    let tmp:Double = sin(self.operandStack.last!)
                    self.operandStack.removeLast()
                    self.operandStack.append(tmp)
                    return tmp
                }   
            }
        // IF degrees is ticked then you must first convert into radians and then do the operation
            
        case "cos":
            if(!isRadian){
                if operandStack.count >= 1 {
                    var tmp:Double = self.operandStack.last!
                    tmp = cos(tmp * (3.14159265 / 180))
                    self.operandStack.removeLast()
                    self.operandStack.append(tmp)
                    return tmp
                } 
            } else{
                if(operandStack.count >= 1){
                    let tmp:Double = cos(self.operandStack.last!)
                    self.operandStack.removeLast()
                    self.operandStack.append(tmp)
                    return tmp
                }
            }
        //globalNumber = cos(globalNumber)
        //return globalNumber
            
        case "tan":
            if(!isRadian){
                if operandStack.count >= 1 {
                    var tmp:Double = self.operandStack.last!
                    tmp = tan(tmp * (3.14159265 / 180))
                    self.operandStack.removeLast()
                    self.operandStack.append(tmp)
                    return tmp
                }
            } else {
                if operandStack.count >= 1 {
                    let tmp:Double = tan(self.operandStack.last!)
                    self.operandStack.removeLast()
                    self.operandStack.append(tmp)
                    return tmp
                }
            }
        // OK    
        case "asin":
            if(isRadian){
                if operandStack.count >= 1{
                    var tmp:Double = operandStack.last!
                    tmp = asin(tmp)
                    self.operandStack.removeLast()
                    self.operandStack.append(tmp)
                    return tmp 
                }
            } else {
                if operandStack.count >= 1{
                    var tmp:Double = operandStack.last!
                    tmp = (((asin(tmp) * 180) / M_PI))
                    self.operandStack.removeLast()
                    self.operandStack.append(tmp)
                    return tmp
                }
            }
            
        // ACOS -1 and 1
        case "acos":
            if(isRadian){
                if operandStack.count >= 1{
                    var tmp:Double = operandStack.last!
                    tmp = acos(tmp)
                    self.operandStack.removeLast()
                    self.operandStack.append(tmp)
                    return tmp  
                } 
            } else {
                if operandStack.count >= 1{
                    var tmp:Double = operandStack.last!
                    tmp = (((acos(tmp) * 180) / M_PI))
                    self.operandStack.removeLast()
                    self.operandStack.append(tmp)
                    return tmp
                }
            }
            
        case "atan":
            if(isRadian){
                if operandStack.count >= 1 {
                    var tmp:Double = operandStack.last!
                    tmp = atan(tmp)
                    self.operandStack.removeLast()
                    self.operandStack.append(tmp)
                    return tmp
                }
            } else {
                if operandStack.count >= 1 {
                    var x = operandStack.last!
                   // if ((operandStack.last! >= 12) && (operandStack.last! <= -12){
                    if (x > 0){
                        var tmp:Double
                        tmp = operandStack.last!
                        tmp = (((atan(tmp) * 180) / M_PI))
                        self.operandStack.removeLast()
                        self.operandStack.append(tmp)
                        print("x is bigger than 0")
                        return tmp
                    } else {
                        print("x is smaller than 0")
                    }
                }
            }
            
            
        case "x²":
            if operandStack.count >= 1{ 
                let tmp:Double = self.operandStack.last! * self.operandStack.last!
                self.operandStack.removeLast()
                self.operandStack.append(tmp)
                return tmp
            }else {
                globalNumber = globalNumber * globalNumber
                return globalNumber
            }
            
        case "1/x":
            if operandStack.count >= 1 {
                if (!(self.operandStack.last! == 0 || self.operandStack.last! == 0)) {
                    let tmp:Double = 1.0 / self.operandStack.last!
                    self.operandStack.removeLast()
                    self.operandStack.append(tmp)
                    return tmp
                }
            }
            
        case "log10":
            if operandStack.count >= 1 {
                let tmp:Double = log10(self.operandStack.last!)
                self.operandStack.removeLast()
                self.operandStack.append(tmp)
                return tmp
            } 
        
        case "log(e)":
            if operandStack.count >= 1 {
                return log(self.operandStack.removeLast())
            }
            
        case "√":
            if operandStack.count >= 1{
                let tmp:Double = sqrt(self.operandStack.last!)
                self.operandStack.removeLast()
                operandStack.append(tmp)
                return tmp
            }
            
        case "C":
            if operandStack.count >= 1 {
                self.operandStack.removeLast()
                print("yes I removed")
            } 
        
        case ".":
            print("dot worked")
            
        default:break
        }
        
        return 0
    }
    
    
}
