//
//  ViewController.swift
//  NoteBook
//  
//  Created by CoderSamz on 2022.
// 	
// 
    

import UIKit

class ViewController: UIViewController, HomeButtonDelegate {
    
    var homeView: HomeView?
    var dataArray: Array<String>?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dataArray = DataManager.getGroupData()
        self.homeView?.dataArray = dataArray
        self.homeView?.updateLayout()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        handleNavigationBar()
        
        self.title = "点滴生活"
        
        // 取消导航栏对页面的影响
        self.edgesForExtendedLayout = UIRectEdge()
//        dataArray = DataManager.getGroupData()
//        
//        if dataArray?.count == 0 {
//            dataArray = ["dd", "sss"]
//        }
        self.installUI()
        
    }

    func installUI() {
        
        homeView = HomeView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - 64))
        self.view.addSubview(homeView!)
        
        homeView?.dataArray = dataArray
        homeView?.updateLayout()
        homeView?.homeButtonDelegate = self
        
        // 创建导航功能按钮
        installNavigationItem()
    }

    /// 处理导航栏颜色在iOS 15上的问题
    func handleNavigationBar() {
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .orange
            appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            navigationController?.navigationBar.standardAppearance = appearance;
            navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        
        }
    }
    
    func installNavigationItem() {
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addGroup))
        self.navigationItem.rightBarButtonItem = barButtonItem
    }
    
    @objc func addGroup() {
        let alertController = UIAlertController(title: "添加记事分组", message: "添加的分组名不能与已有分组重复或为空", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "请输入记事分组名称"
        }
        
        let alertItem = UIAlertAction(title: "取消", style: .cancel) { alertAction in
            return
        }
        
        let alertItemAdd = UIAlertAction(title: "确定", style: .default) { alertAction in
            var exist = false
            self.dataArray?.forEach({ element in
                if element == alertController.textFields?.first!.text || alertController.textFields?.first!.text?.count == 0 {
                    exist = true
                }
            })
            
            if exist {
                return
            }
            
            self.dataArray?.append(alertController.textFields!.first!.text!)
            self.homeView?.dataArray = self.dataArray
            self.homeView?.updateLayout()
            // 将添加的分组写入数据库
            DataManager.saveGroup(name: alertController.textFields!.first!.text!)
        }
        
        alertController.addAction(alertItem)
        alertController.addAction(alertItemAdd)
        alertController.view.translatesAutoresizingMaskIntoConstraints = false
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - HomeButtonDelegate
    func homeButtonClick(title: String) {
        let controller = NoteListController()
        controller.name = title
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

