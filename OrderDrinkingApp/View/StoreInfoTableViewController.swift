//
//  StoreInfoTableViewController.swift
//  OrderDrinkingApp
//
//  Created by Tai on 2022/11/10.
//

import UIKit

class StoreInfoTableViewController: UITableViewController {
    var storeInfo = [StoreInfo.StoreDetail]()

    override func viewDidLoad() {
        super.viewDidLoad()

        fetchStoreInfo()
    }
    
    func fetchStoreInfo() {
        let orgUrl = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=24.1374,120.6869&radius=1000&keyword=春水堂&language=zh-TW&key=AIzaSyAvQBmjA7DwVTiy1zI7xiIEWMxPNzxEJDE"
        //網址有中文字，需進行編碼
        let strUrl = orgUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        var request = URLRequest(url: URL(string: strUrl!)!)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data {
                do {
                    let decoder = JSONDecoder()
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                    decoder.dateDecodingStrategy = .formatted(formatter)
                    let storeInfoDecode = try decoder.decode(StoreInfo.self, from: data)
                    for i in 0...(storeInfoDecode.results.count - 1){
                        self.storeInfo.append(storeInfoDecode.results[i])
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } catch {
                    print(error)
                }
            }
        }.resume()
    }

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
