//
//  AccountPreviewVC.swift
//  First Touch Banking
//
//  Created by Syed Uzair Ahmed on 06/03/2018.
//  Copyright © 2018 Syed Uzair Ahmed. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper


class AccountPreviewVC: BaseVC {

    @IBOutlet weak var btnDeActivate: UIButton!
    @IBOutlet weak var btnActivate: UIButton!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var lblDeviceName: UILabel!
    @IBOutlet weak var lblDevice: UILabel!
    @IBOutlet weak var lblMain: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        Changelanguage()
        // Do Changelanguage()any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func Changelanguage()
    {
        lblMain.text = "Account Preview".addLocalizableString(languageCode: languageCode)
        lblDetail.text = "If you do not login to your account or use the feature for more than 30 days this feature will be disabled automatically".addLocalizableString(languageCode: languageCode)
        lblDevice.text = "Device Information".addLocalizableString(languageCode: languageCode)
        lblDeviceName.text = "Device Name".addLocalizableString(languageCode: languageCode)
        btnActivate.setTitle("Activate".addLocalizableString(languageCode: languageCode), for: .normal)
        btnDeActivate.setTitle("Deactivate".addLocalizableString(languageCode: languageCode), for: .normal)
    }
    // MARK: - Action Methods
    
    @IBAction func activateButtonPressed(_ sender: Any) {
        let saveAccountPreview : Bool = KeychainWrapper.standard.set(true, forKey: "showAccountPreview")
        print("Successfully Added to KeyChainWrapper \(saveAccountPreview)")
        self.showToast(title: "Successfully Activated".addLocalizableString(languageCode: languageCode))
    }
    @IBAction func deActivateButtonPressed(_ sender: Any) {
        let unSaveAccountPreview : Bool = KeychainWrapper.standard.set(false, forKey: "showAccountPreview")
        print("Successfully Added to KeyChainWrapper \(unSaveAccountPreview)")
        self.showToast(title: "Successfully Deactivated")

    }
}
