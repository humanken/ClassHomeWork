//
//  MapViewController.swift
//  Project_Class
//
//  Created by 蔡濬桔 on 2023/5/26.
//

import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var searchInput: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManger = CLLocationManager()
    let funcs = customFunc()
    
    // 地圖 起始點
    let defaultPointData = [
        ["title": "奇美醫院", "subTitle": "永康區", "lat": 23.020866, "lon": 120.2195178],
        ["title": "奇美醫院", "subTitle": "佳里區", "lat": 23.1805764, "lon": 120.1814706]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // UserDefaults().set("zh", forKey: "AppleLanguages")
        mapView.delegate = self
        
        // 詢問 地圖權限
        locationManger.delegate = self
        locationManger.requestWhenInUseAuthorization()
        locationManger.startUpdatingLocation()
        
        // 載入 起始點
        loadInit()

    }
    
    /* 點擊 返回按鈕 觸發 */
    @IBAction func btnClick_Back(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    /* 點擊 搜尋按鈕 觸發 */
    @IBAction func btnClick_Search(_ sender: UIButton) {
        // 預設 搜尋資料為 路易莎
        var query = searchInput.text
        if query == "" {
            query = "路易莎"
        }
        // 開始搜尋
        funcs.mapSearch(mapView, query: query) {
            (annotations) in
            // 添加 點註解
            self.funcs.addPointAnnotations(in: self.mapView, annotations)
            // 設定 地圖中心點
            self.mapView.setCenter(self.mapView.annotations.first!.coordinate, animated: true)
        }
    }
    
    /* 載入 初始點 */
    func loadInit() {
        // let annotations = funcs.mapSearch(mapView, query: "路易莎")
        funcs.addPointAnnotations(in: mapView, defaultPointData)
        
        mapView.setRegion(MKCoordinateRegion(center: mapView.annotations.first!.coordinate, latitudinalMeters: 800, longitudinalMeters: 800), animated: false)
    }
    
    /* 更改 點樣式 (關鍵字： viewFor) */
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        var annView = mapView.dequeueReusableAnnotationView(withIdentifier: "pin") as? MKMarkerAnnotationView
        if annView == nil {
            // ### MKPinAnnotationView(annotation: ,reuseIdentifier: ) change to MKMarkerAnnotationView() by ios16.0
            annView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        }
        // 點 背景顏色 (圓形)
        annView?.markerTintColor = .black
        // 點 針顏色
        annView?.glyphTintColor = .green
        
        // annView?.pinTintColor = .orange
        annView?.canShowCallout = true
        return annView
    }
    
}
