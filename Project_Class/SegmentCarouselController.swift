//
//  SegmentCarouselController.swift
//  Project_Class
//
//  Created by 蔡濬桔 on 2023/3/29.
//
//  圖像輪播 控制

import UIKit


class SegmentCarouselController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var imgNames  = ["image01", "image02", "image03", "image04", "image01"]
    var imageIndex = 0
    var sliderValue: Int = Int(14.6 * 10)
    var timerAnimate: Timer?
    
    @IBOutlet weak var LabelStatus: UILabel!
    @IBOutlet weak var Swich: UISwitch! // 開關
    // 使用 collection view 放入多個圖像
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // collection view 初始設定
        myCollectionView.dataSource = self
        myCollectionView.delegate = self
        // 設定collection view大小
        myCollectionView.frame.size = CGSize(width: CGFloat(sliderValue), height: CGFloat(sliderValue))
        timerAnimate = startAnimating(for: TimeInterval(3), isRepeat: true)
    }
    
    /* 輪播計時器 開始 -> return Timer */
    func startAnimating(for interval: TimeInterval, isRepeat: Bool) -> Timer{
        let timerObj = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(changeImg), userInfo: nil, repeats: isRepeat)
        return timerObj
    }
    
    /* 輪播計時器 停止 */
    func stopAnimating(_ timer: Timer){
        timer.invalidate()
    }
    
    /* 切換圖像 @objc: 給計時器提供#selector用法 */
    @objc func changeImg(){
        imageIndex += 1
        if imageIndex < imgNames.count{
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
        return imgNames.count
    }
    
    /* 控制cell -> return cell */
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MyCollectionViewCell
        cell.ImgView.image = UIImage(named: imgNames[indexPath.item])
        return cell
    }
    
    /* 控制cell大小 -> return collection view大小 */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        collectionView.center = view.center
        return collectionView.bounds.size
    }
    
    /* 設定 行間隔 -> return 0 */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    /* 設定 每個item之間的間隔 -> return 0 */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    /* 當 滑桿值 變更 -> 設定collection view 位置與大小 */
    @IBAction func valueChange_slider(_ sender: UISlider) {
        sliderValue = Int(sender.value * 10)
        // 設定collection view大小
        myCollectionView.frame.size = CGSize(width: CGFloat(sliderValue), height: CGFloat(sliderValue))
    }
    
    /* 當 開關值 變更 -> 啟用/禁用 輪播計時器 */
    @IBAction func valueChange_swich(_ sender: UISwitch) {
        if sender.isOn{
            LabelStatus.text = "圖片輪播：開啟"
            timerAnimate = self.startAnimating(for: TimeInterval(3), isRepeat: true)
        }
        else{
            LabelStatus.text = "圖片輪播：關閉"
            if let timerAnimate = timerAnimate{
                self.stopAnimating(timerAnimate)
            }
        }
    }
}


/* 自定 collection view cell 類別 */
class MyCollectionViewCell: UICollectionViewCell{
    
    // 命名 UIImageView 元件
    @IBOutlet weak var ImgView: UIImageView!
    
}
