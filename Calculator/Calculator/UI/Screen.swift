//
//  Screen.swift
//  Calculator
//  
//  Created by CoderSamz on 2022.
// 	
// 
    

import UIKit

class Screen: UIView {

    var inputLabel: UILabel?
    var historyLabel: UILabel?
    var inputString = ""
    var historyString = ""
    
    let figureArray: Array<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "."]
    let funcArray = ["+", "-", "*", "/", "^", "%"]
    
    init() {
        inputLabel = UILabel()
        historyLabel = UILabel()
        super.init(frame: .zero)
        installUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func installUI() {
        inputLabel?.textAlignment = .right
        historyLabel?.textAlignment = .right
        
        inputLabel?.font = UIFont.systemFont(ofSize: 34)
        historyLabel?.font = UIFont.systemFont(ofSize: 30)
        
        inputLabel?.textColor = .orange
        historyLabel?.textColor = .black
        
        inputLabel?.adjustsFontSizeToFitWidth = true
        inputLabel?.minimumScaleFactor = 0.5
        historyLabel?.adjustsFontSizeToFitWidth = true
        historyLabel?.minimumScaleFactor = 0.5
        
        // 设置文字的截断方式
        inputLabel?.lineBreakMode = .byTruncatingHead
        historyLabel?.lineBreakMode = .byTruncatingHead
        
        inputLabel?.numberOfLines = 0
        historyLabel?.numberOfLines = 0
        
        self.addSubview(inputLabel!)
        self.addSubview(historyLabel!)
        
        // 自动布局
        inputLabel?.snp.makeConstraints({ make in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.bottom.equalTo(-10)
            make.height.equalTo(inputLabel!.superview!.snp.height).multipliedBy(0.5).offset(-10)
        })
        
        historyLabel?.snp.makeConstraints({ make in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.equalTo(10)
            make.height.equalTo(inputLabel!.superview!.snp.height).multipliedBy(0.5).offset(-10)
        })
    }
    
    // 信息输入接口
    func inputContent(content: String) {
//        if !figureArray.contains(content.last!) && !funcArray.contains(content) {
//            return
//        }
        guard figureArray.contains(content.last!) || funcArray.contains(content) else {
            return
        }
        
        guard inputString.count > 0 else {
            // 只有数字可以作为首个字符
            if figureArray.contains(content.last!) {
                inputString.append(content)
                inputLabel?.text = inputString
            }
            return
        }
        
        if figureArray.contains(inputString.last!) {
            inputString.append(content)
            inputLabel?.text = inputString
        } else {
            if figureArray.contains(content.last!) {
                inputString.append(content)
                inputLabel?.text = inputString
            }
        }
    }

    
    
    func refreshHistory() {
        historyString = inputString
        historyLabel?.text = historyString
    }
    
    /// 清空屏幕
    func clearContent() {
        inputString = ""
    }
    
    /// 删除上一个输入字符
    func deleteInput() {
        if inputString.count > 0 {
            inputString.remove(at: inputString.index(before: inputString.endIndex))
            inputLabel?.text = inputString
        }
    }
}
