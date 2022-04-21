//
//  DataManager.swift
//  NoteBook
//  
//  Created by CoderSamz on 2022.
// 	
// 
    

import UIKit
import SQLite

class DataManager: NSObject {
    // 数据库操作对象
    static var sqlHandle: Connection?
    // 是否打开数据库的标记
    static var isOpen = false
    
    // 提供一个对分组数据进行存储的类方法
    class func saveGroup(name: String) {
        // 判断数据库是否打开，如果没有打开，进行打开数据操作
        if !isOpen {
            self.openDataBase()
        }
        
        // 进行数据的插入
        let groupTable = Table("group")
        let groupName = Expression<String?>("groupName")
        let insert = groupTable.insert(groupName <- name)
        let _ = try! sqlHandle?.run(insert)
    }
    
    // 获取所有分组数据的类方法
    class func getGroupData() -> [String] {
        if !isOpen {
            self.openDataBase()
        }
        
        var array = Array<String>()
        let groupTable = Table("group")
        
        // 查询数据操作
        for group in try! sqlHandle!.prepare(groupTable) {
            // 遍历到的数据保存进结果数组
            let name = Expression<String?>("groupName")
            if let n = try? group.get(name) {
                array.append(n)
            }
        }
        return array
    }
    // 添加记事的方法
    class func addNote(note: NoteModel) {
        if !isOpen {
            self.openDataBase()
        }
        // 进行数据的插入
        let noteTable = Table("noteTable")
        let ownGroup = Expression<String?>("ownGroup")
        let body = Expression<String?>("body")
        let title = Expression<String?>("title")
        let time = Expression<String?>("time")
        let insert = noteTable.insert(ownGroup <- note.group, body <- note.body, title <- note.title, time <- note.time)
        let _ = try! sqlHandle?.run(insert)
    }
    
    class func getNote(group: String) -> [NoteModel] {
        if !isOpen {
            self.openDataBase()
        }
        
        // 查询数据
        let noteTable = Table("noteTable")
        var array = Array<NoteModel>()
        let ownGroup = Expression<String?>("ownGroup")
        for note in try! sqlHandle!.prepare(noteTable.filter(ownGroup.like(group))) {
            // 遍历查询数据，并保存到结果数组中
            let ownGroup = Expression<String?>("ownGroup")
            let body = Expression<String?>("body")
            let nId = Expression<Int64>("id")
            let title = Expression<String?>("title")
            let time = Expression<String?>("time")
            let model = NoteModel()
            
            if let n = try? note.get(nId) {
                model.noteId = Int(n)
            }
            if let n = try? note.get(ownGroup) {
                model.group = n
            }
            if let n = try? note.get(body) {
                model.body = n
            }
            if let n = try? note.get(title) {
                model.title = n
            }
            if let n = try? note.get(time) {
                model.time = n
            }
            array.append(model)
        }
        return array
    }
    
    // 打开数据库的方法
    class func openDataBase() {
        // 获取沙盒路径
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        
        // 拼接文件名
        let file = path + "/DataBase.sqlite"
        // 打开数据库，如果不存在就创建
        sqlHandle = try? Connection(file)
        // 创建存储表
        let groupTable = Table("group")
        // 设置字段
        let name = Expression<String?>("groupName")
        let id = Expression<Int64>("id")
        
        // 执行建表
        let _ = try? sqlHandle?.run(groupTable.create(block: { tableBuilder in
            tableBuilder.column(id, primaryKey: true)
            tableBuilder.column(name)
        }))
        
        // 创建记事存储表
        let noteTable = Table("noteTable")
        let nId = Expression<Int64>("id")
        let ownGroup = Expression<String?>("ownGroup")
        let body = Expression<String?>("body")
        let title = Expression<String?>("title")
        let time = Expression<String?>("time")
        // 执行建表
        let _ = try? sqlHandle?.run(noteTable.create(block: { tableBuilder in
            tableBuilder.column(nId, primaryKey: true)
            tableBuilder.column(ownGroup)
            tableBuilder.column(body)
            tableBuilder.column(title)
            tableBuilder.column(time)
        }))
        // 设置数据库打开标志
        isOpen  = true
    }
    
    // 更新一条记事内容
    class func updateNote(note: NoteModel) {
        if !isOpen {
            self.openDataBase()
        }
        
        // 根据主键ID进行更新
        let noteTable = Table("noteTable")
        let nId = Expression<Int64>("id")
        let alice = noteTable.filter(nId == Int64(note.noteId!))
        let ownGroup = Expression<String?>("ownGroup")
        let body = Expression<String?>("body")
        let title = Expression<String?>("title")
        let time = Expression<String?>("time")
        let _ = try? sqlHandle?.run(alice.update(ownGroup <- note.group, body <- note.body, title <- note.title, time <- note.time))
    }
    
    // 删除一条记事
    class func deleteNote(note: NoteModel) {
        if !isOpen {
            self.openDataBase()
        }
        let noteTable = Table("noteTable")
        let nId = Expression<Int64>("id")
        let alice = noteTable.filter(nId == Int64(note.noteId!))
        let _ = try? sqlHandle?.run(alice.delete())
    }
    
    // 删除一个分组，将其下所有记事删除
    class func deleteGroup(name: String) {
        if !isOpen {
            self.openDataBase()
        }
        
        // 首先删除分组下所有记事
        let noteTable = Table("noteTable")
        let ownGroup = Expression<String?>("ownGroup")
        let alice = noteTable.filter(ownGroup == name)
        let _ = try? sqlHandle?.run(alice.delete())
        
        let groupTable = Table("group")
        let gName = Expression<String?>("groupName")
        let gAlice = groupTable.filter(gName == name)
        
        // 再删除分组
        let _ = try? sqlHandle?.run(gAlice.delete())
    }
}
