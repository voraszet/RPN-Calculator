//
//  ViewController.swift
//  CalculatorRPN
//
//  Created by Adrijus Zelinskis on 21/02/2017.
//  Copyright © 2017 Adrijus Zelinskis. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let tapeController = TapeViewController()
    
    // LABELS
    @IBOutlet weak var displayLabel: UILabel!
    @IBOutlet weak var tapeLabel: UILabel!
    
    // SECOND VALUE BUTTONS
    @IBOutlet weak var sinButton: UIButton!
    @IBOutlet weak var cosButton: UIButton!
    @IBOutlet weak var tanButton: UIButton!
    @IBOutlet weak var logButton: UIButton!
    
    
    
    @IBOutlet weak var dotButton: UIButton!
    
    //  RADIAN / DEGREE BUTTON
    @IBOutlet weak var radianAndDegree: UIButton!
    
    // TOGGLE SIN,COS,TAN to ASIN, ACOS, ATAN
    var secondValues:Bool = false
    
    //  CHECK IF THE NUMBER IS RADIAN OR DEGREE
    var isRadian:Bool = false
    
    var startedTyping = false
    
    var calculatorEngine: CalculatorEngine?
    
    var secondTape = [String]()
    
    var newLine:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.calculatorEngine == nil {
            self.calculatorEngine = CalculatorEngine()
        }
        
        tapeLabel.text = "_"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func digitPressed(_ sender: UIButton) {
        
        let digit = sender.currentTitle!
        let displayLabelRef = displayLabel.text!
    
        let dotValueCount = displayLabelRef.components(separatedBy: ".")
        
        if dotValueCount.count-1 >= 1{
            dotButton.isEnabled = false
        } else {
            dotButton.isEnabled = true
        }
        
        if digit == "."{
            if(displayLabelRef.characters.count > 0){
                dotButton.isEnabled = false
            } else{
                dotButton.isEnabled = true
            }
        }
        
        if startedTyping {
            let zeroValueCount = displayLabelRef.components(separatedBy: "0")
            
            if(displayLabelRef.characters.count <= 1){
                if(zeroValueCount.count-1 >= 1){                    
                    if(digit == "."){
                        displayLabel.text = "0."
                    } else{
                        displayLabel.text = digit
                        tapeLabel.text = ""
                    }
                }else{
                    displayLabel.text = displayLabel.text! + "\(digit)"
                }
                
                if(digit == "π"){
                    displayLabel.text = digit
                    tapeLabel.text = digit
                }
                
                
            } else{
                displayLabel.text = displayLabel.text! + "\(digit)"
            }
            
            
        } else{
            print("else")
            if digit == "."{
                displayLabel.text = displayLabel.text! + "\(digit)"
                tapeLabel.text = tapeLabel.text! + "0"
                startedTyping = true
            } else{
                displayLabel.text = digit
                startedTyping = true
            }
        }
        
        
        if sender.currentTitle == "AC" {
            tapeLabel.text = tapeLabel.text! + "AsC"
            calculatorEngine?.fullTape.append("AsC")
        } else {
            tapeLabel.text = tapeLabel.text! + "\(digit)"
            calculatorEngine?.fullTape.append(digit)
        }
        
    }
    
    var displayValue:Double {
        get
        {   
            return Double(displayLabel.text!)!
        }
        set
        {   //newValue is automatic
            displayLabel.text = "\(newValue)"
        }
    }
    
    //  ENTER BUTTON
    @IBAction func enter() {
        startedTyping = false

            if displayLabel.text == "π"{
                calculatorEngine?.operandStack.append(3.14159265)
                
            } else if displayLabel.text == "-π"{
                calculatorEngine?.operandStack.append(-3.14159265)
            } else {
                self.calculatorEngine!.operandStack.append(displayValue)
            }
            
            print("Operand stack = \(self.calculatorEngine!.operandStack)")
            tapeLabel.text = tapeLabel.text! + "↵"
            calculatorEngine?.fullTape.append("↵")
        
    }
    
    
    @IBAction func operation(_ sender: UIButton) {
        
        let operation = sender.currentTitle!
        
        if startedTyping {
            //enter()
        }
        
        switch operation {
        
        case "+", "-", "÷", "x":
             self.validateOperation(oper: operation, limit: 2)
            
        case "sin", "cos", "tan", "asin", "acos", "atan":
             enter()
             
             self.validateOperation(oper: operation, limit: 1)
            
        case "1/x", "x²", "√", "log10", "log(e)":
        
            self.validateOperation(oper: operation, limit: 1)
        
        if(displayValue == 0.0) || (self.calculatorEngine!.operandStack.last == 0){
            showError()
        }       
                
        case "C":
            if ((calculatorEngine?.operandStack.count)! >= 1) {
                self.calculatorEngine?.operandStack.removeLast()
                tapeLabel.text = "-"   
            } else {
                tapeLabel.text = "_"
                displayLabel.text = "0"
            }
             
    
        default:
            break
        }
    
        
        //
        //MAIN FUNC
        //self.displayValue = self.calculatorEngine!.operate(operation: operation)
        
        if operation == "AC" {
            displayLabel.text = "0"
            tapeLabel.text = "AC  "
            dotButton.isEnabled = true
            calculatorEngine?.operandStack.removeAll()
            
            if (calculatorEngine?.fullTape.isEmpty == false){
                if (calculatorEngine?.fullTape.last != "AC"){
                    calculatorEngine?.fullTape.append("AC")
                } else {
                    calculatorEngine?.fullTape.append("AC")
                }
            }

            
            if displayLabel.text!.contains("π"){
                displayLabel.text = "0"
            }
            
        } else {
            calculatorEngine?.fullTape.append(String(self.displayValue))
        }
        
    }
    
    
    func showError()
    {
        let alertBox = UIAlertController(title: "Warning!", message: "Error", preferredStyle: UIAlertControllerStyle.alert)
        alertBox.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alertBox, animated: true, completion: nil)
        dotButton.isEnabled = true
        displayLabel.text = "0"
    }
    
    func validateOperation(oper: String, limit: Int){
        if (calculatorEngine?.operandStack.count)! >= limit {
            self.displayValue = self.calculatorEngine!.operate(operation: oper)
            tapeLabel.text = tapeLabel.text! + "\(oper)"
            calculatorEngine?.fullTape.append(oper)
            
            //enter()
        } else {
            let alertBox = UIAlertController(title: "Warning!", message: "Add numbers on stack before selecting an operator.", preferredStyle: UIAlertControllerStyle.alert)
            alertBox.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertBox, animated: true, completion: nil)
        }
    }
    
    @IBAction func secondFunction() {
        if (!secondValues){
            sinButton.setTitle("asin", for: .normal)
            cosButton.setTitle("acos", for: .normal)
            tanButton.setTitle("atan", for: .normal)
            logButton.setTitle("log10", for: .normal)
            secondValues = true
        }else {
            sinButton.setTitle("sin", for: .normal)
            cosButton.setTitle("cos", for: .normal)
            tanButton.setTitle("tan", for: .normal)
            logButton.setTitle("log(e)", for: .normal)
            secondValues = false
        }
    }
    
    @IBAction func degreesToRadians() {
        if(!isRadian){
            radianAndDegree.setTitle("RAD", for: .normal)
            isRadian = true
            calculatorEngine?.isRadian = true
        }else{
            radianAndDegree.setTitle("DEG", for: .normal)
            isRadian = false
            calculatorEngine?.isRadian = false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc:TapeViewController = segue.destination as! TapeViewController
        
        for test in (calculatorEngine?.fullTape)! {
            vc.fullTape.append(test)
            
            if test.contains("AC") || test.contains("+") || test.contains("-") || test.contains("÷") || test.contains("x") || test.contains("sin") || test.contains("sin") || test.contains("cos") || test.contains("tan") || test.contains("asin") || test.contains("acos") || test.contains("atan") || test.contains("π") || test.contains("x²") || test.contains("√") || test.contains("1/x") || test.contains("log") {
                vc.fullTape.insert("\n", at: 0)
            }
        }
    
        for t in (secondTape) {
            vc.fullTape.append(t)
        }
    }
    
    @IBAction func changeToNegative(_ sender: AnyObject) {
        if(displayLabel.text?.contains("-"))!{
            displayLabel.text?.remove(at: (displayLabel.text?.startIndex)!)
        } else {
            displayLabel.text = "-" + displayLabel.text!
        }
    }
    
    
    
    
    
}

