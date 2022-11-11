//
//  UpdateOrderTableViewController.swift
//  OrderDrinkingApp
//
//  Created by Tai on 2022/11/7.
//

import UIKit

class UpdateOrderTableViewController: UITableViewController {
    var updateOrderInfo: ChangeToUpdateOrderInfo?
    
    @IBOutlet weak var updateOrderDrinkingNameLabel: UILabel!
    @IBOutlet weak var updateOrderPriceLabel: UILabel!
    @IBOutlet weak var updateOrderIceDegreeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var updateOrderSugarDegreeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var updateOrderCupTextField: UITextField!
    @IBOutlet weak var updateOrderCommentTextView: UITextView!
    @IBOutlet weak var updateOrderUserNameTextField: UITextField!
    @IBOutlet weak var updateOrderUserPhoneTextField: UITextField!
    @IBOutlet weak var updateOrderStepper: UIStepper!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ice = updateOrderInfo?.iceDegreen
        let sugar = updateOrderInfo?.sugarDegreen
        
        updateOrderDrinkingNameLabel.text = updateOrderInfo?.drinkingName
        if let price = updateOrderInfo?.price {
            updateOrderPriceLabel.text = "\(price)"
        }
        
        if ice == "熱飲" {
            updateOrderIceDegreeSegmentedControl.selectedSegmentIndex = 0
            updateOrderIceDegreeSegmentedControl.isEnabled = false
        } else {
            updateOrderIceDegreeSegmentedControl.selectedSegmentIndex = (ice == "正常" ? 0 : ice == "8分冰" ? 1 : 2)
        }

        updateOrderSugarDegreeSegmentedControl.selectedSegmentIndex = (sugar == "正常" ? 0 : sugar == "8分糖" ? 1 : sugar == "5分糖" ? 2 : sugar == "3分糖" ? 3 : 4)
        if let cup = updateOrderInfo?.cupAmount {
            updateOrderCupTextField.text = "\(cup)"
        }
        updateOrderCommentTextView.text = updateOrderInfo?.comment
        updateOrderUserNameTextField.text = updateOrderInfo?.userName
        updateOrderUserPhoneTextField.text = updateOrderInfo?.userPhone
        
        if let cups = updateOrderInfo?.cupAmount {
            updateOrderStepper.value = Double(cups)
        }
        
        updateOrderPriceLabel.clipsToBounds = true
        updateOrderPriceLabel.layer.cornerRadius = 5
        updateOrderCommentTextView.clipsToBounds = true
        updateOrderCommentTextView.layer.cornerRadius = 5
    }

    @IBAction func updateOrderCupStepper(_ sender: UIStepper) {
        updateOrderCupTextField.text = "\(Int(sender.value))"
    }
    
    
    @IBAction func modifyOrderInfoAction(_ sender: Any) {
        let ice = updateOrderIceDegreeSegmentedControl.selectedSegmentIndex
        let sugar = updateOrderSugarDegreeSegmentedControl.selectedSegmentIndex
        
        let name = updateOrderDrinkingNameLabel.text ?? ""
        let price = Int(updateOrderPriceLabel.text!) ?? 0
        let iceDegree = (ice == 0 ? "正常" : ice == 1 ? "8分冰" : "去冰")
        let iceSugarDegree = (sugar == 0 ? "正常" : sugar == 1 ? "8分糖" : sugar == 2 ? "5分糖" : sugar == 3 ? "3分糖" : "無糖")
        let cupAmount = Int(updateOrderCupTextField.text!) ?? 0
        let comment = updateOrderCommentTextView.text ?? ""
        let userName = updateOrderUserNameTextField.text ?? ""
        let userPhone = updateOrderUserPhoneTextField.text ?? ""
        let recordId = updateOrderInfo?.id ?? ""
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        let updateTime = dateFormatter.string(from: Date())
        
        if userName.isEmpty == true || userPhone.isEmpty == true {
            let controller = UIAlertController(title: "欄位空白", message: "請輸入姓名及電話，謝謝", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "確認", style: .default)
            controller.addAction(okAction)
            present(controller, animated: true)
        }
        
        //修改確認
        let controller = UIAlertController(title: "修改確認", message: "請問是否修改?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "確認", style: .default) { _ in
            self.fetchUpdateOrderInfo(name: name, price: price, iceDegree: iceDegree, sugarDegree: iceSugarDegree, cupAmount: cupAmount, comment: comment, userName: userName, userPhone: userPhone, updateTime: updateTime, id: recordId)
        }
        controller.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel)
        controller.addAction(cancelAction)
        present(controller, animated: true)
    }
    
    
    @IBAction func deleteOrderInfoAction(_ sender: Any) {
        let recordId = updateOrderInfo?.id ?? ""
        //刪除確認
        let controller = UIAlertController(title: "刪除確認", message: "請問是否刪除?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "確認", style: .default) { _ in
            self.fetchDeleteOrderInfo(id: recordId)
        }
        controller.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel)
        controller.addAction(cancelAction)
        present(controller, animated: true)
    }
    
    func fetchUpdateOrderInfo(name: String, price: Int, iceDegree: String, sugarDegree: String, cupAmount: Int, comment: String, userName: String, userPhone: String, updateTime: String, id: String) {
        
        let totalAmount = price * cupAmount
        
        let url = URL(string: "https://api.airtable.com/v0/appHy2q9FOUrGGhqS/OrderList/\(id)")!
        let apiKey = "Bearer keyyjw8cP0RNRL7GS"
        let httpHeader = "Authorization"
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue(apiKey, forHTTPHeaderField: httpHeader)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let encoder = JSONEncoder()
        let fieldsData = UpdateOrderInfo.Fields(name: name, price: price, iceDegree: iceDegree, sugarDegree: sugarDegree, cupAmount: cupAmount, comment: comment, userName: userName, userPhone: userPhone, totalAmount: totalAmount, updateTime: updateTime)
        let uploadData = UpdateOrderInfo(fields: fieldsData)
        let data = try? encoder.encode(uploadData)
        request.httpBody = data
        URLSession.shared.dataTask(with: request) { data, response, error in
            if error == nil {
                print("修改成功")
            } else {
                print(error ?? "")
            }
        }.resume()
        
        let controller = UIAlertController(title: "修改通知", message: "己修改完成", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "好的", style: .default)
        controller.addAction(okAction)
        self.present(controller, animated: true)
    }
    
    func fetchDeleteOrderInfo(id: String) {
        
        let url = URL(string: "https://api.airtable.com/v0/appHy2q9FOUrGGhqS/OrderList/\(id)")!
        let apiKey = "Bearer keyyjw8cP0RNRL7GS"
        let httpHeader = "Authorization"
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue(apiKey, forHTTPHeaderField: httpHeader)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        let encoder = JSONEncoder()
//        let fieldsData = UpdateOrderInfo.Fields(name: name, price: price, iceDegree: iceDegree, sugarDegree: sugarDegree, cupAmount: cupAmount, comment: comment, userName: userName, userPhone: userPhone, totalAmount: totalAmount, updateTime: updateTime)
//        let uploadData = UpdateOrderInfo(fields: fieldsData)
//        let data = try? encoder.encode(uploadData)
//        request.httpBody = data
        URLSession.shared.dataTask(with: request) { data, response, error in
            if error == nil {
                print("刪除成功")
            } else {
                print(error ?? "")
            }
        }.resume()
        
        let controller = UIAlertController(title: "刪除通知", message: "己刪除訂單", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "好的", style: .default)
        controller.addAction(okAction)
        self.present(controller, animated: true)
    }
    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
