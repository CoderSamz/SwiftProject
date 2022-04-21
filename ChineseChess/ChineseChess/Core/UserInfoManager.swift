//
//  UserInfoManager.swift
//  ChineseChess
//  
//  Created by CoderSamz on 2022.
// 	
// 
    

import UIKit

class UserInfoManager: NSObject {

    // 获取用户音频设置状态
    class func getAudioState() -> Bool {
        let isOn = UserDefaults.standard.string(forKey: "audioKey")
        if let on = isOn {
            if on == "on" {
                return true
            } else {
                return false
            }
        }
        return true
    }
    
    // 存储用户音频设置状态
    class func setAudioState(isOn:Bool) {
        if isOn {
            UserDefaults.standard.set("on", forKey: "audioKey")
        } else {
            UserDefaults.standard.set("off", forKey: "audioKey")
        }
        UserDefaults.standard.synchronize()
    }

}
