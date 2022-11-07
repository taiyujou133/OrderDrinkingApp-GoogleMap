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
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ice = updateOrderInfo?.iceDegreen
        
        updateOrderDrinkingNameLabel.text = updateOrderInfo?.drinkingName
        if let price = updateOrderInfo?.price {
            updateOrderPriceLabel.text = "\(price)"
        }
        updateOrderIceDegreeSegmentedControl.selectedSegmentIndex = (ice == "正常" ? 0 : ice == "8分冰" ? 1 : 2)
    }

    @IBAction func updateOrderCupStepper(_ sender: UIStepper) {
        let stepperValue = Int(sender.value)
        updateOrderCupTextField.text = String(stepperValue)
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
