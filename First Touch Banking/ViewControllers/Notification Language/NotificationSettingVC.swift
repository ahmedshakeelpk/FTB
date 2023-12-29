//
//  NotificationSettingVC.swift
//  First Touch Banking
//
//  Created by Irum Zubair on 26/12/2023.
//  Copyright © 2023 irum Zubair. All rights reserved.
//

import UIKit

class NotificationSettingVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        buttonDropdown.setTitle("", for: .normal)
        buttonBack.setTitle("", for: .normal)
        if language != nil{
            labelSelectedlanguage.text  = (language)
        }
        else
        {
            labelSelectedlanguage.text  = "English"
        }
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        if language != nil{
            labelSelectedlanguage.text  = (language)
        }
        else
        {
            labelSelectedlanguage.text  = "English"
        }
    }
    @IBAction func buttonBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBOutlet weak var buttonBack: UIButton!
    
    @IBOutlet weak var labelSelectedlanguage: UILabel!
    
    @IBAction func buttonDropdown(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SelectedlangugaegVc") as! SelectedlangugaegVc
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    @IBOutlet weak var buttonDropdown: UIButton!
    
    
    
}
