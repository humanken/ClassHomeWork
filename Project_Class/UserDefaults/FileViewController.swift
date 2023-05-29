//
//  FileViewController.swift
//  Project_Class
//
//  Created by 蔡濬桔 on 2023/5/25.
//

import UIKit

class FileViewController: UIViewController {

    @IBOutlet weak var filenameInput: UITextField!
    @IBOutlet weak var docLabel: UILabel!
    @IBOutlet weak var tmpLabel: UILabel!
    
    let funcs = customFunc()
    
    let fm = FileManager.default
    var homePath: String!
    var docPath: String!
    var tmpPath: String!
    
    let timerInt = 2.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("File VC start")
        // 設定 檔案位置
        homePath = NSHomeDirectory()
        docPath = homePath + "/Documents"
        tmpPath = homePath + "/tmp"
        
        // 刷新Label
        self.uploadLabels()
    }
    
    /* 點擊 返回按鈕 觸發 */
    @IBAction func btnClick_Back(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    /* 點擊 創建按鈕 觸發 */
    @IBAction func btnClick_Create(_ sender: UIButton) {
        // 檢查 檔案名稱輸入框
        let filename = funcs.checkInput(self, filenameInput, alert: funcs.alertSetting(title: "檔案名稱不能空白", message: "請重新輸入"))
        if filename == nil { return }
        
        // 建立 創建成功 消息框
        let succeedAlertCtrl = funcs.alertSetting(title: "創建成功", message: "已建立 \(filename!).txt 檔案", style: .alert, actions: [])
        // 建立 選擇資料夾 消息框
        let alertCtrl = funcs.alertSetting(title: "請選擇資料夾", message: "將 \(filename!).txt 存入資料夾中",
            actions: [
                ["title": "Documents", "completion": {
                    self.funcs.createFile(self.fm, path: self.docPath, name: filename!)
                    self.present(succeedAlertCtrl, animated: true) { Thread.sleep(forTimeInterval: self.timerInt); self.dismiss(animated: true); self.uploadLabels() }
                }],
                ["title": "tmp", "completion": {
                    self.funcs.createFile(self.fm, path: self.tmpPath, name: filename!)
                    self.present(succeedAlertCtrl, animated: true) { Thread.sleep(forTimeInterval: self.timerInt); self.dismiss(animated: true); self.uploadLabels() }
                }]
            ]
        )
        // 顯示 消息框
        self.present(alertCtrl, animated: true)
    }
    
    /* 點擊 移動按鈕 觸發 */
    @IBAction func btnClick_Move(_ sender: UIButton) {
        // 檢查 檔案名稱輸入框
        let filename = funcs.checkInput(self, filenameInput, alert: funcs.alertSetting(title: "檔案名稱不能空白", message: "請重新輸入"))
        if filename == nil { return }
        // 建立 創建成功 消息框
        
        // 宣告 消息框
        var alertCtrl: UIAlertController!
        // 尋找 檔案存在的資料夾
        switch self.findFilePath(name: filename!) {
            // 存在 Documents，則移動到 tmp
            case docPath :
                funcs.moveFile(fm, oriPath: docPath, disPath: tmpPath, name: filename!)
                alertCtrl = funcs.alertSetting(title: "移動成功", message: "\(filename!).txt 從 Documents 移動到 tmp", actions: [["completion": {self.uploadLabels()}]])
            // 存在 tmp，則移動到 Documents
            case tmpPath :
                funcs.moveFile(fm, oriPath: tmpPath, disPath: docPath, name: filename!)
                alertCtrl = funcs.alertSetting(title: "移動成功", message: "\(filename!).txt 從 tmp 移動到 Documents", actions: [["completion": {self.uploadLabels()}]])
            case nil :
                alertCtrl = funcs.alertSetting(title: "檔案名稱錯誤", message: "資料夾未存在 \(filename!).txt", style: .alert, actions: [["completion": {self.funcs.clearTextField([self.filenameInput])}]])
            // 存在 Documents 和 tmp，則無法移動
            default :
                alertCtrl = funcs.alertSetting(title: "移動失敗", message: "兩個資料夾存在相同檔案名稱", style: .alert)
        }
        // 顯示 消息框
        self.present(alertCtrl, animated: true)
    }
    
    @IBAction func btnClick_Delete(_ sender: UIButton) {
        // 檢查 檔案名稱輸入框
        let filename = funcs.checkInput(self, filenameInput, alert: funcs.alertSetting(title: "檔案名稱不能空白", message: "請重新輸入"))
        if filename == nil { return }
        
        // 建立 創建成功 消息框
        let succeedAlertCtrl = funcs.alertSetting(title: "刪除成功", message: "已刪除 \(filename!).txt 檔案", style: .alert, actions: [])
        
        // 宣告 消息框
        var alertCtrl: UIAlertController!
        // 尋找 檔案存在的資料夾
        switch self.findFilePath(name: filename!) {
            case docPath :
                // 再次確認消息框，完成後動作 (閉包)
                let completion = {
                    self.funcs.deleteFile(self.fm, path: self.docPath, name: filename!)
                    self.present(succeedAlertCtrl, animated: true) {
                        Thread.sleep(forTimeInterval: self.timerInt); self.dismiss(animated: true); self.uploadLabels();
                    }
                }
                // 建立 消息框
                alertCtrl = funcs.alertSetting(
                    title: "再次確認",
                    message: "確定要刪除 Documents 內的 \(filename!).txt 檔案",
                    actions: [
                        ["title": "確定", "completion": completion],
                        ["title": "取消"]
                    ])
            case tmpPath :
                // 再次確認消息框，完成後動作 (閉包)
                let completion = {
                    self.funcs.deleteFile(self.fm, path: self.tmpPath, name: filename!)
                    self.present(succeedAlertCtrl, animated: true) {
                        Thread.sleep(forTimeInterval: self.timerInt); self.dismiss(animated: true); self.uploadLabels();
                    }
                }
                // 建立 消息框
                alertCtrl = funcs.alertSetting(
                    title: "再次確認",
                    message: "確定要刪除 tmp 內的 \(filename!).txt 檔案",
                    actions: [
                        ["title": "確定", "completion": completion],
                        ["title": "取消"]
                    ])
            case nil :
                alertCtrl = funcs.alertSetting(
                    title: "檔案名稱錯誤",
                    message: "資料夾未存在 \(filename!).txt",
                    style: .alert,
                    actions: [
                        ["completion": { self.funcs.clearTextField([self.filenameInput]) }]
                    ])
            // 存在 Documents 和 tmp
            default :
                // ------------------------------ Documents -----------------------------------------
                // 再次確認消息框， 完成後動作 (閉包)
                let docCheckCompletion = {
                    self.funcs.deleteFile(self.fm, path: self.docPath, name: filename!)
                    self.present(succeedAlertCtrl, animated: true) { Thread.sleep(forTimeInterval: self.timerInt); self.dismiss(animated: true); self.uploadLabels();}
                }
                // 選擇資料夾消息框，完成後動作 (閉包)
                let docChoseCompletion = {
                    self.present(
                        self.funcs.alertSetting(
                            title: "再次確認",
                            message: "確定要刪除 Documents 內的 \(filename!).txt 檔案",
                            actions: [
                                ["title": "確定", "completion": docCheckCompletion],
                                ["title": "取消"]
                            ]), animated: true)
                    }
                // ------------------------------- tmp -------------------------------------------
                // 再次確認消息框， 完成後動作 (閉包)
                let tmpCheckCompletion = {
                    self.funcs.deleteFile(self.fm, path: self.tmpPath, name: filename!)
                    self.present(succeedAlertCtrl, animated: true) { Thread.sleep(forTimeInterval: self.timerInt); self.dismiss(animated: true); self.uploadLabels();}
                }
                // 選擇資料夾消息框，完成後動作 (閉包)
                let tmpChoseCompletion = {
                    self.present(
                        self.funcs.alertSetting(
                            title: "再次確認",
                            message: "確定要刪除 tmp 內的 \(filename!).txt 檔案",
                            actions: [
                                ["title": "確定", "completion": tmpCheckCompletion],
                                ["title": "取消"]
                            ]), animated: true)
                }
                // 建立 消息框
                alertCtrl = funcs.alertSetting(
                    title: "請選擇資料夾",
                    message: "將刪除資料夾內 \(filename!).txt 檔案",
                    actions: [
                        ["title": "Documents", "completion": docChoseCompletion],
                        ["title": "tmp", "completion": tmpChoseCompletion]
                    ])
        }
        // 顯示 消息框
        self.present(alertCtrl, animated: true)
    }
    
    /* 重新載入 資料夾內檔案，刷新Label */
    func uploadLabels() {
        var docText = "目前 Documents 內檔案：\n"
        do {
            for f in try fm.contentsOfDirectory(atPath: docPath) {
                docText += "\(f)\n"
            }
        } catch {
            docText = "更新檔案 錯誤"
        }
        docLabel.text = docText
        
        var tmpText = "目前 tmp 內檔案：\n"
        do {
            for f in try fm.contentsOfDirectory(atPath: tmpPath) {
                tmpText += "\(f)\n"
            }
        } catch {
            tmpText = "更新檔案 錯誤"
        }
        tmpLabel.text = tmpText
    }
    
    /* 尋找 檔案位於 Documents 或 tmp 資料夾 */
    func findFilePath(name: String) -> String? {
        do {
            let docs = try fm.contentsOfDirectory(atPath: docPath)
            let tmps = try fm.contentsOfDirectory(atPath: tmpPath)
            if docs.contains("\(name).txt") && tmps.contains("\(name).txt") {
                return "all"
            }
            else if docs.contains("\(name).txt") {
                return docPath
            }
            else if tmps.contains("\(name).txt") {
                return tmpPath
            }
            else { return nil }
        } catch {
            return nil
        }
    }

}
