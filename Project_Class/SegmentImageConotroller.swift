//
//  SegmentImageConotroller.swift
//  Project_Class
//
//  Created by 蔡濬桔 on 2023/3/29.
//

import UIKit


class SegmentImageController: UIViewController {
    
    @IBOutlet weak var LabelStatus: UILabel!
    @IBOutlet weak var Swich: UISwitch!
    @IBOutlet weak var ImageView: UIImageView!
    
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
            LabelStatus.text = "圖片自動切換：開啟"
        }
        else{
            ImageView.stopAnimating()
            LabelStatus.text = "圖片自動切換：關閉"
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
