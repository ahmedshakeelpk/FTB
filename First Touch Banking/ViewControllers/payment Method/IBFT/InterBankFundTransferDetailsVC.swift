//
//  InterBankFundTransferDetailsVC.swift
//  First Touch Banking
//
//  Created by Syed Uzair Ahmed on 14/12/2017.
//  Copyright © 2017 Syed Uzair Ahmed. All rights reserved.
//

import UIKit

class InterBankFundTransferDetailsVC: BaseVC {
   
    @IBOutlet weak var lblSourceAccountValue: UILabel!
    @IBOutlet weak var lblBeneficaryAccountValue: UILabel!
    @IBOutlet weak var lblBeneAccountTitleValue: UILabel!
    @IBOutlet weak var lblBeneAccountBankValue: UILabel!
    @IBOutlet weak var lblAmountValue: UILabel!
    @IBOutlet weak var lblTransReferenceNumberValue: UILabel!
    @IBOutlet weak var lblTransactionTime: UILabel!
    
    @IBOutlet weak var btnok: UIButton!
    @IBOutlet weak var lblmain: UILabel!
    
    @IBOutlet weak var llblsubTitle: UILabel!
    var sourceAccount:String?
    var beneficaryAccount:String?
    var beneficaryAccountTitle:String?
    var beneficaryBankTitle:String?
    var transferAmount:String?
    var TransRefNumber:String?
    var TransTime:String?
    static let networkManager = NetworkManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        lblmain.text = "IBFT".addLocalizableString(languageCode: languageCode)
        llblsubTitle.text = "IBFT Funds Transfer Successfull".addLocalizableString(languageCode: languageCode)
        btnok.setTitle("OK".addLocalizableString(languageCode: languageCode), for: .normal)
        self.updateUI()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Utility Methods
    
    private func updateUI(){
        
        if let account = sourceAccount{
            self.lblSourceAccountValue.text = account
        }
        if let beneAccount = beneficaryAccount{
            self.lblBeneficaryAccountValue.text = beneAccount
        }
        if let beneAccountTitle = beneficaryAccountTitle{
            self.lblBeneAccountTitleValue.text = beneAccountTitle
        }
        if let beneBankName = beneficaryBankTitle{
            self.lblBeneAccountBankValue.text = beneBankName
        }
        if let Tamount = transferAmount{
            self.lblAmountValue.text = "PKR \(Tamount).00"
        }
        if let transRef = TransRefNumber{
            self.lblTransReferenceNumberValue.text = transRef
        }
        if let transTime = TransTime {
            self.lblTransactionTime.text = transTime
        }
        
        perform(#selector(self.rateService), with: nil, afterDelay: 1)
        
    }
    
    @objc private func rateService(){
        
        let rateUsVC = self.storyboard?.instantiateViewController(withIdentifier: "RateUsVC") as! RateUsVC
        rateUsVC.modalPresentationStyle = .overCurrentContext
        rateUsVC.transactionRef = Int(self.TransRefNumber!)
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
