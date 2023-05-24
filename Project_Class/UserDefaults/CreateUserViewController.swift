//
//  CreateUserViewController.swift
//  Project_Class
//
//  Created by 蔡濬桔 on 2023/5/24.
//

import UIKit

class CreateUserViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameInput: UITextField!
    @IBOutlet weak var nicknameInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var checkPasswordInput: UITextField!
    
    let funcs = customFunc()
    var user: UserDefaults!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameInput.delegate = self
        nicknameInput.delegate = self
        passwordInput.delegate = self
        checkPasswordInput.delegate = self

    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.backgroundColor = .white
    }
    
    @IBAction func btnClick_CreateUser(_ sender: UIButton) {
        /* ------------------------- 建立 訊息框 ------------------------- */
        let usernameAlertCtrl = funcs.alertSetting(title: "帳號不能空白", message: "請重新輸入帳號")
        let nicknameAlertCtrl = funcs.alertSetting(title: "暱稱不能空白", message: "請重新輸入暱稱")
        let passwordAlertCtrl = funcs.alertSetting(title: "密碼不能空白", message: "請重新輸入密碼")
        
        /* ---------------------------- 帳號 ---------------------------- */
        // 檢查 輸入框, 若空白則傳回nil
        let username = funcs.checkInput(self, usernameInput, alert: usernameAlertCtrl)
        // 若是nil, 則結束
        if let username = username {
            // 建立 帳號存在alert
            let alertCtrl = funcs.alertSetting(title: "帳號已存在", message: "此帳號已被創建過", style: .alert)
            // 檢查 帳號是否已存在
            if funcs.isDataExist(self, UserDefaults: user, value: username, forkey: "username", existAlert: alertCtrl) {
                funcs.clearTextField([usernameInput])
                return
            }
        }else { return }
        /* ---------------------------- 暱稱 ---------------------------- */
        // 檢查 輸入框, 若空白則傳回nil
        let nickname = funcs.checkInput(self, nicknameInput, alert: nicknameAlertCtrl)
        // 若是nil, 則結束
        if let nickname = nickname {
            // 建立 暱稱存在alert
            let alertCtrl = funcs.alertSetting(title: "暱稱已存在", message: "此暱稱已被創建過", style: .alert)
            // 檢查 暱稱是否已存在
            if funcs.isDataExist(self, UserDefaults: user, value: nickname, forkey: "username", existAlert: alertCtrl) {
                funcs.clearTextField([nicknameInput])
                return
            }
        }else { return }
        /* ---------------------------- 密碼 ---------------------------- */
        // 檢查 輸入框, 若空白則傳回nil
        let password = funcs.checkInput(self, passwordInput, alert: passwordAlertCtrl)
        // 檢查 輸入框, 若空白則傳回nil
        let checkPassword = funcs.checkInput(self, checkPasswordInput, alert: passwordAlertCtrl)
        // 若是nil, 則結束
        if password == nil || checkPassword == nil { return }
        // 兩次密碼是否相同, 不相同則返回
        if password != checkPassword {
            present(funcs.alertSetting(title: "兩次密碼不相同", message: "請重新輸入密碼", style: .alert), animated: true)
            funcs.clearTextField([passwordInput, checkPasswordInput])
            return
        }
        /* -------------------------- 處存資料 --------------------------- */
        funcs.addDataInUser(username!, UserDefaults: user, forkey: "username")
        funcs.addDataInUser(nickname!, UserDefaults: user, forkey: "nickname")
        funcs.addDataInUser(password!, UserDefaults: user, forkey: "password")
        
        present(
            funcs.alertSetting(
                title: "創建成功",
                message: "帳號已建立，請重新登入",
                style: .alert,
                actionCompletion: {
                    // 關閉 UIViewController視窗
                    self.dismiss(animated: true)
                }),
            animated: true)
    }
    
}
