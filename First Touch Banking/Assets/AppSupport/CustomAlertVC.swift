//
//  CustomAlertVC.swift
//  First Touch Banking
//
//  Created by Syed Uzair Ahmed on 23/11/2017.
//  Copyright © 2017 Syed Uzair Ahmed. All rights reserved.
//



import UIKit


typealias CompletionBlock = () -> Void


class CustomAlertVC: UIViewController {
    
    @IBOutlet weak var alertTitleLbl: UILabel!
    @IBOutlet weak var alertDescLbl: UILabel!
    @IBOutlet var btn_Ok: UIButton!
    
    
    var titleStr:String?
    var desStr:String?
    
    var completionBlock:CompletionBlock?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()

        
    }
//    Localized("Continue")
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.btn_Ok.setTitle("Alert Title", for: .normal)
        self.btn_Ok.setTitle("Ok", for: .normal)
    }


    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
    }
    
    
    
    //MARK: - Utility Methods
    private func updateUI() {
        
        if let title = titleStr {
            alertTitleLbl.text = title
        }
        else{
            alertTitleLbl.text = ""
        }
        if let desc = desStr{
            alertDescLbl.text = desc
        }
        else{
            alertDescLbl.text = ""
        }
//        if desStr != nil {
//         alertDescLbl.text = desStr
//        }
//        else {
//            alertDescLbl.attributedText = desStrAtrributed
//        }
    }
    

    
    @IBAction func okButtonPressed(_ sender: UIButton) {
        if self.completionBlock != nil {
            self.completionBlock!()
        }
        self.dismiss(animated: true, completion: nil)
    }

}
