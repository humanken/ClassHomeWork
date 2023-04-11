//
//  PickerViewController.swift
//  Project_Class
//
//  Created by 蔡濬桔 on 2023/4/11.
//

import UIKit

class PickerViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var cityPickerView: UIPickerView!
    @IBOutlet weak var areaPickerView: UIPickerView!
    
    var citySelect = "台南市"
    let cityList = ["台北市", "新北市", "桃園市", "台中市", "台南市", "高雄市"]
    let areaListDict = [
        "台北市": ["松山區", "信義區", "萬華區"],
        "新北市": ["板橋區", "新店區", "林口區"],
        "桃園市": ["中壢區", "大溪區", "蘆竹區"],
        "台中市": ["北屯區", "沙鹿區", "龍井區"],
        "台南市": ["新營區", "安定區", "佳里區"],
        "高雄市": ["左營區", "鳳山區", "旗津區"]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cityPickerView.selectRow(cityList.firstIndex(of: citySelect)!, inComponent: 0, animated: false)

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
            return areaListDict[citySelect]!.count
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
            return areaListDict[citySelect]![row]
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 0{
            print("選擇的城市： \(cityList[row])")
            citySelect = cityList[row]
            areaPickerView.reloadComponent(0)
            areaPickerView.selectRow(0, inComponent: 0, animated: false)
        }
        else if pickerView.tag == 1{
            print("選擇的地區： \(areaListDict[citySelect]![row])")
        }
    }

}
