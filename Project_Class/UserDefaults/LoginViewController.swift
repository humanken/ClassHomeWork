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
        
        print("Login VC start")
        
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
            loginStatus.text = "登入成功"
            let alertCtrl = funcs.alertSetting(
                title: "登入成功，歡迎 \(nickname)",
                message: "請選擇要前往的頁面",
                style: .alert,
                actions: [
                    ["title": "檔案管理", "completion": {
                        self.present(
                            self.storyboard?.instantiateViewController(withIdentifier: "fileVC") as! FileViewController, animated: true) }],
                    ["title": "地圖展示", "completion": { self.present(
                        self.storyboard?.instantiateViewController(withIdentifier: "mapVC") as! MapViewController, animated: true)}],
                    ["title": "查看帳號資料", "completion": {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "userVC") as! UserViewController
                        vc.user = self.user
                        self.present(vc, animated: true)
                    }]
                ]
            )
            present(alertCtrl, animated: true)
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
            actions: [
                ["completion":{self.funcs.clearTextField([self.userInput, self.passwordInput])}]
            ]
        )
        // 判斷 帳號是否已存在 UserDefaults 中
        if funcs.isDataExist(in: user, self, value: username, forkey: "username", noExistAlert: usernameAlertCtrl) {
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
                    actions: [
                        ["completion":{self.funcs.clearTextField([self.passwordInput])}]
                    ]
                ), animated: true)
            return nil
        }
        else {
            // 若輸入相同，登入成功，回傳 此帳號的nickname
            return user.stringArray(forKey: "nickname")![userIndex]
        }
    }

}
