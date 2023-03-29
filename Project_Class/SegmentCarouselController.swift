//
//  SegmentCarouselController.swift
//  Project_Class
//
//  Created by 蔡濬桔 on 2023/3/29.
//

import UIKit


class SegmentCarouselController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var images  = ["image01", "image02", "image03", "image04", "image01"]
    var imageIndex = 0
    var sliderValue: Int = Int(14.6 * 10)
    var timerAnimate: Timer?
    
    @IBOutlet weak var LabelStatus: UILabel!
    @IBOutlet weak var Swich: UISwitch!
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setCollectionViewSize(collectionView: myCollectionView)
        myCollectionView.dataSource = self
        myCollectionView.delegate = self
        timerAnimate = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(changeImg), userInfo: nil, repeats: true)
    }
    
    @IBAction func valueChange_slider(_ sender: UISlider) {
        sliderValue = Int(sender.value * 10)
        self.setCollectionViewSize(collectionView: myCollectionView)
    }
    
    func setCollectionViewSize(collectionView: UICollectionView){
        let imgSize = sliderValue
        let loc = self.calculateLoc()
        
        collectionView.frame = CGRect(x: CGFloat(loc[0]), y: CGFloat(loc[1]), width: CGFloat(imgSize), height: CGFloat(imgSize))
    }
    
    func calculateLoc() -> [Int]{
        let imgSize = sliderValue
        let LocX = 40
        let LocY = 172
        let oriImgSize = 292
        var calculate = 0
        if imgSize < 292{
            calculate = (oriImgSize - imgSize)/2
        }
        return [calculate + LocX, calculate + LocY]
    }
    
    
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
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MyCollectionViewCell
        cell.ImgView.image = UIImage(named: images[indexPath.item])
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}


class MyCollectionViewCell: UICollectionViewCell{
    
    @IBOutlet weak var ImgView: UIImageView!
    
}
