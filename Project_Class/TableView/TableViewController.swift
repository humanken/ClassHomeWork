//
//  tableViewController.swift
//  Project_Class
//
//  Created by 蔡濬桔 on 2023/4/19.
//

import UIKit

// 繼承 UITableViewDateSource, UITableViewDelegate
class tableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // 從 pickerVC 透過segue 傳送的資料
    var cityIDs = [String]()
    var cityNames = [String]()
    var areaIDsDict = [String:[String]]()
    var areaNamesDict = [String:[String]]()

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    /* 指定 tableView 分隔幾區 (關鍵字：numberOfSections) */
    func numberOfSections(in tableView: UITableView) -> Int {
        return cityIDs.count
    }
    
    /* 指定 tableView 每區有幾筆資料 (關鍵字：numberOfRowsInSection) */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return areaIDsDict[cityIDs[section]]!.count
    }
    
    /* 設定 tableView 每區的 header title (關鍵字：titleForHeaderInSection) */
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return cityNames[section]
    }
    
    /* 設定 tableView 每個 row 的 cell (關鍵字：cellForRowAt) */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = areaNamesDict[cityIDs[indexPath.section]]![indexPath.row]
        return cell
    }
    
    /* 選中 tableView row 觸發 (關鍵字：didSelectRowAt) */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "webkitVC") as! WebkitViewController
        
        vc.areaID = areaIDsDict[cityIDs[indexPath.section]]![indexPath.row]
        vc.cityName = cityNames[indexPath.section]
        vc.areaName = areaNamesDict[cityIDs[indexPath.section]]![indexPath.row]
        
        self.show(vc, sender: nil)
    }
    
    @IBOutlet weak var tableView: UITableView!
    /*
    // -------------------------------------- tableView 可拖曳每筆資料 ---------------------------------------
    /* 畫面顯示前 觸發 (較容易觸發) -> 設定 tableView 可編輯 */
    override func viewDidAppear(_ animated: Bool) {
        tableView.isEditing = true
    }
    
    /* 設定 tableView 是否可以移動 */
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    /* 移動 tableView row 後 觸發 */
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let source = areaNamesDict[cityIDs[sourceIndexPath.section]]![sourceIndexPath.row]
    }
    
    /* 設定 tableView cell 可編輯時的樣式 */
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    */
    
    /*
    // -------------------------------------- tableView row 滑動事件 ---------------------------------------
    /* 畫面顯示前 觸發 (較容易觸發) -> 設定 tableView 可編輯 */
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    /* 設定 tableView row 滑動事件 */
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete", handler: {(action, view, complete) in print("test")})
        deleteAction.backgroundColor = .red
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
    */
    
    /* 點擊 btn 觸發 -> 切換顯示方式(關閉此畫面) */
    @IBAction func btnClickSwitch(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}
