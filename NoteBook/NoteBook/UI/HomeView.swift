//
//  HomeView.swift
//  NoteBook
//  
//  Created by CoderSamz on 2022.
// 	
// 
    

import UIKit

protocol HomeButtonDelegate {
    func homeButtonClick(title: String)
}

class HomeView: UIScrollView {
    
    var homeButtonDelegate: HomeButtonDelegate?

    // 列间距
    let interitemSpacing = 15
    // 行间距
    let lineSpacing = 25
    // 存放所有分组标题数据
    var dataArray: Array<String>?
    // 存放所有分组按钮数组
    var itemArray: Array<UIButton> = Array<UIButton>()
    
    /// 更新布局的方法
    func updateLayout() {
        // 根据视图尺寸计算每个按钮的宽度
        let itemWidth = (self.frame.size.width - CGFloat(4 * interitemSpacing)) / 3
        // 计算每个按钮高度
        let itemHeight = itemWidth / 3 * 4
        // 移除界面已有按钮
        itemArray.forEach { element in
            element.removeFromSuperview()
        }
        // 移除数组所有元素
        itemArray.removeAll()
        // 进行布局
        if dataArray != nil && dataArray!.count > 0 {
            for index in 0..<dataArray!.count {
                let btn = UIButton(type: .system)
                btn.setTitle(dataArray![index], for: .normal)
                // 计算位置frame
                let btnX = CGFloat(interitemSpacing) + CGFloat(index % 3) * (itemWidth + CGFloat(interitemSpacing))
                let btnY = CGFloat(lineSpacing) + CGFloat(index / 3) * (itemHeight + CGFloat(lineSpacing))
        
                btn.frame = CGRect(x: btnX, y: btnY, width: itemWidth, height: itemHeight)
                btn.backgroundColor = UIColor(r: 1, g: 242, b: 216)
                // 设置圆角
                btn.layer.masksToBounds = true
                btn.layer.cornerRadius = 15
                btn.setTitleColor(.gray, for: .normal)
                btn.tag = index
                btn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
                
                self.addSubview(btn)
                itemArray.append(btn)
            }
            // 设置ScrollView 内容尺寸
            self.contentSize = CGSize(width: 0, height: itemArray.last!.frame.maxY + CGFloat(lineSpacing))
        }
        
        
    }

    // 按钮触发方法
    @objc func btnClick(btn:UIButton) {
        if homeButtonDelegate != nil {
            homeButtonDelegate?.homeButtonClick(title: dataArray![btn.tag])
        }
    }
}
