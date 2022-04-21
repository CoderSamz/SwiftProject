//
//  NoteInfoViewController.swift
//  NoteBook
//  
//  Created by CoderSamz on 2022.
// 	
// 
    

import UIKit
import SnapKit

class NoteInfoViewController: UIViewController {
    
    // 当前编辑的记事数据模型
    var noteModel: NoteModel?
    // 标题文本框
    var titleTextField: UITextField?
    // 记事内容文本视图
    var bodyTextView: UITextView?
    // 记事所属分组
    var group: String?
    var isNew = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // 消除导航对布局的影响
        // Do any additional setup after loading the view.
        // 背景色
        self.view.backgroundColor = .white
        self.title = "记事"
        // 监听键盘事件
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardBeShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardBeHidden), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // 加载界面
        installUI()
        // 加载导航功能按钮
        installNavigationItem()
    }
    
    func installUI() {
        titleTextField = UITextField()
        self.view.addSubview(titleTextField!)
        titleTextField?.borderStyle = .none
        titleTextField?.placeholder = "请输入记事标题"
        titleTextField?.snp.makeConstraints({ make in
            make.top.equalTo(30)
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.height.equalTo(30)
        })
        
        let line = UIView()
        self.view.addSubview(line)
        line.backgroundColor = UIColor.gray
        line.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.top.equalTo(titleTextField!.snp.bottom).offset(5)
            make.right.equalTo(-15)
            make.height.equalTo(0.5)
        }
        
        bodyTextView = UITextView()
        bodyTextView?.layer.borderColor = UIColor.gray.cgColor
        bodyTextView?.layer.borderWidth = 0.5
        self.view.addSubview(bodyTextView!)
        bodyTextView?.snp.makeConstraints { make in
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.top.equalTo(line.snp.bottom).offset(10)
            make.bottom.equalTo(-30)
        }
        
        if !isNew {
            titleTextField?.text = noteModel?.title
            bodyTextView?.text = noteModel?.body
        }
    }

    func installNavigationItem() {
        // 创建两个导航功能按钮，用于保存与删除记事
        let itemSave = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(addNote))
        let itemDelete = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteNote))
        self.navigationItem.rightBarButtonItems = [itemSave, itemDelete]
    }
    
    // 添加记事
    @objc func addNote() {
        // 如果是新建记事，进行数据库新增
        if isNew {
            if titleTextField?.text != nil && titleTextField!.text!.count > 0 {
                noteModel = NoteModel()
                noteModel?.title = titleTextField?.text!
                noteModel?.body = bodyTextView?.text
                // 格式化当前时间
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                noteModel?.time = dateFormatter.string(from: Date())
                noteModel?.group = group
                DataManager.addNote(note: noteModel!)
                self.navigationController!.popViewController(animated: true)
            }
        } else {
            // 进行更新记事逻辑
            if titleTextField?.text != nil && titleTextField!.text!.count > 0 {
//                noteModel = NoteModel()
                noteModel?.title = titleTextField?.text!
                noteModel?.body = bodyTextView?.text
                // 格式化当前时间
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                noteModel?.time = dateFormatter.string(from: Date())
                DataManager.updateNote(note: noteModel!)
                self.navigationController!.popViewController(animated: true)
            }
        }
    }
    
    // 删除记事
    @objc func deleteNote() {
        let alertController = UIAlertController(title: "⚠️警告", message: "您确定要删除此条记事么？", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "删除", style: .destructive) { alertAction in
            if !self.isNew {
                DataManager.deleteNote(note: self.noteModel!)
                self.navigationController!.popViewController(animated: true)
            }
        }
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // 当键盘出现时会调用的方法
    @objc func keyBoardBeShow(notification: Notification) {
        let userInfo = notification.userInfo!
        let frameInfo = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject
        
        // 获得键盘高度
        let height  = frameInfo.cgRectValue.size.height
        // 进行布局更新
        bodyTextView?.snp.updateConstraints { make in
            make.bottom.equalTo(-30 - height)
        }
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    // 当键盘消失时会调用的方法
    @objc func keyBoardBeHidden(notification: Notification) {
        bodyTextView?.snp.updateConstraints { make in
            make.bottom.equalTo(-30)
        }
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }

    }
    
    // 当用户点击屏幕非文本区域时，收起键盘
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        bodyTextView?.resignFirstResponder()
        titleTextField?.resignFirstResponder()
    }
    
    // 在析构方法中移除通知监听
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
