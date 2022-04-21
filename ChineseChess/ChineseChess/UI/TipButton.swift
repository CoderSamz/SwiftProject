//
//  TipButton.swift
//  ChineseChess
//  
//  Created by CoderSamz on 2022.
// 	
// 
    

import UIKit

class TipButton: UIButton {

    // 提供一个自定义的构造方法
    init(center: CGPoint) {
        super.init(frame: CGRect(x: center.x - 10, y: center.y - 10, width: 20, height: 20))
        installUI()
    }
    // 初始化UI
    func installUI() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 10
        self.backgroundColor = UIColor.orange
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
