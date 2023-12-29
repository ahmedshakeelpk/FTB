//
//  LocalFundsTransferDetailsVC.swift
//  First Touch Banking
//
//  Created by Syed Uzair Ahmed on 14/12/2017.
//  Copyright © 2017 Syed Uzair Ahmed. All rights reserved.
//

import UIKit
import SCLAlertView
class LocalFundsTransferDetailsVC: BaseVC {
    
    @IBOutlet weak var lblSourceAccountValue: UILabel!
    @IBOutlet weak var lblBeneficaryAccountValue: UILabel!
    @IBOutlet weak var lblBeneAccountTitleValue: UILabel!
    @IBOutlet weak var lblAmountValue: UILabel!
    @IBOutlet weak var lblTransReferenceNumberValue: UILabel!
    @IBOutlet weak var lblTransactionTime: UILabel!

    @IBOutlet weak var lblSubtitle: UILabel!
    @IBOutlet weak var lblMain: UILabel!
    
    @IBOutlet weak var btnOk: UIButton!
    var sourceAccount:String?
    var beneficaryAccount:String?
    var beneficaryAccountTitle:String?
    var transferAmount:String?
    var TransRefNumber:String?
    var TransTime:String?
    static let networkManager = NetworkManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        Changelanguage()
        self.updateUI()

        // Do any additional setup after loading the view.
    }

    
    func Changelanguage()
    {
        lblMain.text = "Local Funds Transfer".addLocalizableString(languageCode: languageCode)
        lblSubtitle.text = "Local Funds Transfer Successful".addLocalizableString(languageCode: languageCode)
        btnOk.setTitle("OK".addLocalizableString(languageCode: languageCode), for: .normal)
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func captureScreen() {
        
            var image :UIImage?
            let currentLayer = UIApplication.shared.keyWindow!.layer
            let currentScale = UIScreen.main.scale
            UIGraphicsBeginImageContextWithOptions(currentLayer.frame.size, false, currentScale);
            guard let currentContext = UIGraphicsGetCurrentContext() else {return}
            currentLayer.render(in: currentContext)
            image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            guard let img = image else { return }
            UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil)
            let appearance = SCLAlertView.SCLAppearance(
                showCloseButton: false // if you dont want the close button use false
            )
            let alertView = SCLAlertView(appearance: appearance)
            let button = alertView.addButton("Ok") {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                                              
                self.present(vc,animated:  true)
            }
                                   
            button.backgroundColor = UIColor(red: 60/255, green: 179/255, blue: 113/255, alpha: 1.0)
                                   
            alertView.showCustom("", subTitle: ("Saved to Gallery"), color: UIColor(red: 0.8, green: 0, blue: 0, alpha: 1), icon: #imageLiteral(resourceName: "tick80px"))
           // UtilManager.showAlertMessage(message: "Saved to Gallery", viewController: self)
           
            
            
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
        captureScreen()
    }

}
