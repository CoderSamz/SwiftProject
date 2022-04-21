//
//  NoteModel.swift
//  NoteBook
//  
//  Created by CoderSamz on 2022.
// 	
// 
    

import UIKit

class NoteModel: NSObject {
    // 记事时间
    var time: String?
    // 记事标题
    var title: String?
    // 记事内容
    var body: String?
    // 所在分组
    var group: String?
    // 主键
    var noteId: Int?
    
    // 数据模型直接转为字典
    func toDictionary() -> Dictionary<String, Any> {
        var dic: [String: Any] = ["time": time!, "title": title!, "body": body!, "ownGroup": group!]
        if let id = noteId {
            dic["noteId"] = id
        }
        
        return dic
    }
}
