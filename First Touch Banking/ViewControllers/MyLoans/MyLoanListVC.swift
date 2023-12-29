//
//  MyLoanListVC.swift
//  First Touch Banking
//
//  Created by Arsalan Amjad on 16/02/2022.
//  Copyright © 2022 irum Zubair. All rights reserved.
//

import UIKit
import Alamofire
//import AlamofireObjectMapper
import SwiftKeychainWrapper
import ObjectMapper
class MyLoanListVC: BaseVC {
    var LoanObj : LoansModel?
    var userCnic : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        lblmain.text = "My Loans".addLocalizableString(languageCode: languageCode)
    }
    @IBOutlet weak var lblmain: UILabel!
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var tableview: UITableView!
    private func LoanProductInformation(){
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        
        
        if KeychainWrapper.standard.hasValue(forKey: "userCnic"){
            userCnic = KeychainWrapper.standard.string(forKey: "userCnic")
        }
        else{
            userCnic = ""
        }
        
        showActivityIndicator()
        let compelteUrl = Constants.BASE_URL + "api/v1/Loans/LoanProductInformation/" + userCnic!
        let header: HTTPHeaders =
        ["Accept":"application/json","Content-Type":"application/x-www-form-urlencoded","Authorization":"Bearer \(DataManager.instance.accessToken!)"]
        print(compelteUrl)
        print(DataManager.instance.stringHeader!)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .get, encoding: URLEncoding.httpBody, headers:header).response { response in
            //            Object { (response: DataResponse<LoansModel>) in
            
            //        Alamofire.request(compelteUrl, headers:header).responseObject { (response: DataResponse<LoansModel>) in
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                self.LoanObj = Mapper<LoansModel>().map(JSONObject: json)
                if response.response?.statusCode == 200 {
                    
                    if self.LoanObj?.response == 2 || self.LoanObj?.response == 1 {
                        
                        self.tableview.reloadData()
                        //                    if let message = self.maintenceCerObj?.message{
                        //                        self.showDefaultAlert(title: "", message:message)
                        //                    }
                    }
                    else {
                        if let message = self.LoanObj?.message{
                            self.showDefaultAlert(title: "", message: message)
                        }
                    }
                }
                else {
                    if let message = self.LoanObj?.message{
                        self.showDefaultAlert(title: "", message: message)
                    }
//                    print(response.result.value)
                    print(response.response?.statusCode)
                }
            }
        }
    }
}

extension MyLoanListVC: UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = LoanObj?.data?.count{
            return count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aCell = tableView.dequeueReusableCell(withIdentifier: "LoansCellVC") as! LoansCellVC
        let aStatement = LoanObj?.data?[indexPath.row]
        aCell.installmentDueDate.text = "Installment Due Date:       \(aStatement?.mn_installment_due_date! ?? "")"
        aCell.PaidDate.text  = "Paid Date:       \(aStatement?.mx_paid_date! ?? "")"
        aCell.PaidAmount.text = "Paid Amount:           PKR:\(aStatement?.amount_paid! ?? "")"
        aCell.actuallIns.text  = "Actuall Installment:        PKR:\(aStatement?.actual_installment! ?? "")"
        aCell.backview.dropShadow1()
        
        return aCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog ("You selected row: %@ \(indexPath)")
        
        //        let interBankFundVC = self.storyboard!.instantiateViewController(withIdentifier: "InterBankFundTransferVC") as! InterBankFundTransferVC
        //        interBankFundVC.varBeneAccountNum = "4162786786"
        //        interBankFundVC.sourceBank = "National Bank of Pakistan"
        //        interBankFundVC.sourceReasonForTrans = "Donations Charity"
        //        interBankFundVC.isFromQuickPay = true
        //        interBankFundVC.isFromHome = false
        //        interBankFundVC.isFromDonations = true
        //        self.navigationController!.pushViewController(interBankFundVC, animated: true)
    }
}
