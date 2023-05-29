//
//  UserViewController.swift
//  Project_Class
//
//  Created by 蔡濬桔 on 2023/5/29.
//

import UIKit

class UserViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var user: UserDefaults!
    let funcs = customFunc()
    
    var usernames = [String]()
    var nicknames = [String]()
    var passwords = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    /* 指定 tableView 分隔幾區 (關鍵字：numberOfSections) */
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    /* 指定 tableView 每區有幾筆資料 (關鍵字：numberOfRowsInSection) */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usernames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = nicknames[indexPath.row]
        cell.detailTextLabel?.text = "帳號： \(usernames[indexPath.row])\t密碼：  \(passwords[indexPath.row])"
        return cell
    }
    
    // -------------------------------------- tableView row 滑動事件 ---------------------------------------
    /* 畫面顯示前 觸發 (較容易觸發) -> 設定 tableView 可編輯 */
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    /* 設定 tableView row 滑動事件 */
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete", handler: {(action, view, complete) in
            self.funcs.removeData(in: self.user, self.usernames[indexPath.row])
            self.refreshData()
        })
        deleteAction.backgroundColor = .red
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
    
    func loadData() {
        usernames = user.stringArray(forKey: "username")!
        nicknames = user.stringArray(forKey: "nickname")!
        passwords = user.stringArray(forKey: "password")!
    }
    
    @objc func refreshData() {
        self.loadData()
        tableView.refreshControl?.endRefreshing()
        tableView.reloadData()
    }
}
