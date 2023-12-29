//
//  MyLoanFurtherInfoVC.swift
//  First Touch Banking
//
//  Created by Syed Uzair Ahmed on 01/08/2018.
//  Copyright © 2018 Syed Uzair Ahmed. All rights reserved.
//

import UIKit
import Alamofire
//import AlamofireObjectMapper
import SwiftKeychainWrapper
import ObjectMapper

class MyLoanFurtherInfoVC: BaseVC , UITableViewDelegate , UITableViewDataSource{
    
    var loanInfoObj: MyLoanInformation?
    var loanInformationList = [SingleLoanInformation]()
    @IBOutlet weak var furtherLoanInformationTableView: UITableView!
    var accountNumber:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblmain.text = "My Loans".addLocalizableString(languageCode: languageCode)
        self.getLoanFutherInfo()
        
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
        
        let aCell = tableView.dequeueReusableCell(withIdentifier: "FurtherLoanInfoTableViewCell") as! FurtherLoanInfoTableViewCell
        
        aCell.selectionStyle = .none
        aCell.backview.dropShadow1()
        if let prodCode = self.loanInformationList[indexPath.row].mn_installment_due_date{
            aCell.lblInstallementDueDate.text = prodCode
        }
        if let disbDate = self.loanInformationList[indexPath.row].actual_installment{
            aCell.lblActualInstallement.text = disbDate
        }
        if let amountFinanced = self.loanInformationList[indexPath.row].mx_paid_date{
            aCell.lblPaidDate.text = amountFinanced
        }
        
        return aCell
    }
    
    
    // MARK: - API CALL
    
    
    private func getLoanFutherInfo() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        let compelteUrl = Constants.BASE_URL + "api/v1/Loans/LoanDetailInstallment/\(self.accountNumber!)"
        
        let header: HTTPHeaders = ["Accept":"application/json","Authorization":"Bearer \(DataManager.instance.accessToken!)"]
        
        print(header)
        print(compelteUrl)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .get, encoding: URLEncoding.httpBody, headers:header).response { response in
            //        Object { (response: DataResponse<MyLoanInformation>) in
            //        Alamofire.request(compelteUrl, headers:header).responseObject { (response: DataResponse<MyLoanInformation>) in
            
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                if response.response?.statusCode == 200 {
                    self.loanInfoObj = Mapper<MyLoanInformation>().map(JSONObject: json)
//                    self.loanInfoObj = response.result.value
                    self.loanInformationList = (self.loanInfoObj?.loanInformation)!
                    self.furtherLoanInformationTableView.reloadData()
                }
                else {
                    if let message = self.loanInfoObj?.message{
                        if message == "Unauthenticated - Token Expired."{
                            self.showAlert(title: "", message: message, completion: {
                                self.navigationController?.popToRootViewController(animated: true)
                            })
                        }
                        else{
                            
                        }
                        self.showAlert(title: "", message: message, completion: {
                            //                    self.navigationController?.popToRootViewController(animated: true)
                        })
                    }
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
