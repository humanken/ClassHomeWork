//
//  WebkitViewController.swift
//  Project_Class
//
//  Created by 蔡濬桔 on 2023/4/19.
//

import UIKit

// WebKit 不存在 UIKit 內，需要另外import
import WebKit


class WebkitViewController: UIViewController {
    
    // 從 pickerView 透過 segue 傳送的資料
    var areaID: String = ""
    var cityName: String = ""
    var areaName: String = ""
    
    // 連接並命名 標題和網頁顯示
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var webKit: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 設定 標題文字 -> "城市名稱 鄉鎮名稱"
        titleLabel.text = "\(cityName) \(areaName)"
        
        //  載入網頁內容 (傳入 webkit元件 和 鄉鎮ID )
        self.loadHtml(webkit: webKit, ID: areaID)
        
    }
    
    /* 載入網頁 */
    func loadHtml(webkit web: WKWebView, ID id: String) {
        let weatherURL = "https://www.cwb.gov.tw/V8/C/W/Town/Town.html?TID=\(id)"
        let u = URL(string: weatherURL)!
        let request = URLRequest(url: u)
        web.load(request)
    }
    
    /* 點擊 btn 觸發 -> 返回(關閉此畫面) */
    @IBAction func btnClickBack(_ sender: UIButton) {
        webKit.stopLoading()
        self.dismiss(animated: true)
    }
    
}
