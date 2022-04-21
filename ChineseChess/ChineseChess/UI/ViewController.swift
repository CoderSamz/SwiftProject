//
//  ViewController.swift
//  ChineseChess
//  
//  Created by CoderSamz on 2022.
// 	
// 
    

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var musicButton: UIButton!
    @IBOutlet weak var startGame: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .orange
        let le = UITextField(frame: CGRect.zero)
        le.isSecureTextEntry
        // 读取用户音频设置状态
        if UserInfoManager.getAudioState() {
            musicButton.setTitle("音乐：开", for: .normal)
            // 播放音频
            MusicEngine.shareInstance.playBackgroundMusic()
            
        } else {
            musicButton.setTitle("音乐：关", for: .normal)
            // 停止音频
            MusicEngine.shareInstance.stopBackgroundMusic()
        }
    }
    
    @IBAction func startGameClick(_ sender: Any) {
        let gVC = GameViewController()
        gVC.modalPresentationStyle = .overFullScreen
        self.present(gVC, animated: true, completion: nil)
    }
    
    // 切换按钮状态
    @IBAction func musicButtonClick(_ sender: Any) {
        
        if UserInfoManager.getAudioState() {
            musicButton.setTitle("音乐：关", for: .normal)
            UserInfoManager.setAudioState(isOn: false)
            MusicEngine.shareInstance.stopBackgroundMusic()
        } else {
            musicButton.setTitle("音乐：开", for: .normal)
            UserInfoManager.setAudioState(isOn: true)
            MusicEngine.shareInstance.playBackgroundMusic()
        }
    }
    
}

