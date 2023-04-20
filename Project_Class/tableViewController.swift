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
        let vc = storyboard?.instantiateViewController(withIdentifier: "webkitVC") as! WebkitViewController
        
        vc.areaID = areaIDsDict[cityIDs[indexPath.section]]![indexPath.row]
        vc.cityName = cityNames[indexPath.section]
        vc.areaName = areaNamesDict[cityIDs[indexPath.section]]![indexPath.row]
        
        self.show(vc, sender: nil)
    }
    
    /* 點擊 btn 觸發 -> 切換顯示方式(關閉此畫面) */
    @IBAction func btnClickSwitch(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}
