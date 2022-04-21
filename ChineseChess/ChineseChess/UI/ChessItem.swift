//
//  ChessItem.swift
//  ChineseChess
//  
//  Created by CoderSamz on 2022.
// 	
// 
    

import UIKit

class ChessItem: UIButton {

    // 标记旗子的选择状态
    var selectedState: Bool = false
    
    // 标记是否为红方旗子
    var isRed = true
    
    // 提供一个自定义的构造方法
    init(center: CGPoint) {
        // 根据屏幕尺寸决定旗子大小
        let screenSize = UIScreen.main.bounds.size
        let itemSize = CGSize(width: (screenSize.width - 40) / 9 - 4, height: (screenSize.width - 40) / 9 - 4)
        super.init(frame: CGRect(origin: CGPoint(x: center.x - itemSize.width / 2, y: center.y - itemSize.width / 2), size: itemSize))
        installUI()
    }
    
    // 棋子UI设计
    func installUI() {
        self.backgroundColor = .white
        self.layer.masksToBounds = true
        self.layer.cornerRadius = ((UIScreen.main.bounds.size.width - 40) / 9 - 4) / 2
        self.layer.borderWidth = 0.5
    }
    
    // 设置棋子标题，isOwn决定是己方还是敌方
    func setTitle(title: String, isOwn: Bool) {
        self.setTitle(title, for: .normal)
        if isOwn {
            self.layer.borderColor = UIColor.red.cgColor
            self.setTitleColor(UIColor.red, for: .normal)
            self.isRed = true
        } else {
            self.layer.borderColor = UIColor.green.cgColor
            self.setTitleColor(UIColor.green, for: .normal)
            // 敌方棋子旋转180度
            self.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
            self.isRed = false
        }
    }
    
    // 设置棋子选中状态
    func setSelectedState() {
        if !selectedState {
            selectedState = true
            self.backgroundColor = UIColor.purple
        }
    }
    
    // 设置棋子非选中状态
    func setUnselectedState() {
        if selectedState {
            selectedState = false
            self.backgroundColor = UIColor.white
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
