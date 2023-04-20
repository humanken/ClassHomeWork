//
//  SegmentImageConotroller.swift
//  Project_Class
//
//  Created by 蔡濬桔 on 2023/3/29.
//
//  圖像自動切換 控制

import UIKit


class SegmentImageController: UIViewController {
    
    @IBOutlet weak var LabelStatus: UILabel!
    @IBOutlet weak var Swich: UISwitch!
    @IBOutlet weak var ImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 設定 image view 位置與大小
        controlImgView(sliderValue: 14.6)
        // 設定 圖像切換動畫
        setAnimateImgView(count: 4, duration: 5.0)
        // 動畫 啟用
        ImageView.startAnimating()
    }
    
    /* 當 滑桿值 變更 -> 設定 image view 位置與大小 */
    @IBAction func valueChange_slider(_ sender: UISlider) {
        controlImgView(sliderValue: sender.value)
    }
    
    /* 當 開關值 變更 -> 啟用/禁用 輪播計時器 */
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
    
    /* 設定 圖像切換動畫 */
    func setAnimateImgView(count: Int, duration: Double){
        var imgs = [UIImage]()
        for i in 1...count{
            let name = String(format: "image%02d", i)
            imgs.append(UIImage(named: name)!)
        }
        ImageView.animationImages = imgs
        ImageView.animationDuration = duration * Double(count)
    }
    
    /* 設定 image view 位置與大小 */
    func controlImgView(sliderValue: Float){
        let imgSize = sliderValue * 10
        let loc = calculateImgViewLoc(sliderValue: sliderValue)
        ImageView.frame = CGRect(x: CGFloat(loc[0]), y: CGFloat(loc[1]), width: CGFloat(imgSize), height: CGFloat(imgSize))
    }
    
    /* 計算 置中位置 -> 左上角座標 */
    func calculateImgViewLoc(sliderValue: Float) -> [Int]{
        let imgSize = Int(sliderValue * 10)
        // 元件 初始位置 與 初始大小
        let LocX = 40
        let LocY = 172
        let oriImgSize = 292
        
        var calculate = 0
        // 若元件大小 == 原始大小，則calculate = 0
        // 避免用0除報錯
        if imgSize < oriImgSize{
            calculate = (oriImgSize - imgSize)/2
        }
        return [calculate + LocX, calculate + LocY]
    }
}
