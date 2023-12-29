//
//  PrepaidTopUpDetailVC.swift
//  First Touch Banking
//
//  Created by Syed Uzair Ahmed on 12/01/2018.
//  Copyright © 2018 Syed Uzair Ahmed. All rights reserved.
//

import UIKit

class PrepaidTopUpDetailVC: BaseVC {
    
    @IBOutlet weak var lblCompanyNameValue: UILabel!
    @IBOutlet weak var lblMobileNumberValue: UILabel!
    @IBOutlet weak var lblTransferAmountValue: UILabel!
    @IBOutlet weak var lblTransReferenceNumberValue: UILabel!
    @IBOutlet weak var lblTransactionTime: UILabel!
    
    var companyName:String?
    var MobileNumber:String?
    var TransferAmount:String?
    var transRefNumber:String?
    var transTime:String?
    
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblMain: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var viewBottomButtons: UIView!
    static let networkManager = NetworkManager()

    @IBOutlet weak var btnOk: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        lblMain.text = "TOP Up".addLocalizableString(languageCode: languageCode)
        lblSubTitle.text = "Top Up Successful".addLocalizableString(languageCode: languageCode)
        btnOk.setTitle("OK".addLocalizableString(languageCode: languageCode), for: .normal)
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
        if let mobilenumber = self.MobileNumber{
            self.lblMobileNumberValue.text = mobilenumber
        }
        if let amount = self.TransferAmount{
            self.lblTransferAmountValue.text = amount
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
