//
//  MyLoanVC.swift
//  First Touch Banking
//
//  Created by Syed Uzair Ahmed on 30/07/2018.
//  Copyright © 2018 Syed Uzair Ahmed. All rights reserved.
//

import UIKit
import Alamofire
//import AlamofireObjectMapper
import SwiftKeychainWrapper
import ObjectMapper

class MyLoanVC: BaseVC, UITableViewDelegate , UITableViewDataSource {
    
    var loanInfoObj: MyLoanInformation?
    var loanInformationList = [SingleLoanInformation]()
    @IBOutlet weak var loanInformationTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.getLoanInfo()
    
        lblmain.text = "My Loans".addLocalizableString(languageCode: languageCode)

        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var lblmain: UILabel!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table View Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //            if let count = self.agentObj?.agentLocators?.count {
        //                return count
        //            }
        
        return self.loanInformationList.count
        
        //return (self.notificationsObj?.notifications?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let aCell = tableView.dequeueReusableCell(withIdentifier: "MyLoanTableViewCell") as! MyLoanTableViewCell
        
        aCell.selectionStyle = .none
        aCell.backview.dropShadow1()
        if let prodCode = self.loanInformationList[indexPath.row].prod_name{
            aCell.lblproductName.text = prodCode
        }
        if let disbDate = self.loanInformationList[indexPath.row].disb_date{
            aCell.lbldisburtionDate.text = disbDate
        }
        if let amountFinanced = self.loanInformationList[indexPath.row].amount_financed{
            aCell.lblamountFinanced.text = amountFinanced
        }
        if let outstandingAmount = self.loanInformationList[indexPath.row].outstanding_amount{
            aCell.lbloutstandingAmount.text = outstandingAmount
        }
        if let loanStatus = self.loanInformationList[indexPath.row].loan_status{
            if loanStatus == "Active"{
                aCell.lblLoanStatus.textColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            }
            else{
                aCell.lblLoanStatus.textColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            }
            aCell.lblLoanStatus.text = loanStatus
        }
        
        return aCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        NSLog ("You selected row: %@ \(indexPath)")
        
        let aValue:SingleLoanInformation = (self.loanInfoObj?.loanInformation![indexPath.row])!
        
        print("\(aValue.account_number)")
        
        let myLoanFurtherInfoVC = self.storyboard?.instantiateViewController(withIdentifier: "MyLoanFurtherInfoVC") as! MyLoanFurtherInfoVC
        myLoanFurtherInfoVC.accountNumber = aValue.account_number
        
        self.navigationController!.pushViewController(myLoanFurtherInfoVC, animated: true)
    }
    

    // MARK: - API CALL
    
    
    private func getLoanInfo() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        var userCnic : String?
        
        if KeychainWrapper.standard.hasValue(forKey: "userCnic"){
            userCnic = KeychainWrapper.standard.string(forKey: "userCnic")
        }
        
        let compelteUrl = Constants.BASE_URL + "api/v1/Loans/LoanProductInformation/\(userCnic!)"
        //      let compelteUrl = Constants.BASE_URL + "/api/v1/Loans/LoanProductInformation/4220111094244"
        
        let header: HTTPHeaders = ["Accept":"application/json","Authorization":"Bearer \(DataManager.instance.accessToken!)"]
        
        print(header)
        print(compelteUrl)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .get, encoding: URLEncoding.httpBody, headers:header).response { response in
            //            Object { (response: DataResponse<MyLoanInformation>) in
            //        Alamofire.request(compelteUrl, headers:header).responseObject { (response: DataResponse<MyLoanInformation>) in
            
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                if response.response?.statusCode == 200 {
                    self.loanInfoObj = Mapper<MyLoanInformation>().map(JSONObject: json)
                    self.loanInformationList = (self.loanInfoObj?.loanInformation)!
                    self.loanInformationTableView.reloadData()
                    if self.loanInfoObj?.loanInformation?.count == 0
                    {
                        
                        self.showAlert(title: "", message: "No Record Found", completion:{
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                            self.navigationController!.pushViewController(vc, animated: true)
                        })
                        
                    }
                    
                }
                else {
                    
//                    print(response.result.value)
                    print(response.response?.statusCode)
                    
                    //                if let message =  self.shopInfo?.resultDesc{
                    //                    self.showAlert(title: Localized("error"), message: message, completion: nil)
                    //                }
                    //                else{
                    //                    self.showAlert(title: Localized("error"), message:Constants.ERROR_MESSAGE, completion: nil)
                    //                }
                }
            }
        }
    }
}
