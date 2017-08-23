//
//  SettingsViewController.swift
//  tipCalculator
//
//  Created by hienng on 8/19/17.
//  Copyright © 2017 chasingkite. All rights reserved.
//

import UIKit


class SettingsViewController: UIViewController {

    @IBOutlet weak var firstTipDefault: UIStepper!
    @IBOutlet weak var secondTipDefault: UIStepper!
    @IBOutlet weak var thirdTipDefault: UIStepper!
    @IBOutlet weak var maxSplitBetween: UIStepper!
    
    @IBOutlet weak var firstTipLabel: UILabel!
    @IBOutlet weak var secondTipLabel: UILabel!
    @IBOutlet weak var thirdTipLabel: UILabel!
    @IBOutlet weak var maxSplitBetweenValue: UILabel!
    
    let FIRST_TIP = "FIRST_TIP"
    let SECOND_TIP = "SECOND_TIP"
    let THIRD_TIP = "THIRD_TIP"
    let MAX_SPLIT = "MAX_SPLIT"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    
        let storedValues = retrieveFromStore()
        
        firstTipLabel.text = "\(storedValues.firstTip)"
        secondTipLabel.text = "\(storedValues.secondTip)"
        thirdTipLabel.text = "\(storedValues.thirdTip)"
        maxSplitBetweenValue.text = "\(storedValues.maxSplit)"
        
        firstTipDefault.value = Double(storedValues.firstTip)
        secondTipDefault.value = Double(storedValues.secondTip)
        thirdTipDefault.value = Double(storedValues.thirdTip)
        maxSplitBetween.value = Double(storedValues.maxSplit)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func firstTipStepChanged(_ sender: UIStepper) {
        self.firstTipLabel.text = Int(sender.value).description
        saveToStore(Int(sender.value), key: FIRST_TIP)
    }
    @IBAction func secondTipStepChanged(_ sender: UIStepper) {
        self.secondTipLabel.text = Int(sender.value).description
        saveToStore(Int(sender.value), key: SECOND_TIP)
    }
    
    @IBAction func thirdTipStepChanged(_ sender: UIStepper) {
        self.thirdTipLabel.text = Int(sender.value).description
        saveToStore(Int(sender.value), key: THIRD_TIP)
    
    }
    @IBAction func maxSplitStepChanged(_ sender: UIStepper) {
        self.maxSplitBetweenValue.text = Int(sender.value).description
        saveToStore(Int(sender.value), key: MAX_SPLIT)
    }
    
    func saveToStore(_ value:Int, key:String) {
        let defaults = UserDefaults.standard
        defaults.set(value, forKey:key)
        defaults.synchronize()
    }
    
    func retrieveFromStore() -> (firstTip:Int, secondTip:Int, thirdTip:Int, maxSplit: Int) {
        let defaults = UserDefaults.standard
        let firstTip = defaults.integer(forKey: FIRST_TIP)
        let secondTip = defaults.integer(forKey: SECOND_TIP)
        let thirdTip = defaults.integer(forKey: THIRD_TIP)
        let maxSplit = defaults.integer(forKey: MAX_SPLIT)
        let result = (firstTip:firstTip, secondTip:secondTip, thirdTip:thirdTip, maxSplit: maxSplit)
    
        return result
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
