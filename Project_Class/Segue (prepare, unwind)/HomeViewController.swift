//
//  ViewController.swift
//  Project_Class
//
//  Created by 蔡濬桔 on 2023/3/28.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var NameInput: UITextField!
    
    @IBOutlet weak var LabelClass: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    /* 進入下個畫面前 觸發 (必須要有Segue並設定identifier) */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "SgHomeToSecond"{
            let secondVC = segue.destination as! SecondViewController
            secondVC.nameFromHomeView = NameInput.text
        }
    }
    
    /* 決定 segue 是否觸發，在 prepare 之前 */
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "SgHomeToSecond"{
            let isInputCurrect = checkInputText(textField: NameInput)
            return isInputCurrect
        }
        return true
    }
    
    /* segue的目的(終點)畫面，負責跳轉 */
    @IBAction func unwind(for segue: UIStoryboardSegue) {
        if segue.identifier == "SgClassToHome"{
            let segClassVC = segue.source as! SegmentClassVC
            if let className = segClassVC.classFromSegClassVC{
                LabelClass.text = "班級：\(className)"
            }
        }
    }
    
    func checkInputText(textField: UITextField) -> Bool{
        let input = textField.text
        if input == ""{
            textField.backgroundColor = .red
            textField.text = "不能空白"
            return false
        }
        else if input == " "{
            textField.backgroundColor = .red
            textField.text = "不能空白"
            return false
        }
        else if input == "不能空白"{
            textField.backgroundColor = .red
            textField.text = "不能空白"
            return false
        }
        return true
    }
        
}

