//
//  PickerViewController.swift
//  Project_Class
//
//  Created by 蔡濬桔 on 2023/4/11.
//

import UIKit

class PickerViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let cityList = ["台北市", "新北市", "桃園市", "台中市", "台南市", "高雄市"]
    let areaList = ["永康區", "安定區", "佳里區"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
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
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0{
            return cityList.count
        }
        else if pickerView.tag == 1{
            return areaList.count
        }
        else{
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 0{
            return cityList[row]
        }
        else if pickerView.tag == 1{
            return areaList[row]
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 0{
            print("選擇的城市： \(cityList[row])")
        }
        else if pickerView.tag == 1{
            print("選擇的地區： \(areaList[row])")
        }
    }

}
