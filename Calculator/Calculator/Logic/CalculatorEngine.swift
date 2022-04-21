//
//  CalculatorEngine.swift
//  Calculator
//  
//  Created by CoderSamz on 2022.
// 	
// 
    

import UIKit

class CalculatorEngine: NSObject {
    // 运算符集合
    let funcArray: CharacterSet = ["+", "-", "*", "/", "^", "%"]
    func calculateEquation(equation: String) -> Double {
        // 以运算符进行分隔获取到所有数字
        let elementArray = equation.components(separatedBy: funcArray)
        // 设置一个运算标记游标
        var tip = 0
        // 运算结果
        var result: Double = Double(elementArray[0])!
        
        // 遍历计算表达式
        for char in equation {
            switch char {
            case "+":
                tip += 1
                if elementArray.count > tip {
                    result += Double(elementArray[tip])!
                }
            case "-":
                tip += 1
                if elementArray.count > tip {
                    result -= Double(elementArray[tip])!
                }
            case "*":
                tip += 1
                if elementArray.count > tip {
                    result *= Double(elementArray[tip])!
                }
            case "/":
                tip += 1
                if elementArray.count > tip {
                    result /= Double(elementArray[tip])!
                }
            case "%":
                tip += 1
                if elementArray.count > tip {
                    result = Double(Int(result) % Int(elementArray[tip])!)
                }
            case "^":
                tip += 1
                if elementArray.count > tip {
                    let tmp = result
                    for _ in 1..<Int(elementArray[tip])! {
                        result *= tmp
                    }
                }
            default:
                break
            }
        }
        
        return result
    }
}
