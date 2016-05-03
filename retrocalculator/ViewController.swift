//
//  ViewController.swift
//  retrocalculator
//
//  Created by Hans Hazairi on 15/04/2016.
//  Copyright © 2016 Hans Hazairi. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    enum Operation: String {
        case Add = "+"
        case Minus = "-"
        case Multiply = "*"
        case Divide = "/"
        case Equal = "="
        case Empty = ""
    }

    @IBOutlet weak var display: UILabel!
    
    var runningNumber = ""
    var leftNumber = "0"
    var rightNumber = ""
    var memoryNumber = ""
    var operation = Operation.Empty
    var memoryOperation = Operation.Empty
    var isNegative = false
    var isDecimal = false
    var btnSound: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = NSBundle.mainBundle().pathForResource("btn", ofType: "wav")
        let soundURL = NSURL(fileURLWithPath: path!)
        
        do {
            try btnSound = AVAudioPlayer(contentsOfURL: soundURL)
            btnSound.prepareToPlay()
            
        } catch let error as NSError {
            print(error.debugDescription)
        }
    }
    
    @IBAction func onNumberPressed(sender: UIButton) {
        playSound()
        
        if runningNumber == "0" {
            runningNumber = ""
            
        } else if runningNumber == "-0" {
            runningNumber = "-"
        }
        
        runningNumber += "\(sender.tag)"
        isLeftOrRight()
    }

    @IBAction func onAddPressed(sender: UIButton) {
        processOperation(Operation.Add)
    }
    
    @IBAction func onMinusPressed(sender: UIButton) {
        processOperation(Operation.Minus)
    }
    
    @IBAction func onMultiplyPressed(sender: UIButton) {
        processOperation(Operation.Multiply)
    }
    
    @IBAction func onDividePressed(sender: UIButton) {
        processOperation(Operation.Divide)
    }
    
    @IBAction func onEqualPressed(sender: UIButton) {
        processOperation(Operation.Equal)
    }
    
    @IBAction func onClearPressed(sender: UIButton) {
        playSound()
        clear()
    }
    
    @IBAction func onPercentPressed(sender: UIButton) {
        playSound()
        
        if runningNumber != "" {
            
            if operation == Operation.Add || operation == Operation.Minus {
                rightNumber = "\(Double(leftNumber)! * Double(rightNumber)! * 0.01)"
                
            } else if operation == Operation.Multiply || operation == Operation.Divide {
                rightNumber = "\(Double(rightNumber)! * 0.01)"
            }
            display.text = rightNumber
            
        } else {
            leftNumber = "\(Double(leftNumber)! * 0.01)"
            display.text = leftNumber
        }
    }
    
    @IBAction func onNegativePressed(sender: UIButton) {
        playSound()
        
        if runningNumber == "" {
            
            if operation == Operation.Equal {
                runningNumber = leftNumber
                
                if Double(runningNumber) < 0 {
                    isNegative = true
                    
                } else {
                    isNegative = false
                }
                
            } else {
                runningNumber = "0"
            }
        }
        
        if isNegative == false {
            runningNumber = "-" + runningNumber
            
        } else {
            runningNumber = String(runningNumber.characters.dropFirst())
            
        }
        
        isLeftOrRight()
        isNegative = !isNegative
    }
    
    
    @IBAction func onDecimalPressed(sender: UIButton) {
        playSound()
        
        if isDecimal == false {
            
            if runningNumber == "" {
                runningNumber = "0"
            }
            
            runningNumber += "."
            isLeftOrRight()
            isDecimal = true
        }
    }
    
    func playSound() {
        
        if btnSound.playing {
            btnSound.stop()
        }
        
        btnSound.play()
    }
    
    func clear() {
        runningNumber = ""
        leftNumber = "0"
        rightNumber = ""
        memoryNumber = ""
        operation = Operation.Empty
        memoryOperation = Operation.Empty
        isNegative = false
        isDecimal = false
        display.text = "0"
    }
    
    func isLeftOrRight() {
        
        if memoryOperation == Operation.Empty {
            leftNumber = runningNumber
            
        } else if memoryOperation != Operation.Empty {
            
            if operation == Operation.Equal {
                leftNumber = runningNumber
                
            } else {
                rightNumber = runningNumber
            }
        }
        
        display.text = runningNumber
        
    }
    
    func calculate() {
        if operation == Operation.Add {
            leftNumber = "\(Double(leftNumber)! + Double(rightNumber)!)"
            
        } else if operation == Operation.Minus {
            leftNumber = "\(Double(leftNumber)! - Double(rightNumber)!)"
            
        } else if operation == Operation.Multiply {
            leftNumber = "\(Double(leftNumber)! * Double(rightNumber)!)"
            
        } else if operation == Operation.Divide {
            leftNumber = "\(Double(leftNumber)! / Double(rightNumber)!)"
        }
   
        display.text = leftNumber
    }
    
    func processOperation(sender:Operation) {
        playSound()
        
        if rightNumber == "" {
            
            if sender == Operation.Equal {
                
                if memoryOperation != Operation.Empty {
                    rightNumber = memoryNumber
                    operation = memoryOperation
                    calculate()
                }
                
            } else {
                memoryNumber = leftNumber
                memoryOperation = sender
            }
            
        } else {
            calculate()
            
            if sender == Operation.Equal {
                memoryNumber = rightNumber
                memoryOperation = operation
            }
        }
        
        runningNumber = ""
        rightNumber = ""
        operation = sender
        isNegative = false
        isDecimal = false
    }
}

