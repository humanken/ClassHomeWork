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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userInput.delegate = self
        passwordInput.delegate = self

    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.backgroundColor = .white
    }
    
    @IBAction func btnClick_Login(_ sender: Any) {
        var userName = ""
        var passWord = ""
        if let username = checkInput(userInput) {
            userName = username
        }else {
            userInput.backgroundColor = .red
            alertSetting(ctlT: "帳號不能空白", ctlM: "請重新輸入帳號", ctlS: .actionSheet, actT: "確定", actS: .default)
            return
        }
        if let pw = checkInput(passwordInput) {
            passWord = pw
        }else {
            passwordInput.backgroundColor = .red
            alertSetting(ctlT: "密碼不能空白", ctlM: "請重新輸入密碼", ctlS: .actionSheet, actT: "確定", actS: .default)
            return
        }
        let nickname = login(username: userName, password: passWord)
    }
    
    func checkInput(_ textField: UITextField) -> String? {
        let text = textField.text
        if text == "" {
            return nil
        }
        return text
    }
    
    func alertSetting(ctlT title: String, ctlM message: String, ctlS style: UIAlertController.Style, actT actionTitle: String, actS actionStyle: UIAlertAction.Style) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let action = UIAlertAction(title: actionTitle, style: actionStyle)
        
        alertController.addAction(action)
        present(alertController, animated: true)
        return
    }
    
    func login(username: String, password: String) -> String? {
        let usernames = self.user.object(forKey: "username") as? [String]
        let passwords = self.user.object(forKey: "password") as? [String]
        let nicknames = self.user.object(forKey: "nickname") as? [String]
        
        var userIndex = 0
        
        if usernames == nil || ((usernames?.contains(username)) == nil) {
            print("帳號未存在")
            alertSetting(ctlT: "帳號未存在", ctlM: "請創建新帳號", ctlS: .alert, actT: "確定", actS: .default)
            return nil
        }
        else {
            userIndex = (usernames?.firstIndex(of: username))!
        }
        if password != passwords?[userIndex] {
            print("密碼錯誤")
            loginStatus.text = "登入失敗"
            passwordInput.backgroundColor = .systemOrange
            alertSetting(ctlT: "密碼錯誤", ctlM: "請重新輸入密碼", ctlS: .actionSheet, actT: "確定", actS: .default)
            return nil
        }
        else {
            return nicknames![userIndex]
        }
    }

}
