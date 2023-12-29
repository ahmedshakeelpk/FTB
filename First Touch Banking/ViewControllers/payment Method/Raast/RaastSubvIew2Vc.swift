//
//  RaastSubvIew2Vc.swift
//  First Touch Banking
//
//  Created by Arsalan Amjad on 30/12/2021.
//  Copyright © 2021 irum Zubair. All rights reserved.
//

import UIKit
var isFromRelink = ""
class RaastSubvIew2Vc: UIViewController {
   
    override func viewDidLoad() {
        super.viewDidLoad()
        lblRegisteralias.text = "Register your Rasst ID".addLocalizableString(languageCode: languageCode)
        lblDelinkalias.text = "Delink your Raast ID".addLocalizableString(languageCode: languageCode)
        lblmain.text = "Management".addLocalizableString(languageCode: languageCode)
        lblRelink.text = "Relink your Raast ID".addLocalizableString(languageCode: languageCode)
        // Do any additional setup after loading the view.
    }
    

    
    @IBOutlet weak var lblmain: UILabel!
    
    @IBOutlet weak var lblRegisteralias: UILabel!
    @IBOutlet weak var lblDelinkalias: UILabel!
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBOutlet weak var lblRelink: UILabel!
    @IBAction func Relink(_ sender: UIButton) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "RegisterAliasSuccessVC") as! RegisterAliasSuccessVC
        isFromRelink = "true"
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    @IBAction func delink(_ sender: UIButton) {
        
        
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "DelinkAliasVC") as! DelinkAliasVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

    @IBAction func register(_ sender: UIButton) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "RegisterAliasVC") as! RegisterAliasVC
        self.navigationController?.pushViewController(vc, animated: true)
        
       
    }
}
