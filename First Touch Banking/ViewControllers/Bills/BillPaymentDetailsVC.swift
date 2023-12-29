//
//  BillPaymentDetailsVC.swift
//  First Touch Banking
//
//  Created by Syed Uzair Ahmed on 12/01/2018.
//  Copyright © 2018 Syed Uzair Ahmed. All rights reserved.
//

import UIKit

class BillPaymentDetailsVC: BaseVC {
    
    @IBOutlet weak var lblCompanyNameValue: UILabel!
    @IBOutlet weak var lblCustomerNameValue: UILabel!
    @IBOutlet weak var lblBillStatusValue: UILabel!
    @IBOutlet weak var lblPaidAmountValue: UILabel!
    @IBOutlet weak var lblTransReferenceNumberValue: UILabel!
    @IBOutlet weak var lblTransactionTime: UILabel!
    
    
    @IBOutlet weak var lblMain: UILabel!
    
    @IBOutlet weak var lblSubtitle: UILabel!
    var companyName:String?
    var customerName:String?
    var billStatus:String?
    var dueDate:String?
    var paidAmount:String?
    var transRefNumber:String?
    var transTime:String?
    
    @IBOutlet weak var btnok: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var viewBottomButtons: UIView!
    static let networkManager = NetworkManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        lblMain.text = "Bill Payment".addLocalizableString(languageCode: languageCode)
        lblSubtitle.text = "Bill Payment Successful".addLocalizableString(languageCode: languageCode)
        btnok.setTitle("OK".addLocalizableString(languageCode: languageCode), for: .normal)
        self.updateUI()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: (self.viewBottomButtons.frame.origin.y) + (self.viewBottomButtons.frame.size.height) + 50)
    }
    // MARK: - Utility Methods
    
    private func updateUI(){
        
        if let companyName = self.companyName{
            self.lblCompanyNameValue.text = companyName
        }
        if let customerName = self.customerName{
            self.lblCustomerNameValue.text = customerName
        }
//        if let billStatus = self.billStatus{
//            self.lblBillStatusValue.text = billStatus
//        }
        if let status = self.billStatus{
            if status == "U"{
                self.lblBillStatusValue.text = "Unpaid"
            }
            if status == "P"{
                self.lblBillStatusValue.text = "Paid"
            }
            if status == "T"{
                self.lblBillStatusValue.text = "Partial Payment"
            }
            if status == "B"{
                self.lblBillStatusValue.text = "Blocked"
            }
        }

        if let paidAmount = self.paidAmount{
            self.lblPaidAmountValue.text = "PKR \(paidAmount).00"
        }
        if let transRef = self.transRefNumber{
            self.lblTransReferenceNumberValue.text = transRef
        }
        if let transTime = self.transTime {
            self.lblTransactionTime.text = transTime
        }
        
        perform(#selector(self.rateService), with: nil, afterDelay: 1)
        
    }
    
    @objc private func rateService(){
        
        let rateUsVC = self.storyboard?.instantiateViewController(withIdentifier: "RateUsVC") as! RateUsVC
        rateUsVC.modalPresentationStyle = .overCurrentContext
        rateUsVC.transactionRef = Int(self.transRefNumber!)
        self.rootVC?.present(rateUsVC, animated: true, completion: nil)
    }
    
    // MARK: - Action Methods
    @IBAction func okButtonPressed(_ sender: Any) {
        let homeVC = self.storyboard!.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        self.navigationController!.pushViewController(homeVC, animated: true)
    }
    @IBAction func shareButtonPressed(_ sender: Any) {
        
    }
}
