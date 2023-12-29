//
//  TransactionAliasSuccessfull.swift
//  First Touch Banking
//
//  Created by Arsalan Amjad on 31/12/2021.
//  Copyright © 2021 irum Zubair. All rights reserved.
//

import UIKit
import SCLAlertView
import Nuke
import PDFKit
class TransactionAliasSuccessfull: UIViewController {
   
    override func viewDidLoad() {
        super.viewDidLoad()
        updateui()
        lblmain
            .text = "Transfer By Raast ID Successfull".addLocalizableString(languageCode: languageCode)
        lblSubTitle.text = "Transfer By Raast ID Successfull".addLocalizableString(languageCode: languageCode)
        btnok.setTitle("OK".addLocalizableString(languageCode: languageCode), for: .normal)
        
        
//
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblmain: UILabel!
    @IBOutlet weak var pdfViewContainer: UIView!
    @IBOutlet weak var lblSourceIBAN: UILabel!
    @IBOutlet weak var lblSourceAcc: UILabel!
    
    @IBOutlet weak var lblBeneAlias: UILabel!
    @IBOutlet weak var lblTransferAmount: UILabel!
    @IBOutlet weak var lblSourceAccTitle: UILabel!
    @IBOutlet weak var lblReason: UILabel!
    @IBOutlet weak var lblBeneAccTitle: UILabel!
    @IBOutlet weak var lblBeneIBAN: UILabel!
    @IBOutlet weak var btnok: UIButton!
    @IBOutlet weak var btnshare: UIButton!
    
    @IBOutlet weak var lblbankname: UILabel!
    
    @IBAction func ok(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func share(_ sender: UIButton) {
      
        captureScreen()
        
        
    }
    func savePdf(pdfData:Data?, fileName:String) {
            DispatchQueue.main.async {
                let resourceDocPath = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
                let pdfNameFromUrl = "\(fileName).pdf"
                let actualPath = resourceDocPath.appendingPathComponent(pdfNameFromUrl)
                do {
                    try pdfData?.write(to: actualPath, options: .atomic)
                    print("pdf successfully saved!")
                    print(actualPath)
                } catch {
                    print("Pdf could not be saved")
                }
            }
        }

    
    func updateui()
    {
        lblbankname.text = DataManager.instance.BeneficiaryBankname!
        lblSourceAcc.text = DataManager.instance.sourceAccount!
        lblSourceIBAN.text = DataManager.instance.sourceiban!
        lblSourceAccTitle.text = DataManager.instance.sourceAccTitle!
        lblTransferAmount.text = "\(DataManager.instance.transferAmount ?? "").00"
        lblBeneAlias.text = DataManager.instance.benealias!
        lblBeneAccTitle.text = DataManager.instance.beneficaryAccount!
        lblBeneIBAN.text = DataManager.instance.bebeiban!
        if isFromQR == "true"
        {
            lblReason.text = Qr_transaction_Reason!
        }
        else{
            lblReason.text = DataManager.instance.reason!
        }
       
            
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
//                let vc = self.storyboard?.instantiateViewController(withIdentifier: "TransactionAliasSuccessfull") as! TransactionAliasSuccessfull
//                self.navigationController?.pushViewController(vc, animated: true)
                            }

            button.backgroundColor = UIColor(red: 60/255, green: 128/255, blue: 106/255, alpha: 1.0)

            alertView.showCustom("", subTitle: ("Saved to Gallery"), color: UIColor(red: 60/255, green: 128/255, blue: 106/255, alpha: 1.0), icon: #imageLiteral(resourceName: "logo-1"))
           // UtilManager.showAlertMessage(message: "Saved to Gallery", viewController: self)



        }
    
    
    
}
extension UIApplication {

    var screenshot: UIImage? {
        UIGraphicsBeginImageContextWithOptions(UIScreen.main.bounds.size, false, 0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        for window in windows {
            window.layer.render(in: context)
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

}
