//
//  ViewController.swift
//  Calculator
//  
//  Created by CoderSamz on 2022.
// 	
// 
    

import UIKit
import SnapKit

class ViewController: UIViewController, BoardButtonInputDelegate {
    
    let board = Board()
    let screen = Screen()
    
    let calculator = CalculatorEngine()
    var isNew = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        installUI()
    }

    func installUI() {
        self.view.addSubview(board)
        board.delegate = self
        board.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(self.view).multipliedBy(2/3.0)
        }
        
        self.view.addSubview(screen)
        screen.snp.makeConstraints { make in
            make.left.right.top.equalTo(0)
            make.bottom.equalTo(board.snp.top)
        }
    }
    
    func boardButtonClick(content: String) {
        if content == "AC" || content == "Delete" || content == "=" {
            
            switch content {
            case "AC":
                screen.clearContent()
                screen.refreshHistory()
            case "Delete":
                screen.deleteInput()
            case "=":
                let result = calculator.calculateEquation(equation: screen.inputString)
                screen.refreshHistory()
                screen.clearContent()
                screen.inputContent(content: String(result))
                isNew = true
            default:
                screen.refreshHistory()
            }
            
        } else {
            if isNew {
                screen.clearContent()
                isNew = false
            }
            screen.inputContent(content: content)
        }
    }

}

