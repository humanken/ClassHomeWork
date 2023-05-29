//
//  finalExamFuncs.swift
//  Project_Class
//
//  Created by 蔡濬桔 on 2023/5/27.
//

import UIKit
import MapKit

/* 自訂函式 */
class customFunc {
    /* ------------------------------------------------------ 輸入框 函式 ------------------------------------------------------ */
    /* 檢查輸入框，是否為空白 */
    func checkInput(_ cls: UIViewController, _ textField: UITextField, alert emptyAlertMessage: UIAlertController) -> String? {
        
        let text = textField.text
        if text == "" {
            // 若空白則將輸入框背景顏色變紅色，彈出消息框 -> 回傳nil
            textField.backgroundColor = .red
            cls.present(emptyAlertMessage, animated: true)
            return nil
        }
        // 否則 -> 回傳 輸入框值
        return text
    }
    
    /* 清空 輸入框 的值 */
    func clearTextField(_ tfs: [UITextField]) { for tf in tfs { tf.text = "" } }
    /* ----------------------------------------------------------------------------------------------------------------------- */
    
    /* ------------------------------------------------------ 消息框 函式 ------------------------------------------------------ */
    /* 設定消息框 -> 回傳 UIAlertController */
    func alertSetting(title: String, message: String, style: UIAlertController.Style = .actionSheet, actions: [[String:Any?]] = [["": nil]]) -> UIAlertController {
        
        // 建立 消息框 (alertController 物件)
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        // 建立 消息框按鈕 (alertAction 物件)
        for act in actions {
            let title = act["title"] as? String ?? "確定"
            let style = act["style"] as? UIAlertAction.Style ?? .default
            let completion = act["completion"] as? () -> Void ?? {}
            
            // 將 按鈕 加入到 消息框
            alertController.addAction(UIAlertAction(title: title, style: style) { _ in completion() } )
        }
        
        return alertController
    }
    /* ----------------------------------------------------------------------------------------------------------------------- */
    
    /* --------------------------------------------------- UserDefaults 函式 -------------------------------------------------- */
    /* 判斷 UserDefaults 指定 key 的 value，是否存在 */
    func isDataExist(_ cls: UIViewController, UserDefaults user: UserDefaults, value: String, forkey key: String, noExistAlert noExistAlertMsg: UIAlertController? = nil, existAlert existAlertMsg: UIAlertController? = nil) -> Bool {
        
        // 取得 資料
        let dataList = user.stringArray(forKey: key)
        print("now key: \(key) in user defaults data: \(String(describing: dataList))")
        // 若 資料 為nil 或 不包含value ，則不存在 -> 回傳 false
        if dataList == nil || ((dataList?.contains(value)) == false) {
            if noExistAlertMsg != nil {
                cls.present(noExistAlertMsg!, animated: true)
            }
            return false
        }
        else {
            if existAlertMsg != nil {
                cls.present(existAlertMsg!, animated: true)
            }
            return true
        }
    }
    
    /* 將 value 存入 UserDefaults 指定的 key */
    func addDataInUser(_ value: String, UserDefaults user: UserDefaults, forkey key: String) {
        
        // 取得 陣列資料
        var dataList = user.stringArray(forKey: key)
        // 若資料為nil，則將資料變為空陣列
        if dataList == nil {
            dataList = []
        }
        // 將 value 添加進 資料
        dataList?.append(value)
        // 依據 key 儲存 資料 到 UserDefaults
        user.set(dataList, forKey: key)
        print("\(key) 已儲存 \(value)")
    }
    /* ----------------------------------------------------------------------------------------------------------------------- */
    
    /* ------------------------------------------------------- 檔案 函式 ------------------------------------------------------ */
    /* 建立 檔案 (檔案內容為： Hello, World!) */
    func createFile(_ fm: FileManager, path filepath: String, name filename: String) {
        if fm.createFile(atPath: "\(filepath)/\(filename).txt", contents: "Hello, World!".data(using: .utf8), attributes: nil) {
            print("建立 \(filename).txt 成功")
        }else {
            print("建立\(filename).txt 失敗")
        }
    }
    
    /* 移動 檔案 */
    func moveFile(_ fm: FileManager, oriPath fileOriPath: String, disPath fileDisPath: String, name filename: String) {
        do {
            try fm.moveItem(atPath: "\(fileOriPath)/\(filename).txt", toPath: "\(fileDisPath)/\(filename).txt")
            print("移動 \(filename).txt 成功")
        } catch {
            print("移動 \(filename).txt 失敗")
        }
    }
    
    /* 刪除 檔案 */
    func deleteFile(_ fm: FileManager, path filepath: String, name filename: String) {
        do {
            try fm.removeItem(atPath: "\(filepath)/\(filename).txt")
            print("刪除 \(filename).txt 成功")
        } catch {
            print("刪除 \(filename).txt 失敗")
        }
    }
    /* ----------------------------------------------------------------------------------------------------------------------- */
    
    /* ------------------------------------------------------- 地圖 函式 ------------------------------------------------------ */
    /* 添加 點註解 到 地圖內 */
    func addPointAnnotations(in map: MKMapView, _ data: [[String:Any]]) {
        var annotations = [MKPointAnnotation]()
        for d in data {
            let ann = MKPointAnnotation()
            ann.title = d["title"] as? String
            if let subTitle = d["subTitle"] as? String {
                ann.subtitle = subTitle
            }
            ann.coordinate = CLLocationCoordinate2D(latitude: d["lat"] as! Double, longitude: d["lon"] as! Double)
            annotations.append(ann)
        }
        map.addAnnotations(annotations)
    }
    
    /* 地圖 搜尋 */
    func mapSearch(_ map: MKMapView, query: String!, handler: @escaping ([[String:Any]]) -> Void = {annotations in }) {
        // 移除 地圖上所有 點註解
        map.removeAnnotations(map.annotations)
        
        var annotations = [[String:Any]]()
        // MKLocalSearchRequest change
        let request = MKLocalSearch.Request()
        // 搜尋關鍵字
        request.naturalLanguageQuery = query
        // 必須等待地圖加載完
        request.region = map.region
        
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            // 請求若有錯誤 或 回傳沒有值，則返回
            guard error == nil else { print("request error: \(error!)"); return}
            guard response != nil else { print("request response: \(response!)"); return}
            
            for item in (response?.mapItems)! {
                let ann = [
                    "title": item.placemark.name as Any,
                    "subTitle": item.placemark.title as Any,
                    "lat": item.placemark.coordinate.latitude,
                    "lon": item.placemark.coordinate.longitude
                ]
                annotations.append(ann)
            }
            handler(annotations)
        }
    }
    
}
