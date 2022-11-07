//
//  OrderListTableViewController.swift
//  OrderDrinkingApp
//
//  Created by Tai on 2022/11/6.
//

import UIKit

class OrderListTableViewController: UITableViewController {
    var loadOrderInfoList = [LoadOrderInfoList.Records]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchOrderInfoList()
    }
    
    func fetchOrderInfoList() {
        let url = URL(string: "https://api.airtable.com/v0/appHy2q9FOUrGGhqS/OrderList")!
        let apiKey = "Bearer keyyjw8cP0RNRL7GS"
        let httpHeader = "Authorization"
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(apiKey, forHTTPHeaderField: httpHeader)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data {
                do {
                    let decoder = JSONDecoder()
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                    decoder.dateDecodingStrategy = .formatted(formatter)
                    let orderInfo = try decoder.decode(LoadOrderInfoList.self, from: data)
                    for i in 0...(orderInfo.records.count - 1){
                        self.loadOrderInfoList.append(orderInfo.records[i])
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

    @IBSegueAction func changeToUpdateOrderInfo(_ coder: NSCoder) -> UpdateOrderTableViewController? {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(OrderListTableViewCell.self)") as! OrderListTableViewCell
        
        let userName = cell.orderInfoUserNameLabel.text!
        let userPhone = cell.orderInfoUserPhoneLabel.text!
        let drinkingName = cell.orderInfoDrinkingNameLabel.text!
        let cupAmount = Int(cell.orderInfoCupAmountLabel.text!)!
        let iceDegreen = cell.orderInfoIceDegreeLabel.text!
        let sugarDegreen = cell.orderInfoSugarDegreeLabel.text!
        let comment = cell.orderInfoCommentTextView.text!
        let price = Double(cell.orderInfoPriceHiddenLabel.text!)!
        
        let controller = UpdateOrderTableViewController(coder: coder)
        controller?.updateOrderInfo = ChangeToUpdateOrderInfo(userName: userName, userPhone: userPhone, drinkingName: drinkingName, cupAmount: cupAmount, iceDegreen: iceDegreen, sugarDegreen: sugarDegreen, comment: comment, price: price)
        return controller
    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return loadOrderInfoList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(OrderListTableViewCell.self)", for: indexPath) as! OrderListTableViewCell
        
        cell.orderInfoUserNameLabel.text = loadOrderInfoList[indexPath.row].fields.userName
        cell.orderInfoUserPhoneLabel.text = loadOrderInfoList[indexPath.row].fields.userPhone
        cell.orderInfoDrinkingNameLabel.text = loadOrderInfoList[indexPath.row].fields.name
        cell.orderInfoCupAmountLabel.text = "\(loadOrderInfoList[indexPath.row].fields.cupAmount)"
        cell.orderInfoIceDegreeLabel.text = loadOrderInfoList[indexPath.row].fields.iceDegree
        cell.orderInfoSugarDegreeLabel.text = loadOrderInfoList[indexPath.row].fields.sugarDegree
        cell.orderInfoOrderTimeLabel.text = "\(loadOrderInfoList[indexPath.row].createdTime)"
        cell.orderInfoCommentTextView.text = loadOrderInfoList[indexPath.row].fields.comment
        cell.orderInfoPriceHiddenLabel.text = "\(Int(loadOrderInfoList[indexPath.row].fields.price))"
//        cell.orderInfoPriceHiddenLabel.isHidden = true
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

    
    // MARK: - Navigation
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    */
}
