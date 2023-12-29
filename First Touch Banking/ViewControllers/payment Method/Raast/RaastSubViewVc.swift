//
//  RaastSubViewVc.swift
//  First Touch Banking
//
//  Created by Arsalan Amjad on 30/12/2021.
//  Copyright © 2021 irum Zubair. All rights reserved.
//

import UIKit

class RaastSubViewVc: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        lblmain.text = "Raast".addLocalizableString(languageCode: languageCode)
        lblRasstalias.text = "Rasst ID Management".addLocalizableString(languageCode: languageCode)
        lblTransfer.text = "Transfer By Rasst ID".addLocalizableString(languageCode: languageCode)
       
        // Do any additional setup after loading the view.
    }
    

    @IBOutlet weak var lblTransfer: UILabel!
    @IBOutlet weak var lblRasstalias: UILabel!
    @IBOutlet weak var lblmain: UILabel!
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func Rasstaliss(_ sender: UIButton) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "RaastSubvIew2Vc")
        as! RaastSubvIew2Vc
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func TransferbyRast(_ sender: UIButton) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "TransferByAliasVC")
        as! TransferByAliasVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
}
