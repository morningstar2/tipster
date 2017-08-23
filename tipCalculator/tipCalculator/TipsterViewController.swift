//
//  TipsterViewController.swift
//  tipCalculator
//
//  Created by hienng on 8/22/17.
//  Copyright © 2017 chasingkite. All rights reserved.
//

import UIKit

class TipsterViewController: UIViewController {

    @IBOutlet weak var billAmount: UITextField!
    @IBOutlet weak var totalDueView: UIView!
    @IBOutlet weak var tipControlSegment: UISegmentedControl!
    @IBOutlet weak var splitBetweenStepper: UIStepper!
    @IBOutlet weak var splitBetweenValue: UILabel!
    @IBOutlet weak var tipAmount: UILabel!
    @IBOutlet weak var totalPerPerson: UILabel!
    @IBOutlet weak var billTotal: UILabel!
    
    var currencyFormatter = NumberFormatter()
    var tipPercentages = [15,18,20]
    
    let BILL_AMOUNT = "TIPSTER_BILL_AMOUNT"
    let TIMESTAMP = "TIMESTAMP"
    let FIRST_TIP = "FIRST_TIP"
    let SECOND_TIP = "SECOND_TIP"
    let THIRD_TIP = "THIRD_TIP"
    let MAX_SPLIT = "MAX_SPLIT"
    
    var detailViewRect : CGRect = CGRect.zero

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = Locale(identifier: Locale.current.identifier)
        
        self.splitBetweenStepper.wraps = true
        self.splitBetweenStepper.autorepeat = true
        self.splitBetweenStepper.minimumValue = 1.0
        
        self.billAmount.keyboardType = UIKeyboardType.decimalPad
        
        self.splitBetweenValue.text = Int(self.splitBetweenStepper.minimumValue).description

        // Do any additional setup after loading the view.
        
        let storedValues = retrieveFromStore()
        if storedValues.firstTip == 0 || storedValues.secondTip == 0 || storedValues.thirdTip == 0 {
            saveToStore(15, key: FIRST_TIP)
            saveToStore(18, key: SECOND_TIP)
            saveToStore(20, key: THIRD_TIP)
        }
        if(storedValues.maxSplit == 0){
            saveToStore(10, key: MAX_SPLIT)
        }
        
        //set up to get notified when application enters background
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(TipsterViewController.applicationDidEnterBackground), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        
        let defaults = UserDefaults.standard
        let storedBillAmount = defaults.object(forKey: BILL_AMOUNT) as! String?
        let storedTimestamp = defaults.object(forKey: TIMESTAMP) as! Date?
        self.billAmount.text = nil
        
        if storedTimestamp != nil {
            let elapsedTime = Date().timeIntervalSince(storedTimestamp!)
            let elapsedTimeInMins = elapsedTime / 60
            if elapsedTimeInMins < 10 {  //if the app restarted 10mins or less from the last used, show the stored bill amount
                self.billAmount.text = storedBillAmount
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func applicationDidEnterBackground() {
        
        let lastBill = self.billAmount.text
        let defaults = UserDefaults.standard
        
        defaults.set(lastBill, forKey:BILL_AMOUNT)
        defaults.set(Date(), forKey:TIMESTAMP)
        defaults.synchronize()
    }

    
    
    @IBAction func onSplitBetweenStepChanged(_ sender: UIStepper) {
        
        self.splitBetweenValue.text = Int(sender.value).description
        
        let tipPercentage = tipPercentages[self.tipControlSegment.selectedSegmentIndex]
        let totalPeople = sender.value
        
        if let billAmount = self.billAmount.text {
            tipCalculation(Double(billAmount)!, totalPeople, tipPercentage)
        }
    }
    
    @IBAction func onViewTap(_ sender: Any) {
        view.endEditing(true)
    }
    
    
    @IBAction func onBillAmountChanged(_ sender: AnyObject) {
        
        if(billAmount.text?.isEmpty)!{
            hideTotalDueView()
        }
        else{
            let tipPercentage = tipPercentages[tipControlSegment.selectedSegmentIndex]
            //print("\(tipPercentage)")
            
            if let billAmount = self.billAmount.text {
               let totalPeople = self.splitBetweenStepper.value
                tipCalculation(Double(billAmount)!, totalPeople, tipPercentage)
                
                if(self.totalDueView.isHidden){
                    showTotalDueView()
                }
            }
        }
    }
    
    func tipCalculation(_ billAmount:Double, _ totalPeople:Double, _ tipPercentage:Int){
        
        let tip = (Double(billAmount) * Double(tipPercentage))/100
        let total = Double(billAmount) + Double(tip)
        
        //Updates UI
        self.tipAmount.text = currencyFormatter.string(from: tip as NSNumber)
        self.billTotal.text = currencyFormatter.string(from: total as NSNumber)
        self.totalPerPerson.text = currencyFormatter.string(from: (total/totalPeople) as NSNumber)
    
    }
    
    func hideTotalDueView(){
    
        billAmount.alpha = 0.3
        
        if !(self.totalDueView.isHidden) {
            
            UIView.animate(withDuration: 0.4, animations: {
                
                self.totalDueView.frame = CGRect(x: self.view.frame.maxX, y: self.view.frame.maxY, width: self.detailViewRect.width, height: self.detailViewRect.height)
                self.billAmount.alpha = 1
            
            }, completion: {
                (value: Bool) in
                self.totalDueView.isHidden = true
            })
        }
        
    }
    
    func showTotalDueView(){
        self.totalDueView.isHidden = false
        
        UIView.animate(withDuration: 0.4, animations: {
            self.totalDueView.frame = self.detailViewRect
        })
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let savedValues = retrieveFromStore()
        
        tipControlSegment.setTitle("\(savedValues.firstTip)%", forSegmentAt: 0)
        tipControlSegment.setTitle("\(savedValues.secondTip)%", forSegmentAt: 1)
        tipControlSegment.setTitle("\(savedValues.thirdTip)%", forSegmentAt: 2)
        tipPercentages = [savedValues.firstTip, savedValues.secondTip, savedValues.thirdTip]
        splitBetweenStepper.maximumValue = Double(savedValues.maxSplit)
        
        onBillAmountChanged(NSNull.self)
        
        if !totalDueView.isHidden {
            let tipPercentage = tipPercentages[tipControlSegment.selectedSegmentIndex]
            
            if let billAmount = self.billAmount.text {
                let totalPeople = self.splitBetweenStepper.value
                tipCalculation(Double(billAmount)!, totalPeople, tipPercentage)
            }
        }

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if (self.billAmount.text?.isEmpty)! && self.billAmount.frame.origin.y < 150 {
            hideTotalDueView()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.billAmount.becomeFirstResponder()
    }

}
