//
//  MapDetailViewController.swift
//  OrderDrinkingApp
//
//  Created by Tai on 2022/11/11.
//

import UIKit
import MapKit

class MapDetailViewController: UIViewController {
    var storeMapDeatilInfo: ChangeToStoreInfoDetail?

    @IBOutlet weak var mapDetailStoreNameLabel: UILabel!
    @IBOutlet weak var mapDetailStoreAddressLabel: UILabel!
    @IBOutlet weak var mapDetailView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //每一個Cell顯示地圖 台中火車站： 24.13756675158458, 120.68686756709918
        let detailLocation = CLLocation(latitude: 24.137566, longitude: 120.686867)
        let detailRegion = MKCoordinateRegion(center: detailLocation.coordinate, latitudinalMeters: 250, longitudinalMeters: 250)
        mapDetailView.setRegion(detailRegion, animated: true)
        
        let detailUserLocation = MKPointAnnotation()
        detailUserLocation.title = "目前位置"
        detailUserLocation.coordinate = CLLocationCoordinate2D(latitude: 24.137566, longitude: 120.686867)
        mapDetailView.addAnnotation(detailUserLocation)
        
        mapDetailStoreNameLabel.text = storeMapDeatilInfo?.storeName
        mapDetailStoreAddressLabel.text = storeMapDeatilInfo?.storeAddress
        let lat = storeMapDeatilInfo?.lat ?? 0
        let lng = storeMapDeatilInfo?.lng ?? 0
        let detailStoreLocation = MKPointAnnotation()
        detailStoreLocation.title = "\(String(describing: storeMapDeatilInfo?.storeName))"
        detailStoreLocation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        mapDetailView.addAnnotation(detailStoreLocation)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
