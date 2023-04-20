//
//  SecondViewController.swift
//  Project_Class
//
//  Created by 蔡濬桔 on 2023/3/28.
//

import UIKit

class SecondViewController: UIViewController {
    
    // 從 HomeVC 透過 segue 傳送的資料
    var nameFromHomeView: String? = nil
    
    @IBOutlet weak var LabelTitle: UILabel!
    @IBOutlet weak var SegmentControl: UISegmentedControl!
    @IBOutlet var ContainVCs: [UIView]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let nameFromHomeView = nameFromHomeView{
            LabelTitle.text = "Hello, \(nameFromHomeView)"
        }
        changeContainHidden(segmentIndex: SegmentControl.selectedSegmentIndex)
    }
    
    /* 點擊 左上角 btn 觸發 -> 返回(關閉此畫面) */
    @IBAction func BackBtnClick(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    /* 點擊 segmented control 觸發 -> 變更 contain view hidden */
    @IBAction func valueChange(_ sender: UISegmentedControl) {
        changeContainHidden(segmentIndex: sender.selectedSegmentIndex)
    }
    
    /* 變更 contain view hidden (傳入 要顯示的索引值) */
    func changeContainHidden(segmentIndex: Int){
        for vc in ContainVCs{
            vc.isHidden = true
        }
        ContainVCs[segmentIndex].isHidden = false
    }
    
}


class SegmentClassVC: UIViewController {
    
    var classFromSegClassVC: String? = nil
    
    @IBOutlet weak var ClassInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func SendBtnClick(_ sender: UIButton) {
        let isInputCorrect = HomeViewController().checkInputText(textField: ClassInput)
        if isInputCorrect{
            classFromSegClassVC = ClassInput.text
        }
    }
}
