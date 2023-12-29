//
//  TouchIDFaceIDEnableVC.swift
//  First Touch Banking
//
//  Created by Syed Uzair Ahmed on 13/03/2019.
//  Copyright © 2019 Syed Uzair Ahmed. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper


class TouchIDFaceIDEnableVC: BaseVC {
    
    var termsAccepted:Bool?
    @IBOutlet weak var checkboxButton: UIButton!

    
    @IBOutlet weak var btnDeActivate: UIButton!
    @IBOutlet weak var btnActivate: UIButton!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var lblDeviceName: UILabel!
    @IBOutlet weak var lblDevice: UILabel!
    @IBOutlet weak var lblMain: UILabel!
    
    @IBOutlet weak var btnTA: UIButton!
    @IBOutlet weak var lblPleaseaccept: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        Changelanguage()
        termsAccepted = false

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Action Methods
    
    func Changelanguage()
    {
        lblMain.text = "Enable Touch ID/Face ID".addLocalizableString(languageCode: languageCode)
        lblDevice.text = "Device Information".addLocalizableString(languageCode: languageCode)
        lblDeviceName.text = "Device Name".addLocalizableString(languageCode: languageCode)
        btnActivate.setTitle("Activate".addLocalizableString(languageCode: languageCode), for: .normal)
        btnDeActivate.setTitle("Deactivate".addLocalizableString(languageCode: languageCode), for: .normal)
        btnTA.setTitle("Terms & Conditions".addLocalizableString(languageCode: languageCode), for: .normal)
        lblPleaseaccept.text = "Please accept Terms & Conditions".addLocalizableString(languageCode: languageCode)
    }
    @IBAction func acceptTermsPressed(_ sender: Any) {
        termsAccepted = !termsAccepted!
        
        if termsAccepted! {
            checkboxButton.setImage(#imageLiteral(resourceName: "checkbox_state2"), for: .normal)
        }
            
        else {
            checkboxButton.setImage(#imageLiteral(resourceName: "checkbox_state1"), for: .normal)
        }
    }
    @IBAction func TermsAndConditionPressed(_ sender: Any) {
        let webVC = self.storyboard?.instantiateViewController(withIdentifier:"WebViewVC") as! WebViewVC
        webVC.forHTML = true
        webVC.forTouchIDTerms = true
        self.navigationController?.pushViewController(webVC, animated: true)
        
    }

    
    @IBAction func activateIDButtonPressed(_ sender: Any) {
        if self.termsAccepted! {
            
            let saveAccountPreview : Bool = KeychainWrapper.standard.set(true, forKey: "enableTouchID")
            print("Successfully Added to KeyChainWrapper \(saveAccountPreview)")
            self.showToast(title: "Successfully Activated".addLocalizableString(languageCode: languageCode))
            
        }
        else{
            self.showDefaultAlert(title: "Terms & Conditions", message: "Please accept Terms & Conditions")
        }
    }
    @IBAction func deActivateIDButtonPressed(_ sender: Any) {
        let unSaveAccountPreview : Bool = KeychainWrapper.standard.set(false, forKey: "enableTouchID")
        print("Successfully Added to KeyChainWrapper \(unSaveAccountPreview)")
        self.showToast(title: "Successfully Deactivated")
        
    }
}
