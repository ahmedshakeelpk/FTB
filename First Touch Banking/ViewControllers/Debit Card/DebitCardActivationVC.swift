//
//  DebitCardActivationVC.swift
//  First Touch Banking
//
//  Created by Arsalan Amjad on 26/03/2022.
//  Copyright © 2022 irum Zubair. All rights reserved.
//

import UIKit

class DebitCardActivationVC: BaseVC,UITextFieldDelegate {

    var      account_no : String?
    var   pan : String?
    var   card_id : String?
    var  debit_card_title : String?
    var  card_type : String?
    var status: String?
    var card_expiry_year: String?
    var  card_expiry_month : String?
    var  debit_card_id : Int?
    var userData : [AccountDebitCard] = []
    var accountDebitCardId: String?
    var CardId: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switchc.isHidden = true
        textfiled.isHidden = true
        lblactdec.isHidden = true
//        Convertlanguage()
        btnchange.isHidden = true
        textfiled.delegate = self
        UpdateUI()
//        lblpan.text = pan
//        lblname.text = nibName
        
        
        
        
    }
    
    @IBOutlet weak var lblname: UILabel!
    @IBOutlet weak var lbldate: UILabel!
    @IBOutlet weak var lblpan: UILabel!
    @IBOutlet weak var lblmain: UILabel!
    
    @IBOutlet weak var switchc: UISwitch!
    @IBOutlet weak var textfiled: UITextField!
    
    @IBOutlet weak var lblactdec: UILabel!
    
    
    @IBOutlet weak var btnchange: UIButton!
    
    
    @IBAction func control(_ sender: UISwitch) {
        if self.switchc.isOn{
            switchFlag = true
            self.lblactdec.text = "De-Activate your card".addLocalizableString(languageCode: languageCode)
//            self.debitCardVerificationCall()
//
        }else{
            switchFlag = false
            self.lblactdec.text = "Activate your card".addLocalizableString(languageCode: languageCode)
//            self.debitCardDecCall()
        }
        
    }
    
    
    @IBAction func createpin(_ sender: UIButton) {
        if textfiled.text?.count == 0{
            self.showToast(title: "Please Enter Last 4 Didit Debit Card No")
            return
        }
       
        DataManager.instance.dcLastDigits = textfiled.text
//        self.debitCardVerificationCall()
        
        
    }
    
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newLength = (textField.text?.count)! + string.count - range.length
        
        if textField == textfiled
        { textfiled.isUserInteractionEnabled = true
            return newLength <= 4
       
    }
        return true
    }
    var switchFlag: Bool = false {
            didSet{               //This will fire everytime the value for switchFlag is set
                print(switchFlag) //do something with the switchFlag variable
            }
        }
    func UpdateUI()
    {
        switchFlag = false
        self.switchc.isOn = false
        self.lblactdec.text = "Activate your Card".addLocalizableString(languageCode: languageCode)
        for anObject in self.userData {
            
            if let name = anObject.debit_card_title {
                self.lblname.text = name
            }
            if let pan = anObject.pan {
                self.lblpan.text = pan
            }
            if let month = anObject.card_expiry_month {
                if let year = anObject.card_expiry_year{
                    self.lbldate.text = "\(month)" + "/ \(year)"
                }
            }
            if let status = anObject.status{
                if status == "A" {
                    self.switchc.isOn = false
                    self.lblactdec.text = "Activate your Card".addLocalizableString(languageCode: languageCode)
                    btnchange.isHidden = true
                }
                else{
                    self.switchc.isOn = true
                    btnchange.isHidden = false
                    self.lblactdec.text = "De-Activate your card".addLocalizableString(languageCode: languageCode)
                }
            }
            if let accountID = anObject.debit_card_id{
                self.accountDebitCardId = "\(accountID)"
            }
            if let cardid = anObject.card_id{
                self.CardId = "\(cardid)"
            }
        }
         
    }
    func Convertlanguage()
    {
    lblmain.text = "Card Activation".addLocalizableString(languageCode: languageCode)
    textfiled.placeholder = "Enter 4 Digits Debit Card".addLocalizableString(languageCode: languageCode)
    lblactdec.text = "De-activate your Card".addLocalizableString(languageCode: languageCode)
        btnchange.setTitle("Create/ChangePin".addLocalizableString(languageCode: languageCode), for: .normal)
      
    
    }
    
    
    
    
    
}
