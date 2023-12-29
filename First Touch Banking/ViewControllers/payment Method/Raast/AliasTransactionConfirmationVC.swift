//
//  AliasTransactionConfirmationVC.swift
//  First Touch Banking
//
//  Created by Arsalan Amjad on 31/12/2021.
//  Copyright © 2021 irum Zubair. All rights reserved.
//

import UIKit
import Alamofire
//import AlamofireObjectMapper

class AliasTransactionConfirmationVC: BaseVC
{

   
    override func viewDidLoad() {
        super.viewDidLoad()
       print("DataManager.instance.uniqkey" , DataManager.instance.uniqkey)
        updateui()
        lblmain.text = "Transfer By Raast ID".addLocalizableString(languageCode: languageCode)
        lblSubTitle.text = "Transfer By Raast ID Confirmation".addLocalizableString(languageCode: languageCode)
        btnpay.setTitle("PAY NOW".addLocalizableString(languageCode: languageCode), for:.normal)
        btncancel.setTitle("CANCEL".addLocalizableString(languageCode: languageCode), for:.normal)
        
        
       
        
        
        
        // Do any additional setup after loading the view.
    }
    

    func updateui()
    {
        
        lblSourceAcc.text = DataManager.instance.sourceAccount! 
        lblSourceIBAN.text = DataManager.instance.sourceiban! 
        lblSourceAccTitle.text = DataManager.instance.sourceAccTitle! 
        lblTransferAmount.text = "\(DataManager.instance.transferaliasAmount!).00"
        lblBeneAlias.text = DataManager.instance.benealias! 
        lblBeneAccTitle.text = DataManager.instance.beneficaryAccount! 
        lblBeneIBAN.text = DataManager.instance.bebeiban!
//        if  isFromQR == "true"{
//            lblReason.text =   Qr_transaction_Reason!
//        }
//        else
//        {
//            
//            lblReason.text = DataManager.instance.reason!
//        }
        lblReason.text = DataManager.instance.reason!
        lblBankName.text = DataManager.instance.BeneficiaryBankname!
          
    }
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblmain: UILabel!
    
    @IBOutlet weak var lblSourceIBAN: UILabel!
    @IBOutlet weak var lblSourceAcc: UILabel!
    
    @IBOutlet weak var lblBankName: UILabel!
    @IBOutlet weak var lblBeneAlias: UILabel!
    @IBOutlet weak var lblTransferAmount: UILabel!
    @IBOutlet weak var lblSourceAccTitle: UILabel!
    @IBOutlet weak var lblReason: UILabel!
    @IBOutlet weak var lblBeneAccTitle: UILabel!
    @IBOutlet weak var lblBeneIBAN: UILabel!
    @IBOutlet weak var btnpay: UIButton!
    @IBOutlet weak var btncancel: UIButton!
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
      
    }
    
    @IBAction func paynow(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AliasTransferOTPVC") as! AliasTransferOTPVC
        vc.uniquekeyy = DataManager.instance.uniqkey
//        changepurposeof payment
        vc.Bankname = DataManager.instance.BeneficiaryBankname
        vc.sourceAccount = DataManager.instance.selectedSourceAccount
        vc.transferAmount =  DataManager.instance.transferaliasAmount
//        if isFromQR == "true"
//        {
//            vc.reason =  Qr_transaction_Reason!
//        }
//        else{
//            vc.reason =  DataManager.instance.reason
//        }
        vc.reason =  DataManager.instance.reason
        vc.sourceiban =  DataManager.instance.sourceiban
        vc.sourceAccTitle =  DataManager.instance.sourceAccount
        vc.beneficaryAccount =  DataManager.instance.beneficaryAccount
        vc.benealias =  DataManager.instance.benealias
        vc.bebeiban =  DataManager.instance.bebeiban
        vc.mid =  DataManager.instance.mid
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
//    api fund transfer
    
    
    
    
    
    
    
    
}
