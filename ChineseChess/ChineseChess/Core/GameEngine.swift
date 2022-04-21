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
    
    let checkMoveDic: [String: [[(Int, Int)]]] = [
        "兵":[[(0,-1)],[(0,-1),(-1,0),(1,0)]], // 第一个元素是没过界前的可行算法，第二个元素是过界之后的
        "卒":[[(0,1)],[(0,1),(-1,0),(1,0)]],
        "将":[[(0,1),(0,-1),(1,0),(-1,0)]],
        "帥":[[(0,1),(0,-1),(1,0),(-1,0)]],
        "仕":[[(1,1),(-1,-1),(-1,1),(1,-1)]],
        "士":[[(1,1),(-1,-1),(-1,1),(1,-1)]],
        "相":[[(2,2),(-2,-2),(2,-2),(-2,2)]],
        "象":[[(2,2),(-2,-2),(2,-2),(-2,2)]],
        "马":[[(1,2),(1,-2),(2,1),(2,-1),(-1,2),(-1,-2),(-2,1),(-2,-1)]],
        "馬":[[(1,2),(1,-2),(2,1),(2,-1),(-1,2),(-1,-2),(-2,1),(-2,-1)]]
    ]
    
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
        // 获取棋子在二维矩阵中的位置
        let position = gameBoard!.transfromPositionToMatrix(item: item)
        let name = item.title(for: .normal)!
        var wantMoveList: [(Int, Int)]?
        
        if name != "车" && name != "車" && name != "炮" {
            // 判断棋子是否过界
            if (item.isRed && position.1 < 5) || (!item.isRed && position.1 > 4) {
                // 过界
                if checkMoveDic.count > 1 {
                    wantMoveList = checkMoveDic[name]!.last
                } else {
                    wantMoveList = checkMoveDic[name]!.first
                }
            } else {
                // 没过界
                wantMoveList = checkMoveDic[name]!.first
            }
        
            calculateNormalItemPosition(wantMove: wantMoveList!, position: position, item: item)
        
        } else {
            calculateSpecItemPosition(item: item)
        }
        
    }
    
    func calculateSpecItemPosition(item: ChessItem) {
        // 获取棋子在二维矩阵中的位置
        let position = gameBoard!.transfromPositionToMatrix(item: item)
        var wantMove = Array<(Int, Int)>()
        let redList = gameBoard!.getAllRedMstrixList()
        let greenList = gameBoard!.getAllGreenMstrixList()
        
        if item.title(for: .normal) == "车" || item.title(for: .normal) == "車" {
            // 车可以沿水平和竖直两个方向行棋
            // 水平方向为左和右
            var temP = position
            while temP.0 - 1 >= 0 {
                // 如果有棋子，则退出循环
                if redList.contains(where: { (pos) -> Bool in
                    return pos == (temP.0 - 1, temP.1)
                }) || greenList.contains(where: { (pos) -> Bool in
                    return pos == (temP.0 - 1, temP.1)
                }) {
                    wantMove.append((temP.0 - 1, temP.1))
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
                }) {
                    wantMove.append((temP.0 + 1, temP.1))
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
                }) {
                    wantMove.append((temP.0, temP.1 + 1))
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
                }) {
                    wantMove.append((temP.0, temP.1 - 1))
                } else {
                    wantMove.append((temP.0, temP.1 - 1))
                }
                temP.1 -= 1
            }
        }
        
        if item.title(for: .normal) == "炮" {
            // 炮可以沿水平和竖直两个方向行棋
            // 水平方向为左和右
            var temP = position
            var isFirst = true
            while temP.0 - 1 >= 0 {
                // 如果有棋子，则找出其后面最近的一颗棋子，之后退出循环
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
                        wantMove.append((temP.0 + 1, temP.1))
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
        }
        // 交给棋盘类进行移动提示
        gameBoard?.wantMoveItem(positions: wantMove, item: item)
    }
    
    func calculateNormalItemPosition(wantMove: [(Int, Int)], position: (Int, Int), item: ChessItem) {
        
        // 构造行棋位置数组
        var couldMove = Array<(Int, Int)>()
        let name = item.title(for: .normal)!
        let redList = gameBoard!.getAllRedMstrixList()
        let greenList = gameBoard!.getAllGreenMstrixList()
        
        if name == "兵" || name == "卒" {
            wantMove.forEach { (pos) in
                let newPos = (position.0 + pos.0, position.1 + pos.1)
                if newPos.0 < 0 || newPos.0 > 8 || newPos.1 < 0 || newPos.1 > 9 {
                    
                } else {
                    couldMove.append(newPos)
                }
            }
        }
        
        if name == "将" || name == "仕" {
            wantMove.forEach { (pos) in
                let newPos = (position.0 + pos.0, position.1 + pos.1)
                if newPos.0 < 3 || newPos.0 > 5 || newPos.1 < 0 || newPos.1 > 2 {
                    
                } else {
                    couldMove.append(newPos)
                }
            }
        }
        
        if name == "帥" || name == "士" {
            wantMove.forEach { (pos) in
                let newPos = (position.0 + pos.0, position.1 + pos.1)
                if newPos.0 < 3 || newPos.0 > 5 || newPos.1 < 7 || newPos.1 > 9 {
                    
                } else {
                    couldMove.append(newPos)
                }
            }
        }
        
        if name == "相" {
            wantMove.forEach { (pos) in
                let newPos = (position.0 + pos.0, position.1 + pos.1)
                if newPos.0 < 0 || newPos.0 > 8 || newPos.1 < 5 || newPos.1 > 9 {
                    
                } else {
                    if redList.contains(where: { (po) -> Bool in
                        return po == (position.0 + pos.0 / 2, position.1 + pos.1 / 2)
                    }) || greenList.contains(where: { (po) -> Bool in
                        return po == (position.0 + pos.0 / 2, position.1 + pos.1 / 2)
                    }){
                        // 塞相眼，不添加此位置
                    } else {
                        couldMove.append(newPos)
                    }
                }
            }
        }
        
        if name == "象" {
            wantMove.forEach { (pos) in
                let newPos = (position.0 + pos.0, position.1 + pos.1)
                if newPos.0 < 0 || newPos.0 > 8 || newPos.1 < 0 || newPos.1 > 4 {
                    
                } else {
                    if redList.contains(where: { (po) -> Bool in
                        return po == (position.0 + pos.0 / 2, position.1 + pos.1 / 2)
                    }) || greenList.contains(where: { (po) -> Bool in
                        return po == (position.0 + pos.0 / 2, position.1 + pos.1 / 2)
                    }){
                        // 塞相眼，不添加此位置
                    } else {
                        couldMove.append(newPos)
                    }
                }
            }
        }
        
        if name == "马" || name == "馬" {
            wantMove.forEach { (pos) in
                let newPos = (position.0 + pos.0, position.1 + pos.1)
                if newPos.0 < 0 || newPos.0 > 8 || newPos.1 < 0 || newPos.1 > 9 {
                    
                } else {
                    let tmpPos: (Int, Int)?
                    if abs(pos.0) < abs(pos.1) {
                        tmpPos = (position.0, position.1 + pos.1 / 2)
                    } else {
                        tmpPos = (position.0 + pos.0 / 2, position.1)
                    }
                    
                    if redList.contains(where: { (po) -> Bool in
                        return po == tmpPos!
                    }) || greenList.contains(where: { (po) -> Bool in
                        return po == tmpPos!
                    }){
                        // 别马蹄，不添加此位置
                    } else {
                        couldMove.append(newPos)
                    }
                }
            }
        }
        
        // 交给棋盘类进行移动提示
        gameBoard?.wantMoveItem(positions: couldMove, item: item)
        
    }
    
    // 一方行棋完成后，换另一个行棋
    func chessMoveEnd() {
        shouldRedMove = !shouldRedMove
        gameBoard?.cancelAllSelect()
    }
}
