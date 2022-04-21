//
//  NoteListController.swift
//  NoteBook
//  
//  Created by CoderSamz on 2022.
// 	
// 
    

import UIKit

private let cellID = "noteListCellID"

class NoteListController: UITableViewController {
    
    // 数据源数组
    var dataArray = Array<NoteModel>()
    // 当前分组
    var name: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.title = name
        // 模拟数据
//        for _ in 0...10 {
//            let model = NoteModel()
//            model.time = "2016.11.11"
//            model.title = "狂欢购物节"
//            model.body = "购物清单......."
//            dataArray.append(model)
//        }
        
        installNavigationItem()
//        dataArray = DataManager.getNote(group: name!)
        // 从数据库中读取记事
        dataArray = DataManager.getNote(group: name!)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dataArray = DataManager.getNote(group: name!)
        self.tableView.reloadData()
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellID)
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: cellID)
        }
        
        let model = dataArray[indexPath.row]
        cell?.textLabel?.text = model.title
        cell?.detailTextLabel?.text = model.time
        cell?.accessoryType = .disclosureIndicator
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 取消当前Cell的选中状态
        tableView.deselectRow(at: indexPath, animated: true)
        
        let infoViewController = NoteInfoViewController()
        infoViewController.group = name!
        infoViewController.isNew = false
        infoViewController.noteModel = dataArray[indexPath.row]
        self.navigationController?.pushViewController(infoViewController, animated: true)
    }

    //
    func installNavigationItem() {
        let addItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))
        let deleteItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteGroup))
        self.navigationItem.rightBarButtonItems = [addItem, deleteItem]
    }
    
    @objc func addNote() {
        let infoViewController = NoteInfoViewController()
        infoViewController.group = name!
        infoViewController.isNew = true
        self.navigationController?.pushViewController(infoViewController, animated: true)
    }
    
    @objc func deleteGroup() {
        let alertController = UIAlertController(title: "⚠️警告", message: "您确定要删除此分组所有记事么？", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "删除", style: .destructive) { alertAction in
            
            DataManager.deleteGroup(name: self.name!)
            self.navigationController!.popViewController(animated: true)
            
        }
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
