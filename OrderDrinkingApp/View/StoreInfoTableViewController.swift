//
//  StoreInfoTableViewController.swift
//  OrderDrinkingApp
//
//  Created by Tai on 2022/11/10.
//

import UIKit
import GoogleMaps
//import GoogleMapsUtils
//
//class MyMaker: GMSMarker {
//    let markerData: MarkerData // Raw data from server
//
//    init(markerData: MarkerData) {
//        self.markerData = markerData
//        super.init()
//        self.title = markerData.title
//        self.position = markerData.position
//    }
//}
//
//class ClusterItem: NSObject, GMUClusterItem {
//    let markerData: MarkerData // Raw data from server
//    let position: CLLocationCoordinate2D
//
//    init(markerData: MarkerData) {
//        self.markerData = markerData
//        self.position = markerData.position
//    }
//}

class StoreInfoTableViewController: UITableViewController {
    var storeInfo = [StoreInfo.StoreDetail]()
    var storeMapInfo: [MarkerData] = []
//    var clusterManager: GMUClusterManager!

    override func viewDidLoad() {
        super.viewDidLoad()

        fetchStoreInfo()
        
//        MarkerData(position: CLLocationCoordinate2D(latitude: 25.033671, longitude: 121.564427), title: "Taiwan", snippet: "台北101")
        
//        for i in 0...(storeInfo.count - 1) {
//            storeMapInfo.append(MarkerData(position: CLLocationCoordinate2D(latitude: self.storeInfo[i].geometry.location.lat, longitude: self.storeInfo[i].geometry.location.lng), title: "\(self.storeInfo[i].name)", snippet: "台灣"))
//        }
//
//        self.iniMapViewMarker(storeMapInfo)

    }
    
    func fetchStoreInfo() {
        let orgUrl = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=24.1374,120.6869&radius=1000&keyword=春水堂&language=zh-TW&key=AIzaSyDK7dj5GZheIWk_HSbF7Gv7AakP0Vvxro8"
        //網址有中文字，需進行編碼
        let strUrl = orgUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let request = URLRequest(url: URL(string: strUrl!)!)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data {
                do {
                    let decoder = JSONDecoder()
                    let storeInfoDecode = try decoder.decode(StoreInfo.self, from: data)
                    for i in 0...(storeInfoDecode.results.count - 1){
                        self.storeInfo.append(storeInfoDecode.results[i])
                    }
//                    print(self.storeInfo)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
//    private func iniMapViewMarker(_ storeMapInfo: [MarkerData]) {
//        storeMapInfo
//            .map{ MyMaker(markerData: $0) }
//            .forEach {
//                let item = ClusterItem(markerData: $0.markerData)
//                self.clusterManager.add(item)
//            }
//        self.clusterManager.cluster()
//    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return storeInfo.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(StoreInfoTableViewCell.self)", for: indexPath) as! StoreInfoTableViewCell
        
        // Configure the cell...
        cell.storeNameLabel.text = storeInfo[indexPath.row].name
        cell.storeAddressLabel.text = storeInfo[indexPath.row].vicinity
        
        //每一個Cell顯示地圖 台中火車站： 24.13756675158458, 120.68686756709918
        let camera = GMSCameraPosition.camera(withLatitude: 24.13, longitude: 120.68, zoom: 13.0)
        let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
//        cell.mapView.delegate = self
        cell.mapView.isMyLocationEnabled = true
        cell.mapView.addSubview(mapView)
        
        let marker = GMSMarker()
            marker.position = CLLocationCoordinate2DMake(24.13, 120.68)
            marker.title = "Sydney"
            marker.snippet = "Australia"
            marker.map = mapView
        
        cell.mapView.clipsToBounds = true
        cell.mapView.layer.cornerRadius = 5
        
        

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension StoreInfoTableViewController: GMSMapViewDelegate {
    
}
