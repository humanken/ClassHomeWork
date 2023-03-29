//
//  SegmentCarouselController.swift
//  Project_Class
//
//  Created by 蔡濬桔 on 2023/3/29.
//
//  圖像輪播 控制

import UIKit


class SegmentCarouselController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var images  = ["image01", "image02", "image03", "image04", "image01"]
    var imageIndex = 0
    var sliderValue: Int = Int(14.6 * 10)
    var timerAnimate: Timer?
    
    @IBOutlet weak var LabelStatus: UILabel!
    @IBOutlet weak var Swich: UISwitch! // 開關
    // 使用 collection view 放入多個圖像
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 設定 collection view 位置與大小
        self.setCollectionViewSize(collectionView: myCollectionView)
        // collection view 初始設定
        myCollectionView.dataSource = self
        myCollectionView.delegate = self
        // 輪播 計時器
        timerAnimate = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(changeImg), userInfo: nil, repeats: true)
    }
    
    /* 當 滑桿值 變更 -> 設定collection view 位置與大小 */
    @IBAction func valueChange_slider(_ sender: UISlider) {
        sliderValue = Int(sender.value * 10)
        self.setCollectionViewSize(collectionView: myCollectionView)
    }
    
    /* 設定collection view 位置與大小 */
    func setCollectionViewSize(collectionView: UICollectionView){
        let imgSize = sliderValue
        // 取得 計算後的左上角座標
        let loc = self.calculateLoc()
        
        collectionView.frame = CGRect(x: CGFloat(loc[0]), y: CGFloat(loc[1]), width: CGFloat(imgSize), height: CGFloat(imgSize))
    }
    
    /* 計算 置中位置 -> 左上角座標 */
    func calculateLoc() -> [Int]{
        let imgSize = sliderValue
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
    
    /* 當 開關值 變更 -> 啟用/禁用 輪播計時器 */
    @IBAction func valueChange_swich(_ sender: UISwitch) {
        if sender.isOn{
            LabelStatus.text = "圖片輪播：開啟"
            timerAnimate = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(changeImg), userInfo: nil, repeats: true)
        }
        else{
            LabelStatus.text = "圖片輪播：關閉"
            timerAnimate?.invalidate()
            timerAnimate = nil
        }
    }
    
    /* 切換圖像 @objc: 給計時器提供#selector用法 */
    @objc func changeImg(){
        imageIndex += 1
        if imageIndex < images.count{
            let indexPath = IndexPath(item: imageIndex, section: 0)
            myCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        }
        else{
            imageIndex = 0
            let indexPath = IndexPath(item: imageIndex, section: 0)
            myCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
            changeImg()
        }
    }
    
    /* 限制 section 數量 -> return 1 */
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    /* 限制 項目 數量 -> return 圖像總數量 */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    /* 控制cell -> return cell */
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MyCollectionViewCell
        cell.ImgView.image = UIImage(named: images[indexPath.item])
        return cell
    }
    
    /* 控制cell大小 -> return collection view大小 */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    
    /* 設定 行間隔 -> return 0 */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    /* 設定 每個item之間的間隔 -> return 0 */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}


/* 自定 collection view cell 類別 */
class MyCollectionViewCell: UICollectionViewCell{
    
    // 命名 UIImageView 元件
    @IBOutlet weak var ImgView: UIImageView!
    
}
