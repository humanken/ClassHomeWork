//
//  PickerViewController.swift
//  Project_Class
//
//  Created by 蔡濬桔 on 2023/4/11.
//

import UIKit

// 繼承 UIPickerViewDateSource, UIPickerViewDelegate
class PickerViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    // 連接並命名 城市/鄉鎮 pickerView
    @IBOutlet weak var cityPickerView: UIPickerView!
    @IBOutlet weak var areaPickerView: UIPickerView!
    
    /*let cityList = ["台北市", "新北市", "桃園市", "台中市", "台南市", "高雄市"]
    let areaListDict = [
        "臺北市": ["松山區", "信義區", "萬華區"],
        "新北市": ["板橋區", "新店區", "林口區"],
        "桃園市": ["中壢區", "大溪區", "蘆竹區"],
        "臺中市": ["北屯區", "沙鹿區", "龍井區"],
        "臺南市": ["新營區", "安定區", "佳里區"],
        "高雄市": ["左營區", "鳳山區", "旗津區"]
    ]*/
    
    // 預設選中的城市 -> ID: "67" (“台南市”)
    let defaultCityID = "67"
    // 建立 城市 的 ID/名稱 陣列
    var cityIDs = [String]()
    var cityNames = [String]()
    // 建立 鄉鎮 的 ID/名稱 字典 -> (key: ID, value: [ID/名稱])
    var areaIDsDict = [String:[String]]()
    var areaNamesDict = [String:[String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 取得 城市 資料(ID/名稱) 並 放入陣列
        let cityData = self.getCityIDsData()
        cityIDs = cityData["id"]!
        cityNames = cityData["name"]!
        
        // 取得 鄉鎮 資料(ID/名稱) 並 放入字典
        let areaData = self.getAreaIDsData()
        areaIDsDict = areaData["id"]!
        areaNamesDict = areaData["name"]!
        
        // 選中 預設選項
        cityPickerView.selectRow(cityIDs.firstIndex(of: defaultCityID)!, inComponent: 0, animated: false)
        
    }
    
    /* 進入下個畫面前 觸發 (必須要有Segue並設定identifier) */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // 前往 WebKit 畫面，傳送目前選中的 城市名稱 and 鄉鎮ID and 鄉鎮名稱
        if segue.identifier == "seguePickerToWeb" {
            let vc = segue.destination as! WebkitViewController
            let citySelectedRow = cityPickerView.selectedRow(inComponent: 0)
            let areaSelectedRow = areaPickerView.selectedRow(inComponent: 0)
            
            vc.areaID = areaIDsDict[cityIDs[citySelectedRow]]![areaSelectedRow]
            
            vc.cityName = cityNames[citySelectedRow]
            vc.areaName = areaNamesDict[cityIDs[citySelectedRow]]![areaSelectedRow]
        }
        // 前往 table 畫面，傳送 城市 and 鄉鎮資料(ID/名稱)
        else if segue.identifier == "seguePickerToTable" {
            let vc = segue.destination as! tableViewController
            vc.cityIDs = cityIDs
            vc.cityNames = cityNames
            vc.areaIDsDict = areaIDsDict
            vc.areaNamesDict = areaNamesDict
        }
    }
    
    /* 指定 pickerView 分幾區 (關鍵字：numberOfComponents)*/
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        // tag 0: 城市 pickerView
        // tag 1: 鄉鎮 pickerView
        if pickerView.tag == 0{
            return 1
        }
        else if pickerView.tag == 1{
            return 1
        }
        else {
            return 0
        }
    }
    
    /* 指定 pickerView 每區有幾筆資料 (關鍵字：numberOfRowsInComponent) */
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0{
            return cityIDs.count
        }
        else if pickerView.tag == 1{
            let citySelectedRow = cityPickerView.selectedRow(inComponent: 0)
            return areaNamesDict[cityIDs[citySelectedRow]]!.count
        }
        else{
            return 0
        }
    }
    
    /* 設定 pickerView 每個 row 的 title (關鍵字：titleForRow) */
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 0{
            return cityNames[row]
        }
        else if pickerView.tag == 1{
            let citySelectedRow = cityPickerView.selectedRow(inComponent: 0)
            return areaNamesDict[cityIDs[citySelectedRow]]![row]
        }
        return nil
    }
    
    /* 選中 pickerView row 觸發 (關鍵字：didSelectRow) */
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 0{
            print("選擇的城市： \(cityNames[row])")
            areaPickerView.reloadComponent(0)
            areaPickerView.selectRow(0, inComponent: 0, animated: false)
        }
        else if pickerView.tag == 1{
            let citySelectedRow = cityPickerView.selectedRow(inComponent: 0)
            print("選擇的地區： \(areaNamesDict[cityIDs[citySelectedRow]]![row])")
        }
    }
    
    /* 取得 城市 ID and 名稱 (資料來源：氣象局)*/
    func getCityIDsData() -> [String:[String]] {
        let urlCity = URL(string: "https://www.cwb.gov.tw/Data/js/info/Info_County.js?v=20200415")
        
        var ids = [String]()
        var names = [String]()
        
        // 建立 訊號
        let finishSignal = DispatchSemaphore(value: 0)
        
        URLSession.shared.dataTask(with: urlCity!) { JSData, response, error in
            if let jsData = JSData {
                // 編碼並轉成字串，用"'ID':"分隔，刪去第一個
                let dataString = String(data: jsData, encoding: .utf8)!
                let data = dataString.components(separatedBy: "'ID':").dropFirst()
                
                for d in data {
                    let split_d = d.split(separator: ",")
                    // 將 "'" 變為 "", trimmingCharacters: 刪去字串前後的空白
                    let id = split_d[0].replacingOccurrences(of: "'", with: "").trimmingCharacters(in: .whitespaces)
                    ids.append(id)
                    
                    let name = split_d[3].split(separator: ":")[2].replacingOccurrences(of: "'", with: "").trimmingCharacters(in: .whitespaces)
                    names.append(name)
                }
                // 完成後, 發出訊號
                finishSignal.signal()
            }
        }.resume()
        // 等待 request 訊號
        finishSignal.wait()
        return ["id": ids, "name": names]
    }
    
    /* 取得 鄉鎮 ID and 名稱 (資料來源：氣象局)*/
    func getAreaIDsData() -> [String:[String:[String]]] {
        let urlCity = URL(string: "https://www.cwb.gov.tw/Data/js/info/Info_Town.js?v=20200817")
    
        var ids = [String:[String]]()
        var names = [String:[String]]()
        
        // 建立 訊號
        let finishSignal = DispatchSemaphore(value: 0)
        
        URLSession.shared.dataTask(with: urlCity!) { JSData, response, error in
            if let jsData = JSData {
                // 編碼並轉成字串，用"'ID':"分隔，刪去第一個
                let dataString = String(data: jsData, encoding: .utf8)!
                let data = dataString.components(separatedBy: " = {")[1].components(separatedBy: "],")
                
                for cityContent in data {
                    let splitCityContent = cityContent.split(separator: ":[")
                    let cityID = splitCityContent[0].replacingOccurrences(of: "'", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
                    
                    var idsContent = [String]()
                    var namesContent = [String]()
                    
                    for areaContent in splitCityContent[1].split(separator: "'ID':").dropFirst() {
                        let split_d = areaContent.split(separator: ",")
                        // 將 "'" 變為 "", trimmingCharacters: 刪去字串前後的空白
                        let id = split_d[0].replacingOccurrences(of: "'", with: "").trimmingCharacters(in: .whitespaces)
                        idsContent.append(id)
                        
                        let name = split_d[1].split(separator: ":")[2].replacingOccurrences(of: "'", with: "").trimmingCharacters(in: .whitespaces)
                        namesContent.append(name)
                    }
                    ids[cityID] = idsContent
                    names[cityID] = namesContent
                }
                // 完成後, 發出訊號
                finishSignal.signal()
            }
        }.resume()
        // 等待 request 訊號
        finishSignal.wait()
        return ["id": ids, "name": names]
    }
}
