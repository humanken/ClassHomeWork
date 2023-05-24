//
//  LoginViewController.swift
//  Project_Class
//
//  Created by 蔡濬桔 on 2023/5/23.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var systemTitle: UILabel!
    @IBOutlet weak var loginStatus: UILabel!
    @IBOutlet weak var userInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    
    let user = UserDefaults()
    let funcs = customFunc()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userInput.delegate = self
        passwordInput.delegate = self

    }
    
    /* 透過 Segue 傳送 UserDefaults 物件到 createUserVC */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "homeToCreateUser" {
            let createUserVC = segue.destination as! CreateUserViewController
            createUserVC.user = user
        }
        
    }
    
    /* 輸入框開始編輯(獲取焦點) -> 輸入框背景顏色變白色 */
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.backgroundColor = .white
    }
    
    /* 點擊 登入按鈕 觸發 */
    @IBAction func btnClick_Login(_ sender: Any) {
        
        // --------------------------------------- 帳號 ----------------------------------------
        // 建立 帳號空白消息框
        let usernameAlertCtrl = funcs.alertSetting(title: "帳號不能空白", message: "請重新輸入帳號")
        // 檢查 輸入框是否空白，若空白則返回
        let username = funcs.checkInput(self, userInput, alert: usernameAlertCtrl)
        if username == nil { return }
        
        // --------------------------------------- 密碼 ----------------------------------------
        // 建立 密碼空白消息框
        let passwordAlertCtrl = funcs.alertSetting(title: "密碼不能空白", message: "請重新輸入密碼")
        // 檢查 輸入框是否空白，若空白則返回
        let password = funcs.checkInput(self, passwordInput, alert: passwordAlertCtrl)
        if password == nil { return }
        
        // --------------------------------------- 登入 ----------------------------------------
        if let nickname = login(username: username!, password: password!) {
            loginStatus.text = "登入成功，歡迎\(nickname)"
        }
    }
    
    /* 登入 */
    func login(username: String, password: String) -> String? {
        
        // 帳號索引值
        var userIndex = 0
        
        // --------------------------------------- 帳號 ----------------------------------------
        // 建立 帳號不存在消息框，若不存在帳號則清空輸入框
        let usernameAlertCtrl = funcs.alertSetting(
            title: "帳號未存在",
            message: "請創建新帳號",
            style: .alert,
            actionCompletion: {self.funcs.clearTextField([self.userInput, self.passwordInput])}
        )
        // 判斷 帳號是否已存在 UserDefaults 中
        if funcs.isDataExist(self, UserDefaults: user, value: username, forkey: "username", noExistAlert: usernameAlertCtrl) {
            // 若存在則取得此帳號的索引值
            userIndex = (user.stringArray(forKey: "username")?.firstIndex(of: username))!
        }
        else { return nil }
        // --------------------------------------- 密碼 ----------------------------------------
        // 判斷 輸入密碼 是否與 UserDefaults 中密碼相同
        if password != user.stringArray(forKey: "password")![userIndex] {
            print("密碼錯誤")
            loginStatus.text = "登入失敗"
            passwordInput.backgroundColor = .systemOrange
            present(
                funcs.alertSetting(
                    title: "密碼錯誤",
                    message: "請重新輸入密碼",
                    style: .alert,
                    actionCompletion: {self.funcs.clearTextField([self.passwordInput])}
                ), animated: true)
            return nil
        }
        else {
            // 若輸入相同，登入成功，回傳 此帳號的nickname
            return user.stringArray(forKey: "nickname")![userIndex]
        }
    }

}


/* 自訂函式 */
class customFunc {
    
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
    
    /* 設定消息框 -> 回傳 UIAlertController */
    func alertSetting(title: String, message: String, style: UIAlertController.Style = .actionSheet, actionTitle: String = "確定", actionStyle: UIAlertAction.Style = .default, actionCompletion: @escaping () -> Void = {}) -> UIAlertController {
        
        // 建立 消息框 (alertController 物件)
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        // 建立 消息框按鈕 (alertAction 物件)
        let action = UIAlertAction(title: actionTitle, style: actionStyle) { _ in actionCompletion() }
        // 將 按鈕 加入到 消息框
        alertController.addAction(action)
        
        return alertController
    }
    
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

}
