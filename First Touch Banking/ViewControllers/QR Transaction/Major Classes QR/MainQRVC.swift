//
//  MainQRVC.swift
//  First Touch Banking
//
//  Created by Arsalan Amjad on 29/06/2022.
//  Copyright © 2022 irum Zubair. All rights reserved.
//

import UIKit
import CoreVideo

class MainQRVC: BaseVC{
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view.
    }
    

    
    @IBOutlet weak var lblmaintitle: UILabel!
    @IBOutlet weak var btnGenerate: UIButton!
    @IBOutlet weak var btnScan: UIButton!
    @IBOutlet weak var btnRead: UIButton!
    
//    @IBAction func back(_ sender: UIButton) {
//        self.navigationController?.popToRootViewController(animated: true)
//    }
//    
//    
//    
//    @IBAction func Generate(_ sender: UIButton) {
//        
//        let changePassVC = self.storyboard?.instantiateViewController(withIdentifier: "StaticQRVC") as! StaticQRVC
//        self.navigationController?.pushViewController(changePassVC, animated: true)
//        
//    }
//    
//    @IBAction func Read(_ sender: UIButton) {
//        let changePassVC = self.storyboard?.instantiateViewController(withIdentifier: "ReadQRVC") as! ReadQRVC
//        self.navigationController?.pushViewController(changePassVC, animated: true)
//    }
//    
//  
//    @IBAction func Scan(_ sender: UIButton) {
//        let changePassVC = self.storyboard?.instantiateViewController(withIdentifier: "Scan_QRVC") as! Scan_QRVC
//        self.navigationController?.pushViewController(changePassVC, animated: true)
//    }
//    

}
