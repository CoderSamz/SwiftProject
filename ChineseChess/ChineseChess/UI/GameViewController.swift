//
//  GameViewController.swift
//  ChineseChess
//  
//  Created by CoderSamz on 2022.
// 	
// 
    

import UIKit

class GameViewController: UIViewController, GameEngineDelegate {
    
    // 开始游戏按钮
    var startGameButton: UIButton?
    // 切换先手方按钮
    var settingButton: UIButton?
    // 胜负提示
    var tipLabel = UILabel()
    
    // 为GameViewController类提供一个棋盘属性
    var chessBoard: ChessBoard?
    // 游戏引擎
    var gameEngine: GameEngine?

    override func viewDidLoad() {
        super.viewDidLoad()

        // 为游戏界面添加一个背景图案
        let bgImage = UIImageView(image: UIImage(named: "gameBg"))
        bgImage.frame = self.view.frame

        self.view.addSubview(bgImage)
        self.view.backgroundColor = UIColor.white
        // 构造棋盘对象
        chessBoard = ChessBoard(origin: CGPoint(x: 20, y: 80))
        chessBoard?.center = self.view.center
        // 添加到当前视图
        self.view.addSubview(chessBoard!)
        // 进行游戏引擎的实例化
        gameEngine = GameEngine(board: chessBoard!)
        
        gameEngine!.delegate = self
        
        startGameButton = UIButton(type: .system)
        let startX = CGFloat(40)
        let startY = self.view.frame.size.height - 80
        let startW = self.view.frame.size.width / 2 - 80
        let startH = CGFloat(30)
        startGameButton?.frame = CGRect(x: startX, y: startY, width: startW, height: startH)
        startGameButton?.backgroundColor = UIColor.green
        startGameButton?.setTitle("开始游戏", for: .normal)
        startGameButton?.setTitleColor(.red, for: .normal)
        self.view.addSubview(startGameButton!)
        startGameButton?.addTarget(self, action: #selector(startGame), for: .touchUpInside)
        
        settingButton = UIButton(type: .system)
        let settingX = self.view.frame.size.width / 2 + 40
        let settingY = self.view.frame.size.height - 80
        let settingW = self.view.frame.size.width / 2 - 80
        let settingH = CGFloat(30)
        settingButton?.frame = CGRect(x: settingX, y: settingY, width: settingW, height: settingH)
        settingButton?.setTitle("红方棋子", for: .normal)
        settingButton?.backgroundColor = .green
        settingButton?.setTitleColor(.red, for: .normal)
        self.view.addSubview(settingButton!)
        settingButton?.addTarget(self, action: #selector(settingGame), for: .touchUpInside)
        
        tipLabel.frame = CGRect(x: self.view.frame.size.width / 2 - 100, y: 200, width: 200, height: 60)
        tipLabel.backgroundColor = .clear
        tipLabel.font = UIFont.systemFont(ofSize: 25)
        tipLabel.textColor = UIColor.red
        tipLabel.textAlignment = .center
        tipLabel.isHidden = true
        self.view.addSubview(tipLabel)
        /*
        self.view.backgroundColor = UIColor.white
        
        // 棋子测试
        let item1 = ChessItem(center: CGPoint(x: 100, y: 100))
        item1.setTitle(title: "兵", isOwn: true)
        let item2 = ChessItem(center: CGPoint(x: 200, y: 100))
        item2.setTitle(title:"卒", isOwn: false)
        
        self.view.addSubview(item1)
        self.view.addSubview(item2)
        item1.addTarget(self, action: #selector(itemClick), for: .touchUpInside)
         */
    }
    
    @objc func startGame(btn: UIButton) {
        tipLabel.isHidden = true
        gameEngine?.startGame()
        settingButton?.backgroundColor = .gray
        settingButton?.isEnabled = false
        btn.setTitle("重新开局", for: .normal)
    }
    
    @objc func settingGame(btn: UIButton) {
        if btn.title(for: .normal) == "红方行棋" {
            gameEngine?.setRedFirstMove(red: false)
            btn.setTitle("绿方行棋", for: .normal)
        } else {
            gameEngine?.setRedFirstMove(red: true)
            btn.setTitle("红方行棋", for: .normal)
        }
    }
    

    @objc func itemClick(item: ChessItem) {
        if item.selectedState {
            item.setUnselectedState()
        } else {
            item.setSelectedState()
        }
    }

    func gameOver(redWin: Bool) {
        if redWin {
            tipLabel.text = "红方胜"
            tipLabel.textColor = .red
        } else {
            tipLabel.text = "绿方胜"
            tipLabel.textColor = .green
        }
        tipLabel.isHidden = false
        settingButton?.isEnabled = true
        settingButton?.backgroundColor = .green
    }
    
    func couldRedMove(red: Bool) {
        if red {
            settingButton?.setTitle("红方行棋", for: .normal)
        } else {
            settingButton?.setTitle("绿方行棋", for: .normal)
        }
    }
    
}
