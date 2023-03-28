//
//  SecondViewController.swift
//  Project_Class
//
//  Created by 蔡濬桔 on 2023/3/28.
//

import UIKit

class SecondViewController: UIViewController {
    
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
    
    @IBAction func BackBtnClick(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func valueChange(_ sender: UISegmentedControl) {
        changeContainHidden(segmentIndex: sender.selectedSegmentIndex)
    }
    
    
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


class SegmentImgVC: UIViewController {
    
    @IBOutlet weak var LabelStatus: UILabel!
    @IBOutlet weak var Swich: UISwitch!
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var Slider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        controlImgView(sliderValue: 14.6)
        setAnimateImgView(count: 4, duration: 5.0)
        ImageView.startAnimating()
    }
    
    @IBAction func valueChange_slider(_ sender: UISlider) {
        controlImgView(sliderValue: sender.value)
    }
    
    @IBAction func valueChange_swich(_ sender: UISwitch) {
        if sender.isOn{
            ImageView.startAnimating()
            LabelStatus.text = "圖片輪播：開啟"
        }
        else{
            ImageView.stopAnimating()
            LabelStatus.text = "圖片輪播：關閉"
        }
    }
    
    func setAnimateImgView(count: Int, duration: Double){
        var imgs = [UIImage]()
        for i in 1...count{
            let name = String(format: "image%02d", i)
            imgs.append(UIImage(named: name)!)
        }
        ImageView.animationImages = imgs
        ImageView.animationDuration = duration * Double(count)
    }
    
    func controlImgView(sliderValue: Float){
        let imgSize = sliderValue * 10
        let loc = calculateImgViewLoc(sliderValue: sliderValue)
        ImageView.frame = CGRect(x: CGFloat(loc[0]), y: CGFloat(loc[1]), width: CGFloat(imgSize), height: CGFloat(imgSize))
    }
    
    func calculateImgViewLoc(sliderValue: Float) -> [Int]{
        let imgSize = Int(sliderValue * 10)
        let LocX = 40
        let LocY = 172
        let oriImgSize = 292
        var calculate = 0
        if imgSize < 292{
            calculate = (oriImgSize - imgSize)/2
        }
        return [calculate + LocX, calculate + LocY]
    }
}
