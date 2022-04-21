//
//  FuncButton.swift
//  Calculator
//  
//  Created by CoderSamz on 2022.
// 	
// 
    

import UIKit

class FuncButton: UIButton {

    init() {
        super.init(frame: CGRect.zero)
        // 按钮边框
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor(r: 219, g: 219, b: 219, a: 1.0).cgColor
        // 字体与字体颜色
        self.setTitleColor(UIColor.orange, for: .normal)
        self.setTitleColor(UIColor.black, for: .highlighted)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
