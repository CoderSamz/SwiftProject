//
//  GameEngine.swift
//  ChineseChess
//  
//  Created by CoderSamz on 2022.
// 	
// 
    

import UIKit


protocol GameEngineDelegate {
    func gameOver(redWin: Bool)
    // 当前行棋的一方改变时调用
    func couldRedMove(red: Bool)
}

// 需要遵守ChessBoardDelegate协议

class GameEngine: NSObject, ChessBoardDelegate {
    
    var delegate: GameEngineDelegate?
    // 开始游戏的标记
    var isStarting = false
    
    // 当前游戏棋盘
    var gameBoard: ChessBoard?
    // 设置是否红方先走，默认红方先走
    var redFirstMove = true
    //  标记当前需要行棋子的一方
    var shouldRedMove = true
    
//    let checkMoveDic: [String: [[(Int, Int)]]] = [
//        "兵":[[(0,1)],[(0,1),(-1,0),(1,0)]], // 第一个元素是没过界前的可行算法，第二个元素是过界之后的
//        "卒":[[(0,1)],[(0,1),(-1,0),(1,0)]],
//        "将":[[(0,1),(0,-1),(1,0),(-1,0)]],
//        "帥":[[(0,1),(0,-1),(1,0),(-1,0)]],
//        "仕":[[(1,1),(-1,-1),(-1,1),(1,-1)]],
//        "士":[[(1,1),(-1,-1),(-1,1),(1,-1)]],
//        "相":[[(2,2),(-2,-2),(2,-2),(-2,2)]],
//        "象":[[(2,2),(-2,-2),(2,-2),(-2,2)]],
//        "马":[[(1,2),(1,-2),(2,1),(2,-1),(-1,2),(-1,-2),(-2,1),(-2,-1)]],
//        "将":[[(1,2),(1,-2),(2,1),(2,-1),(-1,2),(-1,-2),(-2,1),(-2,-1)]],
//    ]
    
    init(board: ChessBoard) {
        gameBoard = board
        super.init()
        gameBoard?.delegate = self
    }
    
    // 开始游戏的方法
    func startGame() {
        isStarting = true
        gameBoard?.reStartGame()
        shouldRedMove = redFirstMove
        if delegate != nil {
            delegate?.couldRedMove(red: shouldRedMove)
        }
    }
    
    func gameOver(redWin: Bool) {
        // 游戏结束
        isStarting = false
        // 将胜负状态传递给界面
        if delegate != nil {
            delegate?.gameOver(redWin: redWin)
        }
    }
    
    // 设置先行棋的一方
    func setRedFirstMove(red: Bool) {
        redFirstMove = red
        shouldRedMove = red
    }
    
    // 用户点击某个棋子后的回调
    func chessItemClick(item: ChessItem) {
        // 判断所点击的棋子是否属于应该行棋的一方
        if shouldRedMove {
            if item.isRed {
                gameBoard?.cancelAllSelect()
                item.setSelectedState()
            } else {
                return
            }
        } else {
            if !item.isRed {
                gameBoard?.cancelAllSelect()
                item.setSelectedState()
            } else {
                return
            }
        }
        
        // 进行行棋算法
        checkCanMove(item: item)
    }
    
    // 检测可以移动的位置
    func checkCanMove(item: ChessItem) {
        // 进行“兵”行棋算法
        if item.title(for: .normal) == "兵"{
            // 获取棋子在二维矩阵中的位置
            let positon = gameBoard!.transfromPositionToMatrix(item: item)
            // 如果没过河界，“兵”只能前进
            var wantMove = Array<(Int, Int)>()
            if positon.1 > 4 {
                wantMove = [(positon.0, positon.1 - 1)]
            }else {
                // 左右前进
                if positon.0 > 0 {
                    wantMove.append((positon.0 - 1, positon.1))
                }
                if positon.0 < 8 {
                    wantMove.append((positon.0 + 1, positon.1))
                }
                if positon.1 > 0 {
                    wantMove.append((positon.0, positon.1 - 1))
                }
            }
            // 交换给棋盘类进行移动提示
            gameBoard?.wantMoveItem(positions: wantMove, item: item)
        }
        
        if item.title(for: .normal) == "卒" {
            // 获取棋子在二维矩阵中的位置
            let positon = gameBoard!.transfromPositionToMatrix(item: item)
            // 如果没过河界，“卒”只能前进
            var wantMove = Array<(Int, Int)>()
            if positon.1 < 5 {
                wantMove = [(positon.0, positon.1 + 1)]
            }else {
                // 左右前进
                if positon.0 > 0 {
                    wantMove.append((positon.0 - 1, positon.1))
                }
                if positon.0 < 8 {
                    wantMove.append((positon.0 + 1, positon.1))
                }
                if positon.1 < 9 {
                    wantMove.append((positon.0, positon.1 + 1))
                }
            }
            // 交换给棋盘类进行移动提示
            gameBoard?.wantMoveItem(positions: wantMove, item: item)
        }
        
        if item.title(for: .normal) == "士" {
            // 获取棋子在二维矩阵中的位置
            let position = gameBoard!.transfromPositionToMatrix(item: item)
            // 士在将格内沿对角线行棋
            var wantMove = Array<(Int, Int)>()
            // 在左上、右上、左下、右下4个方向行棋
            if position.0 < 5 && position.1 > 7 {
                wantMove.append((position.0 + 1, position.1 - 1))
            }
            if position.0 > 3 && position.1 < 9 {
                wantMove.append((position.0 - 1, position.1 + 1))
            }
            if position.0 > 3 && position.1 > 7 {
                wantMove.append((position.0 - 1, position.1 - 1))
            }
            if position.0 < 5 && position.1 < 9 {
                wantMove.append((position.0 + 1, position.1 + 1))
            }
            
            // 交给棋盘类进行移动提示
            gameBoard?.wantMoveItem(positions: wantMove, item: item)
        }
        
        if item.title(for: .normal) == "仕" {
            // 获取棋子在二维矩阵中的位置
            let position = gameBoard!.transfromPositionToMatrix(item: item)
            // 仕在将格内沿对角线行棋
            var wantMove = Array<(Int, Int)>()
            // 在左上、右上、左下、右下4个方向行棋
            if position.0 < 5 && position.1 < 2 {
                wantMove.append((position.0 + 1, position.1 + 1))
            }
            if position.0 > 3 && position.1 > 0 {
                wantMove.append((position.0 - 1, position.1 - 1))
            }
            if position.0 > 3 && position.1 < 2 {
                wantMove.append((position.0 - 1, position.1 + 1))
            }
            if position.0 < 5 && position.1 > 0 {
                wantMove.append((position.0 + 1, position.1 - 1))
            }
            
            // 交给棋盘类进行移动提示
            gameBoard?.wantMoveItem(positions: wantMove, item: item)
        }
        
        if item.title(for: .normal) == "帥" {
            // 获取棋子在二维矩阵中的位置
            let position = gameBoard!.transfromPositionToMatrix(item: item)
            
            var wantMove = Array<(Int, Int)>()
            // 在帥宫格内上下左右移动
            if position.1 < 9 {
                wantMove.append((position.0, position.1 + 1))
            }
            if position.1 > 7 {
                wantMove.append((position.0, position.1 - 1))
            }
            if position.0 < 5 {
                wantMove.append((position.0 + 1, position.1))
            }
            if position.0 > 3 {
                wantMove.append((position.0 - 1, position.1))
            }
            
            // 交给棋盘类进行移动提示
            gameBoard?.wantMoveItem(positions: wantMove, item: item)
        }
        
        if item.title(for: .normal) == "将" {
            // 获取棋子在二维矩阵中的位置
            let position = gameBoard!.transfromPositionToMatrix(item: item)
            
            var wantMove = Array<(Int, Int)>()
            // 在将宫格内上下左右移动
            if position.1 < 2 {
                wantMove.append((position.0, position.1 + 1))
            }
            if position.1 > 0 {
                wantMove.append((position.0, position.1 - 1))
            }
            if position.0 < 5 {
                wantMove.append((position.0 + 1, position.1))
            }
            if position.0 > 3 {
                wantMove.append((position.0 - 1, position.1))
            }
            
            // 交给棋盘类进行移动提示
            gameBoard?.wantMoveItem(positions: wantMove, item: item)
        }
        
        if item.title(for: .normal) == "相" {
            // 获取棋子在二维矩阵中的位置
            let position = gameBoard!.transfromPositionToMatrix(item: item)
            var wantMove = Array<(Int, Int)>()
            let redList = gameBoard!.getAllRedMatrixList()
            let greenList = gameBoard!.getAllGreenMatrixList()
            // 左上、右上、左下、右下
            if position.0 - 2 >= 0 && position.1 - 2 > 4 {
                // 判断是否有棋子塞相眼
                if redList.contains(where: { (pos) -> Bool in
                    return pos == (position.0 - 1, position.1 - 1)
                }) || greenList.contains(where: { (pos) -> Bool in
                    return pos == (position.0 - 1, position.1 - 1)
                }) {
                    // 塞相眼，不添加此位置
                } else {
                    wantMove.append((position.0 - 2, position.1 - 2))
                }
            }
            
            if position.0 + 2 <= 8 && position.1 + 2 <= 9 {
                // 判断是否有棋子塞相眼
                if redList.contains(where: { (pos) -> Bool in
                    return pos == (position.0 + 1, position.1 + 1)
                }) || greenList.contains(where: { (pos) -> Bool in
                    return pos == (position.0 + 1, position.1 + 1)
                }){
                    // 塞相眼，不添加此位置
                } else {
                    wantMove.append((position.0 + 2, position.1 + 2))
                }
            }
            
            if position.0 + 2 <= 8 && position.1 - 2 > 4 {
                // 判断是否有棋子塞相眼
                if redList.contains(where: { (pos) -> Bool in
                    return pos == (position.0 + 1, position.1 - 1)
                }) || greenList.contains(where: { (pos) -> Bool in
                    return pos == (position.0 + 1, position.1 - 1)
                }){
                    // 塞相眼，不添加此位置
                } else {
                    wantMove.append((position.0 + 2, position.1 - 2))
                }
            }
            
            if position.0 - 2 >= 0 && position.1 + 2 <= 9 {
                // 判断是否有棋子塞相眼
                if redList.contains(where: { (pos) -> Bool in
                    return pos == (position.0 - 1, position.1 + 1)
                }) || greenList.contains(where: { (pos) -> Bool in
                    return pos == (position.0 - 1, position.1 + 1)
                }){
                    // 塞相眼，不添加此位置
                } else {
                    wantMove.append((position.0 + 2, position.1 + 2))
                }
            }
            
            // 交换给棋盘类进行移动提示
            gameBoard?.wantMoveItem(positions: wantMove, item: item)
        }
        
        if item.title(for: .normal) == "象" {
            // 获取棋子在二维矩阵中的位置
            let position = gameBoard!.transfromPositionToMatrix(item: item)
            var wantMove = Array<(Int, Int)>()
            let redList = gameBoard!.getAllRedMatrixList()
            let greenList = gameBoard!.getAllGreenMatrixList()
            // 左上、右上、左下、右下
            if position.0 - 2 >= 0 && position.1 - 2 >= 0 {
                // 判断是否有棋子塞象眼
                if redList.contains(where: { (pos) -> Bool in
                    return pos == (position.0 - 1, position.1 - 1)
                }) || greenList.contains(where: { (pos) -> Bool in
                    return pos == (position.0 - 1, position.1 - 1)
                }) {
                    // 塞象眼，不添加此位置
                } else {
                    wantMove.append((position.0 - 2, position.1 - 2))
                }
            }
            
            if position.0 + 2 <= 8 && position.1 + 2 <= 4 {
                // 判断是否有棋子塞象眼
                if redList.contains(where: { (pos) -> Bool in
                    return pos == (position.0 + 1, position.1 + 1)
                }) || greenList.contains(where: { (pos) -> Bool in
                    return pos == (position.0 + 1, position.1 + 1)
                }){
                    // 塞象眼，不添加此位置
                } else {
                    wantMove.append((position.0 + 2, position.1 + 2))
                }
            }
            
            if position.0 + 2 <= 8 && position.1 - 2 >= 0 {
                // 判断是否有棋子塞象眼
                if redList.contains(where: { (pos) -> Bool in
                    return pos == (position.0 + 1, position.1 - 1)
                }) || greenList.contains(where: { (pos) -> Bool in
                    return pos == (position.0 + 1, position.1 - 1)
                }){
                    // 塞象眼，不添加此位置
                } else {
                    wantMove.append((position.0 + 2, position.1 - 2))
                }
            }
            
            if position.0 - 2 >= 0 && position.1 + 2 <= 4 {
                // 判断是否有棋子塞象眼
                if redList.contains(where: { (pos) -> Bool in
                    return pos == (position.0 - 1, position.1 + 1)
                }) || greenList.contains(where: { (pos) -> Bool in
                    return pos == (position.0 - 1, position.1 + 1)
                }){
                    // 塞象眼，不添加此位置
                } else {
                    wantMove.append((position.0 - 2, position.1 + 2))
                }
            }
            
            // 交换给棋盘类进行移动提示
            gameBoard?.wantMoveItem(positions: wantMove, item: item)
        }
        
        if item.title(for: .normal) == "马" || item.title(for: .normal) == "馬" {
            // 获取棋子在二维矩阵中的位置
            let position = gameBoard!.transfromPositionToMatrix(item: item)
            var wantMove = Array<(Int, Int)>()
            let redList = gameBoard!.getAllRedMatrixList()
            let greenList = gameBoard!.getAllGreenMatrixList()
            // 以日字行走8个方向，上、下、左、右各两个方向
            if position.0 - 1 >= 0 && position.1 - 2 >= 0 {
                
                if redList.contains(where: { (pos) -> Bool in
                    return pos == (position.0, position.1 - 1)
                }) || greenList.contains(where: { (pos) -> Bool in
                    return pos == (position.0, position.1 - 1)
                }) {
                    
                } else {
                    wantMove.append((position.0 - 1, position.1 - 2))
                }
            }
            
            if position.0 + 1 <= 8 && position.1 - 2 >= 0 {
    
                if redList.contains(where: { (pos) -> Bool in
                    return pos == (position.0, position.1 - 1)
                }) || greenList.contains(where: { (pos) -> Bool in
                    return pos == (position.0, position.1 - 1)
                }){
                    
                } else {
                    wantMove.append((position.0 + 1, position.1 - 2))
                }
            }
            
            if position.0 + 2 <= 8 && position.1 - 1 >= 0 {
                
                if redList.contains(where: { (pos) -> Bool in
                    return pos == (position.0 + 1, position.1)
                }) || greenList.contains(where: { (pos) -> Bool in
                    return pos == (position.0 + 1, position.1)
                }){
                    
                } else {
                    wantMove.append((position.0 + 2, position.1 - 1))
                }
            }
            
            if position.0 + 2 <= 8 && position.1 + 1 <= 9 {
                
                if redList.contains(where: { (pos) -> Bool in
                    return pos == (position.0 + 1, position.1)
                }) || greenList.contains(where: { (pos) -> Bool in
                    return pos == (position.0 + 1, position.1)
                }){
                    
                } else {
                    wantMove.append((position.0 + 2, position.1 + 1))
                }
            }
            
            if position.0 + 1 <= 8 && position.1 + 2 <= 9 {
                
                if redList.contains(where: { (pos) -> Bool in
                    return pos == (position.0, position.1 + 1)
                }) || greenList.contains(where: { (pos) -> Bool in
                    return pos == (position.0, position.1 + 1)
                }){
                    
                } else {
                    wantMove.append((position.0 + 1, position.1 + 2))
                }
            }
            
            if position.0 - 1 >= 0 && position.1 + 2 <= 9 {
                
                if redList.contains(where: { (pos) -> Bool in
                    return pos == (position.0, position.1 + 1)
                }) || greenList.contains(where: { (pos) -> Bool in
                    return pos == (position.0, position.1 + 1)
                }){
                    
                } else {
                    wantMove.append((position.0 - 1, position.1 + 2))
                }
            }
            
            if position.0 - 2 >= 0 && position.1 + 1 <= 9 {
                
                if redList.contains(where: { (pos) -> Bool in
                    return pos == (position.0 - 1, position.1)
                }) || greenList.contains(where: { (pos) -> Bool in
                    return pos == (position.0 - 1, position.1)
                }){
                    
                } else {
                    wantMove.append((position.0 - 2, position.1 + 1))
                }
            }
            
            if position.0 - 2 >= 0 && position.1 - 1 >= 0 {
                
                if redList.contains(where: { (pos) -> Bool in
                    return pos == (position.0 - 1, position.1)
                }) || greenList.contains(where: { (pos) -> Bool in
                    return pos == (position.0 - 1, position.1)
                }){
                    
                } else {
                    wantMove.append((position.0 - 2, position.1 - 1))
                }
            }
            
            // 交换给棋盘类进行移动提示
            gameBoard?.wantMoveItem(positions: wantMove, item: item)
        }
        
        if item.title(for: .normal) == "车" || item.title(for: .normal) == "車" {
            // 获取棋子在二维矩阵中的位置
            let position = gameBoard!.transfromPositionToMatrix(item: item)
            var wantMove = Array<(Int, Int)>()
            let redList = gameBoard!.getAllRedMatrixList()
            let greenList = gameBoard!.getAllGreenMatrixList()
            // 车可以沿水平和竖直两个方向行棋
            // 水平方向分为左和右
            var temP = position
            while temP.0 - 1 >= 0 {
                // 如果有棋子，则退出循环
                if redList.contains(where: { (pos) -> Bool in
                    return pos == (temP.0 - 1, temP.1)
                }) || greenList.contains(where: { (pos) -> Bool in
                    return pos == (temP.0 - 1, temP.1)
                }) {
                    wantMove.append((temP.0 - 1, temP.1))
                    break
                } else {
                    wantMove.append((temP.0 - 1, temP.1))
                }
                temP.0 -= 1
            }
            
            temP = position
            while temP.0 + 1 <= 8 {
                // 如果有棋子，则退出循环
                if redList.contains(where: { (pos) -> Bool in
                    return pos == (temP.0 + 1, temP.1)
                }) || greenList.contains(where: { (pos) -> Bool in
                    return pos == (temP.0 + 1, temP.1)
                }){
                    wantMove.append((temP.0 + 1, temP.1))
                    break
                } else {
                    wantMove.append((temP.0 + 1, temP.1))
                }
                temP.0 += 1
            }
            
            temP = position
            while temP.1 + 1 <= 9 {
                // 如果有棋子，则退出循环
                if redList.contains(where: { (pos) -> Bool in
                    return pos == (temP.0, temP.1 + 1)
                }) || greenList.contains(where: { (pos) -> Bool in
                    return pos == (temP.0, temP.1 + 1)
                }){
                    wantMove.append((temP.0, temP.1 + 1))
                    break
                } else {
                    wantMove.append((temP.0, temP.1 + 1))
                }
                temP.1 += 1
            }
            
            temP = position
            while temP.1 - 1 >= 0 {
                // 如果有棋子，则退出循环
                if redList.contains(where: { (pos) -> Bool in
                    return pos == (temP.0, temP.1 - 1)
                }) || greenList.contains(where: { (pos) -> Bool in
                    return pos == (temP.0, temP.1 - 1)
                }){
                    wantMove.append((temP.0, temP.1 - 1))
                    break
                } else {
                    wantMove.append((temP.0, temP.1 - 1))
                }
                temP.1 -= 1
            }
            
            // 交换给棋盘类进行移动提示
            gameBoard?.wantMoveItem(positions: wantMove, item: item)
        }
        
        if item.title(for: .normal) == "炮" {
            // 获取棋子在二维矩阵中的位置
            let position = gameBoard!.transfromPositionToMatrix(item: item)
            var wantMove = Array<(Int, Int)>()
            let redList = gameBoard!.getAllRedMatrixList()
            let greenList = gameBoard!.getAllGreenMatrixList()
            // 炮可以沿水平和竖直两个方向行棋
            // 水平方向分为左和右
            var temP = position
            var isFirst = true
            while temP.0 - 1 >= 0 {
                // 如果有棋子，则找出其后后面的最近一个棋子，之后退出循环
                if redList.contains(where: { (pos) -> Bool in
                    return pos == (temP.0 - 1, temP.1)
                }) || greenList.contains(where: { (pos) -> Bool in
                    return pos == (temP.0 - 1, temP.1)
                }) {
                    if !isFirst {
                        wantMove.append((temP.0 - 1, temP.1))
                        break
                    }
                    isFirst = false
                    
                } else {
                    if isFirst {
                        wantMove.append((temP.0 - 1, temP.1))
                    }
                    
                }
                temP.0 -= 1
            }
            
            temP = position
            isFirst = true
            while temP.0 + 1 <= 8 {
                // 如果有棋子，则退出循环
                if redList.contains(where: { (pos) -> Bool in
                    return pos == (temP.0 + 1, temP.1)
                }) || greenList.contains(where: { (pos) -> Bool in
                    return pos == (temP.0 + 1, temP.1)
                }) {
                    if !isFirst {
                        wantMove.append((temP.0 - 1, temP.1))
                        break
                    }
                    isFirst = false
                    
                } else {
                    if isFirst {
                        wantMove.append((temP.0 + 1, temP.1))
                    }
                    
                }
                temP.0 += 1
            }
            
            temP = position
            isFirst = true
            while temP.1 + 1 <= 9 {
                // 如果有棋子，则退出循环
                if redList.contains(where: { (pos) -> Bool in
                    return pos == (temP.0, temP.1 + 1)
                }) || greenList.contains(where: { (pos) -> Bool in
                    return pos == (temP.0, temP.1 + 1)
                }) {
                    if !isFirst {
                        wantMove.append((temP.0, temP.1 + 1))
                        break
                    }
                    isFirst = false
                    
                } else {
                    if isFirst {
                        wantMove.append((temP.0, temP.1 + 1))
                    }
                    
                }
                temP.1 += 1
            }
            
            temP = position
            isFirst = true
            while temP.1 - 1 >= 0 {
                // 如果有棋子，则退出循环
                if redList.contains(where: { (pos) -> Bool in
                    return pos == (temP.0, temP.1 - 1)
                }) || greenList.contains(where: { (pos) -> Bool in
                    return pos == (temP.0, temP.1 - 1)
                }) {
                    if !isFirst {
                        wantMove.append((temP.0, temP.1 - 1))
                        break
                    }
                    isFirst = false
                    
                } else {
                    if isFirst {
                        wantMove.append((temP.0, temP.1 - 1))
                    }
                    
                }
                temP.1 -= 1
            }
            
            // 交换给棋盘类进行移动提示
            gameBoard?.wantMoveItem(positions: wantMove, item: item)
        }
        
        
        
    }
    
    // 一方行棋完成后，换另一个行棋
    func chessMoveEnd() {
        shouldRedMove = !shouldRedMove
        gameBoard?.cancelAllSelect()
    }
}
