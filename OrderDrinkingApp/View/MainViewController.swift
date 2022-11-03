//
//  MainViewController.swift
//  OrderDrinkingApp
//
//  Created by Tai on 2022/11/3.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    
    @IBOutlet var drinkingContainerViews: [UIView]!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        drinkingContainerViewsChange()
    }
    
    @IBAction func segmentedControlAction(_ sender: UISegmentedControl) {
        
        drinkingContainerViewsChange()
        
    }
    
    func drinkingContainerViewsChange() {
        drinkingContainerViews.forEach {
            $0.isHidden = true
        }
        drinkingContainerViews[segmentedControl.selectedSegmentIndex].isHidden = false
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
