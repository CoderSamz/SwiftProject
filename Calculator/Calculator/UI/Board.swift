//
//  Board.swift
//  Calculator
//  
//  Created by CoderSamz on 2022.
// 	
// 
    

import UIKit
import SnapKit

protocol BoardButtonInputDelegate {
    func boardButtonClick(content:String)
}

class Board: UIView {

    var delegate: BoardButtonInputDelegate?
    
    let dataArray = ["0",".","%","="
                     ,"1","2","3","+"
                     ,"4","5","6","-"
                     ,"7","8","9","*"
                     ,"AC","Delete","^","/"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        installUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func installUI() {
        var frontBtn: FuncButton!
        for index in 0..<dataArray.count {
            let btn = FuncButton()
            self.addSubview(btn)
            btn.snp.makeConstraints { make in
                
                // 每行第一个按钮，靠近父视图左侧摆放
                if index % 4 == 0 {
                    make.left.equalTo(0)
                } else {
                    // 否则按钮靠近上一个按钮右侧摆放
                    make.left.equalTo(frontBtn.snp.right)
                }
                
                // 当按钮为第一行时，将其靠近父视图底部摆放
                if index / 4 == 0 {
                    make.bottom.equalTo(0)
                } else if index % 4 == 0{
                    // 当按钮不在第一且为每一行的第一个时，将其底部与上一个按钮的顶部对齐
                    make.bottom.equalTo(frontBtn.snp.top)
                } else {
                    // 否则，将其底部与上一个按钮底部对齐
                    make.bottom.equalTo(frontBtn.snp.bottom)
                }
                
                // 约束宽度为父视图宽度的0.25倍
                make.width.equalTo(btn.superview!.snp.width).multipliedBy(0.25)
                // 约束高度为父视图高度的0.2倍
                make.height.equalTo(btn.superview!.snp.height).multipliedBy(0.2)
                
            }
            
            // 设置一个标记tag值
            btn.tag = index + 100
            
            // 添加点击事件
            btn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
            // 设置标题
            btn.setTitle(dataArray[index], for: .normal)
            // 保存为上一个按钮
            frontBtn = btn
        }
        
    }
    
    @objc func btnClick(button: FuncButton) {
//        print(button.title(for: .normal) ?? "空值")
        if delegate != nil {
            delegate?.boardButtonClick(content: button.currentTitle!)
        }
    }

}
