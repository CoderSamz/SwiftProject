//
//  ChessBoard.swift
//  ChineseChess
//  
//  Created by CoderSamz on 2022.
// 	
// 
    

import UIKit

protocol ChessBoardDelegate {
    // 当用户点击某个棋子时触发方法
    func chessItemClick(item: ChessItem)
    // 当棋子移动完成后触发的方法
    func chessMoveEnd()
    // 结束游戏回调，参数如果传入true，代表红方胜利
    func gameOver(redWin: Bool)
}

class ChessBoard: UIView {
    
    // 代理
    var delegate: ChessBoardDelegate?
    // 棋盘上所有可以行棋可以前进的位置标记的实例数组
    var tipButtonArray = Array<TipButton>()
    // 当前行棋的棋子可以前进的矩阵位置
    var currentCanMovePosition = Array<(Int, Int)>()

    // 根据屏幕宽度计算网格大小
    let width = (UIScreen.main.bounds.size.width - 40) / 9
    // 红方所有棋子
    let allRedChessItemName = ["車","馬","相","士","帥","士","相","馬","車","炮","炮","兵","兵","兵","兵","兵"]
    // 绿方所有棋子
    let allGreenChessItemName = ["车","马","象","仕","将","仕","象","马","车","炮","炮","卒","卒","卒","卒","卒"]
    
    // 棋盘上所剩下的红方棋子对象
    var currentRedItem = Array<ChessItem>()
    // 棋盘上所剩下的绿方棋子对象
    var currentGreenItem = Array<ChessItem>()
    
    override func draw(_ rect: CGRect) {
        // 获取当前视图的图形上下文
        let context = UIGraphicsGetCurrentContext()
        // 设置绘制线条的颜色为黑色
        context?.setStrokeColor(UIColor.black.cgColor)
        // 设置绘制线条的宽度为0.5个单位
        context?.setLineWidth(0.5)
        // 水平线的绘制
        for index in 0...9 {
            // 通过移动点来确定每行的起点
            context?.move(to: CGPoint(x: width / 2, y: width / 2 + width * CGFloat(index)))
            // 从左向右绘制水平线
            context?.addLine(to: CGPoint(x: rect.size.width - width / 2, y: width / 2 + width * CGFloat(index)))
            context?.drawPath(using: .stroke)
            
        }
        
        // 进行竖直线的绘制
        for index in 0..<9 {
            // 最左边和最右边的线贯穿始终
            if index == 0 || index == 8 {
                context?.move(to: CGPoint(x: width / 2 + width * CGFloat(index), y: width / 2))
                context?.addLine(to: CGPoint(x: width * CGFloat(index) + width / 2, y: rect.size.height - width / 2))
                
            } else {
                // 中间的先以楚河汉界为分隔
                context?.move(to: CGPoint(x: width / 2 + width * CGFloat(index), y: width / 2))
                context?.addLine(to: CGPoint(x: width * CGFloat(index) + width / 2, y: rect.size.height / 2 - width / 2))
                context?.move(to: CGPoint(x: width / 2 + width * CGFloat(index), y: rect.size.height / 2 + width / 2))
                context?.addLine(to: CGPoint(x: width * CGFloat(index) + width / 2, y: rect.size.height - width / 2))
            }
        }
        
        // 绘制双方主帅田字格
        context?.move(to: CGPoint(x: width / 2 + width * 3, y: width / 2))
        context?.addLine(to: CGPoint(x: width / 2 + width * 5, y: width / 2 + width * 2))
        context?.move(to: CGPoint(x: width / 2 + width * 5, y: width / 2))
        context?.addLine(to: CGPoint(x: width / 2 + width * 3, y: width / 2 + width * 2))
        context?.move(to: CGPoint(x: width / 2 + width * 3, y: width * 10 - width / 2))
        context?.addLine(to: CGPoint(x: width / 2 + width * 5, y: width * 10 - width / 2 - width * 2))
        context?.move(to: CGPoint(x: width / 2 + width * 5, y: width * 10 - width / 2))
        context?.addLine(to: CGPoint(x: width / 2 + width * 3, y: width * 10 - width / 2 - width * 2))
        context?.drawPath(using: .stroke)
        
    }
    
    init(origin: CGPoint) {
        // 根据屏幕宽度计算棋盘宽度
        super.init(frame: CGRect(x: origin.x, y: origin.y, width: UIScreen.main.bounds.size.width - 40, height: width * 10))
        // 设置棋盘背景色
        self.backgroundColor = UIColor(r: 1, g: 252, b: 234)
        // 楚河汉界标签
        let label1 = UILabel(frame: CGRect(x: width, y: width * 9 / 2, width: width * 3, height: width))
        label1.backgroundColor = UIColor.clear
        label1.text = "楚河"
        
        let label2 = UILabel(frame: CGRect(x: width * 5, y: width * 9 / 2, width: width * 3, height: width))
        label2.text = "漢界"
        label2.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        self.addSubview(label1)
        self.addSubview(label2)
        // 进行游戏重置
        reStartGame()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func reStartGame() {
        
        // 清理所有提示点
        tipButtonArray.forEach { item in
            item.removeFromSuperview()
        }
        tipButtonArray.removeAll()
        // 取消所有棋子的选中
        self.cancelAllSelect()
        
        // 清理残局
        currentRedItem.forEach { item in
            item.removeFromSuperview()
        }
        
        currentGreenItem.forEach { item in
            item.removeFromSuperview()
        }
        
        currentRedItem.removeAll()
        currentGreenItem.removeAll()
        
        // 棋子布局
        var redItem: ChessItem?
        var greenItem: ChessItem?
        // 红绿双方各有16个棋子
        for index in 0..<16 {
            // 进行非兵、非炮棋子的布局
            if index < 9 {
                // 红方布局
                redItem = ChessItem(center: CGPoint(x: width / 2 + width * CGFloat(index), y: width * 10 - width / 2))
                redItem!.setTitle(title: allRedChessItemName[index], isOwn: true)
                
                // 绿方布局
                greenItem = ChessItem(center: CGPoint(x: width / 2 + width * CGFloat(index), y: width / 2))
                greenItem!.setTitle(title: allGreenChessItemName[index], isOwn: false)
            } else if index < 11 {
                // 进行炮棋子布局
                if index == 9 {
                    redItem = ChessItem(center: CGPoint(x: width / 2 + width, y: width * 10 - width / 2 - width * 2))
                    redItem!.setTitle(title: allRedChessItemName[index], isOwn: true)
                    greenItem = ChessItem(center: CGPoint(x: width / 2 + width, y: width / 2 + width * 2))
                    greenItem!.setTitle(title: allGreenChessItemName[index], isOwn: false)
                } else {
                    redItem = ChessItem(center: CGPoint(x: width * 9 - width / 2 - width, y: width * 10 - width / 2 - width * 2))
                    redItem!.setTitle(title: allRedChessItemName[index], isOwn: true)
                    greenItem = ChessItem(center: CGPoint(x: width * 9 - width / 2 - width, y: width / 2 + width * 2))
                    greenItem!.setTitle(title: allGreenChessItemName[index], isOwn: false)
                }
            } else {
                // 进行兵棋子的布局
                
                // 红方布局
                redItem = ChessItem(center: CGPoint(x: width / 2 + width * 2 * CGFloat(index - 11), y: width * 10 - width / 2 - width * 3))
                redItem!.setTitle(title: allRedChessItemName[index], isOwn: true)
                
                // 绿方布局
                greenItem = ChessItem(center: CGPoint(x: width / 2 + width * 2 * CGFloat(index - 11), y: width / 2 + width * 3))
                greenItem!.setTitle(title: allGreenChessItemName[index], isOwn: false)
            }
            // 将棋子添加到当前视图
            self.addSubview(redItem!)
            self.addSubview(greenItem!)
            
            // 将棋子添加进数组
            currentRedItem.append(redItem!)
            currentGreenItem.append(greenItem!)
            
            // 添加用户交互方法
            redItem?.addTarget(self, action: #selector(itemClick), for: .touchUpInside)
            greenItem?.addTarget(self, action: #selector(itemClick), for: .touchUpInside)
        }
    }
    
    @objc func itemClick(item: ChessItem) {
//        item.setSelectedState()
        if delegate != nil {
            delegate?.chessItemClick(item: item)
        }
    }
    
    // 取消所有棋子的选中状态
    func cancelAllSelect() {
        currentRedItem.forEach { item in
            item.setUnselectedState()
        }
        currentGreenItem.forEach { item in
            item.setUnselectedState()
        }
    }
    
    // 将棋子坐标映射为二维矩阵中点
    func transfromPositionToMatrix(item: ChessItem) -> (Int,Int) {
        let res = (Int(item.center.x - width / 2) / Int(width), Int(item.center.y - width / 2) / Int(width))
        return res
    }
    
    // 获取棋盘上所有红方棋子在二维矩阵中位置的数组
    func getAllRedMatrixList() -> [(Int, Int)] {
        var list = Array<(Int, Int)>()
        currentRedItem.forEach { item in
            list.append(self.transfromPositionToMatrix(item: item))
        }
        return list
    }
    
    // 获得棋盘上所有绿方棋子在二维矩阵中位置的数组
    func getAllGreenMatrixList() -> [(Int, Int)] {
        var list = Array<(Int, Int)>()
        currentGreenItem.forEach { item in
            list.append(self.transfromPositionToMatrix(item: item))
        }
        return list
    }
    
    // 将可以移动到的位置进行标记
    func wantMoveItem(positions: [(Int, Int)], item: ChessItem) {
        // 如果是红方在路径上有己方棋子，则不能移动
        var list: Array<(Int, Int)>?
        
        if item.isRed {
            list = getAllRedMatrixList()
        } else {
            list = getAllGreenMatrixList()
        }
        
        currentCanMovePosition.removeAll()
        positions.forEach { position in
            if list!.contains(where: { (pos) -> Bool in
                if pos == position {
                    return true
                }
                return false
            }) {
            } else {
                currentCanMovePosition.append(position)
            }
        }
        
        // 将可以进行前进的位置使用按钮进行标记
        tipButtonArray.forEach { item in
            item.removeFromSuperview()
        }
        tipButtonArray.removeAll()
        for index in 0..<currentCanMovePosition.count {
            // 将矩阵转换成位置坐标
            let position = currentCanMovePosition[index]
            let center = CGPoint(x: CGFloat(position.0) * width + width / 2, y: CGFloat(position.1) * width + width / 2)
            let tip = TipButton(center: center)
            tip.addTarget(self, action: #selector(moveItem), for: .touchUpInside)
            tip.tag = 100 + index
            self.addSubview(tip)
            tipButtonArray.append(tip)
        }
    }
    
    // 获取所有红方棋子的矩阵数组
    func getAllRedMstrixList() -> [(Int, Int)] {
        var list = Array<(Int, Int)>()
        currentRedItem.forEach { item in
            list.append(self.transfromPositionToMatrix(item: item))
        }
        return list
    }
    
    // 获得棋盘上所有绿方棋子在二维矩阵中位置的数组
    func getAllGreenMstrixList() -> [(Int, Int)] {
        var list = Array<(Int, Int)>()
        currentGreenItem.forEach { item in
            list.append(self.transfromPositionToMatrix(item: item))
        }
        return list
    }
    
    @objc func moveItem(tipButton: TipButton) {
        // 得到要移动到的位置
        let position = currentCanMovePosition[tipButton.tag - 100]
        // 转换成坐标
        let point = CGPoint(x: CGFloat(position.0) * width + width / 2, y: CGFloat(position.1) * width + width / 2)
        
        // 找到被选中的棋子
        var isRed: Bool?
        currentRedItem.forEach { item in
            if item.selectedState {
                isRed = true
                // 进行动画移动
                UIView.animate(withDuration: 0.3) {
                    item.center = point
                }
            }
        }
        
        currentGreenItem.forEach { item in
            if item.selectedState {
                isRed = false
                // 进行动画移动
                UIView.animate(withDuration: 0.3) {
                    item.center = point
                }
            }
        }
        
        // 检查是否有敌方棋子，如果有，就吃掉该棋子
        var shouldDeleteItem: ChessItem?
        if isRed! {
            currentGreenItem.forEach { item in
                if transfromPositionToMatrix(item: item) == position {
                    shouldDeleteItem = item
                }
            }
        } else {
            currentRedItem.forEach { item in
                if transfromPositionToMatrix(item: item) == position {
                    shouldDeleteItem = item
                }
            }
        }
        
        if let it = shouldDeleteItem {
            it.removeFromSuperview()
            if isRed! {
                currentGreenItem.remove(at: currentGreenItem.firstIndex(of: it)!)
            } else {
                currentRedItem.remove(at: currentRedItem.firstIndex(of: it)!)
            }
            // 胜负判定
            if it.title(for: .normal) == "将" {
                if delegate != nil {
                    delegate!.gameOver(redWin: true)
                }
            }
            if it.title(for: .normal) == "帥" {
                if delegate != nil {
                    delegate!.gameOver(redWin: false)
                }
            }
        }
        
        // 删除标记
        tipButtonArray.forEach { item in
            item.removeFromSuperview()
        }
        
        tipButtonArray.removeAll()
        if delegate != nil {
            delegate?.chessMoveEnd()
        }
    }
}
