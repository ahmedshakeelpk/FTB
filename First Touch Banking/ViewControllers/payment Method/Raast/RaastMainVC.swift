//
//  RaastMainVC.swift
//  First Touch Banking
//
//  Created by Arsalan Amjad on 30/12/2021.
//  Copyright © 2021 irum Zubair. All rights reserved.
//

import UIKit
var isFromRaast = ""
var isFromQuickPay = ""
var IsFromIBFT = ""

class RaastMainVC: BaseVC {
 
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblmain.text = "IBFT".addLocalizableString(languageCode: languageCode)
        lbl1link.text = "1Link".addLocalizableString(languageCode: languageCode)
        lblRaast.text = "Raast".addLocalizableString(languageCode: languageCode)
        
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var lblRaast: UILabel!
    @IBOutlet weak var lbl1link: UILabel!
    @IBOutlet weak var lblmain: UILabel!
    
    @IBAction func link(_ sender: UIButton) {
        
//        if isFromQuickPay == "true"
//        {
            let quickPayVC = self.storyboard!.instantiateViewController(withIdentifier: "QuickPayVC") as! QuickPayVC
            
            quickPayVC.isFromAddBene = true
            self.navigationController!.pushViewController(quickPayVC, animated: true)
//        }
//        else
//        {
//            let quickPayVC = self.storyboard!.instantiateViewController(withIdentifier: "BenefiaryListVC") as! BenefiaryListVC
//
//            self.navigationController!.pushViewController(quickPayVC, animated: true)
//        }
      
    
        
    }
    

    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
    @IBAction func raast(_ sender: UIButton) {
        if IsFromIBFT == "true" && isFromRaast == "false" && isFromQuickPay == "false"{
//            showDefaultAlert(title: "", message: "Coming Soon")
            let vc = self.storyboard!.instantiateViewController(withIdentifier: "RaastSubViewVc") as!RaastSubViewVc

            self.navigationController!.pushViewController(vc, animated: true)
             
        }
        if isFromQuickPay == "false" && isFromRaast == "true" && IsFromIBFT == "false"
        {
            let vc = self.storyboard!.instantiateViewController(withIdentifier: "RaastSubViewVc") as!RaastSubViewVc

            self.navigationController!.pushViewController(vc, animated: true)
        }
        
        if isFromQuickPay == "true" && isFromRaast == "false" && IsFromIBFT == "false" {
//            showDefaultAlert(title: "", message: "Coming Soon")
            let vc = self.storyboard!.instantiateViewController(withIdentifier: "BenefiaryListVC") as! BenefiaryListVC

            self.navigationController!.pushViewController(vc, animated: true)
        }
        
        
      
        
    }
    
}
