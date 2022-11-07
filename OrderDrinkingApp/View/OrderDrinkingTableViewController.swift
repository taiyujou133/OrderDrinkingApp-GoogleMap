//
//  OrderDrinkingTableViewController.swift
//  OrderDrinkingApp
//
//  Created by Tai on 2022/11/5.
//

import UIKit
import Kingfisher

class OrderDrinkingTableViewController: UITableViewController {
    var drinkingInfo: ChangeToOrderDrinking?
    @IBOutlet weak var orderDrinkingIceSegmentedControl: UISegmentedControl!
    @IBOutlet weak var orderDrinkingNameLabel: UILabel!
    @IBOutlet weak var orderDrinkingImageView: UIImageView!
    @IBOutlet weak var orderDrinkingPriceLabel: UILabel!
    @IBOutlet weak var orderDrinkingSugarSegmentedControl: UISegmentedControl!
    @IBOutlet weak var orderDringkingCupTextField: UITextField!
    @IBOutlet weak var orderDrinkingCommentTextView: UITextView!
    @IBOutlet weak var orderDrinkingUserNmanTextField: UITextField!
    @IBOutlet weak var orderDrinkingUserPhoneTextField: UITextField!
    
    var name: String = ""
    var price: Int = 0
    var iceDegree: String = ""
    var sugarDegree: String = ""
    var cupAmount: Int = 0
    var comment: String = ""
    var userName: String = ""
    var userPhone: String = ""
    var totalAmount: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //設定要訂購的飲料資訊,前頁傳過來的值
        if let drinkingName = drinkingInfo?.name, let drinkingPrice = drinkingInfo?.price, let drinkImage = drinkingInfo?.image, let iceHotKind = drinkingInfo?.iceHotKind {
                        
            if iceHotKind == "Hot" {
                orderDrinkingIceSegmentedControl.isEnabled = false
                orderDrinkingPriceLabel.backgroundColor = UIColor.orange
            }
            
            orderDrinkingNameLabel.text = drinkingName
            orderDrinkingImageView.kf.setImage(with: URL(string: drinkImage))
            orderDrinkingPriceLabel.text = "\(drinkingPrice)"
        }
    }
    
    @IBAction func orderDrinkingCupStepper(_ sender: UIStepper) {
        let stepperValue = Int(sender.value)
        orderDringkingCupTextField.text = String(stepperValue)
    }
    
    @IBAction func orderDrinkingOrderButtonAction(_ sender: Any) {
        let iceHotKind = drinkingInfo?.iceHotKind
        let ice: Int = orderDrinkingIceSegmentedControl.selectedSegmentIndex
        let sugar: Int = orderDrinkingSugarSegmentedControl.selectedSegmentIndex
        
        self.name = orderDrinkingNameLabel.text!
        self.price = Int(orderDrinkingPriceLabel.text!)!
        self.iceDegree = "\(iceHotKind == "Ice" ? (ice == 0 ? "正常" : ice == 1 ? "8分冰" : "去冰") : "熱飲")"
        self.sugarDegree = "\(sugar == 0 ? "正常" : sugar == 1 ? "8分糖" : sugar == 2 ? "5分糖" : sugar == 3 ? "3分糖" : "無糖")"
        if let cupAmount = orderDringkingCupTextField.text {
            self.cupAmount = Int(cupAmount) ?? 0
        }
        if let comment = orderDrinkingCommentTextView.text {
            self.comment = comment
        }
        self.userName = orderDrinkingUserNmanTextField.text!
        self.userPhone = orderDrinkingUserPhoneTextField.text!
        self.totalAmount = self.price * self.cupAmount
        
        if self.userName.isEmpty == true || userPhone.isEmpty == true {
            let controller = UIAlertController(title: "欄位空白", message: "請輸入姓名及電話，謝謝", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "確認", style: .default)
            controller.addAction(okAction)
            present(controller, animated: true)
        }
        
        //確認訂單
        let controller = UIAlertController(title: "訂單確認", message: "總共 \(self.cupAmount) 杯\n 總金額:\(self.totalAmount)\n請問是否訂購?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "確認", style: .default) { _ in
            self.uploadOrderInfo(name: self.name, price: self.price, iceDegree: self.iceDegree, sugarDegree: self.sugarDegree, cupAmount: self.cupAmount, comment: self.comment, userName: self.userName, userPhone: self.userPhone, totalAmount: self.totalAmount)
        }
        controller.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel)
        controller.addAction(cancelAction)
        present(controller, animated: true)
    }
    
    //上傳訂單資訊
    func uploadOrderInfo(name: String, price: Int, iceDegree: String, sugarDegree: String, cupAmount: Int, comment: String, userName: String, userPhone: String, totalAmount: Int) {
        
        //計算總金額
        self.totalAmount = price * cupAmount
        
        let url = URL(string: "https://api.airtable.com/v0/appHy2q9FOUrGGhqS/OrderList")!
        let apiKey = "Bearer keyyjw8cP0RNRL7GS"
        let httpHeader = "Authorization"
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(apiKey, forHTTPHeaderField: httpHeader)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let encoder = JSONEncoder()
        let fieldsData = UploadOrderData.Fields(name: name, price: price, iceDegree: iceDegree, sugarDegree: sugarDegree, cupAmount: cupAmount, comment: comment, userName: userName, userPhone: userPhone, totalAmount: totalAmount)
        let uploadData = UploadOrderData.Records(fields: fieldsData)
        let data = try? encoder.encode(uploadData)
        request.httpBody = data
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data {
                do {
                    let decoder = JSONDecoder()
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                    decoder.dateDecodingStrategy = .formatted(formatter)
                    let _ = try decoder.decode(OrderInfo.self, from: data)
                } catch {
                    print(error)
                }
            }
        }.resume()
        
        let controller = UIAlertController(title: "訂購通知", message: "己完成訂購，謝謝", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "好的", style: .default)
        controller.addAction(okAction)
        present(controller, animated: true)
    }
    // MARK: - Table view data source

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
