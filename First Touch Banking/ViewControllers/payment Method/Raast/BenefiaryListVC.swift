//
//  BenefiaryListVC.swift
//  First Touch Banking
//
//  Created by Arsalan Amjad on 26/01/2022.
//  Copyright © 2022 irum Zubair. All rights reserved.
//

import UIKit
import iOSDropDown
import Alamofire
//import AlamofireObjectMapper
import SwiftKeychainWrapper
import ObjectMapper
class BenefiaryListVC: BaseVC {
    var BeneficiaryModel : Beneficiarymodel?
    var arrIbftBene : [BenefList]?
    var beneID : Int?
    var genericObj: GenericResponse?
    override func viewDidLoad() {
        super.viewDidLoad()
        getBeneficiary()
        lblmain.text = "RAAST Beneficiary".addLocalizableString(languageCode: languageCode)
        self.tableview.reloadData()
        self.tableview.delegate = self
        self.tableview.dataSource = self
        
        tableview.rowHeight = 130
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableview.reloadData()
    }
    
    
    @IBOutlet weak var lblmain: UILabel!
    
    
    
    @IBAction func deletebtn(_ sender: UIButton) {
        let tag = sender.tag
        //        let indexPath = IndexPath.init(row: tag, section: 0)
        //        let cell = tableView.cellForRow(at: IndexPath(row: tag, section: 0)) as! RaastbeneficiaryCell
        let aValue:BenefList = (self.BeneficiaryModel?.data![tag])!
        self.beneID = aValue.id
        let consentAlert = UIAlertController(title: "", message: "Do you want to Delete Beneficiary?".addLocalizableString(languageCode: languageCode), preferredStyle: UIAlertControllerStyle.alert)
        
        consentAlert.addAction(UIAlertAction(title: "Yes".addLocalizableString(languageCode: languageCode), style: .default, handler: { (action: UIAlertAction!) in
            self.deleteBeneficiary()
            
        }))
        
        consentAlert.addAction(UIAlertAction(title: "Cancel".addLocalizableString(languageCode: languageCode), style: .cancel, handler: { (action: UIAlertAction!) in
            //            print("Handle Cancel Logic here")
            self.dismiss(animated: true, completion:nil)
        }))
        //        UserDefaults.standard.set()
        self.present(consentAlert, animated: true, completion: nil)
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back(_ sender: UIButton) {
        isFromRaast = "false"
        self.navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var tableview: UITableView!
    
    private func getBeneficiary() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        let compelteUrl = Constants.BASE_URL + "api/v1/Customers/Sparrow/BeneficiaryList"
        let header: HTTPHeaders = ["Accept":"application/json","Authorization":"Bearer \(DataManager.instance.accessToken!)"]
        
        print(header)
        print(compelteUrl)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .get, encoding: URLEncoding.httpBody, headers:header).response { response in
            //            Object { (response: DataResponse<Beneficiarymodel>) in
            //        Alamofire.request(compelteUrl, headers:header).responseObject { (response: DataResponse<Beneficiarymodel>) in
            ////
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                if response.response?.statusCode == 200 {
                    self.BeneficiaryModel = Mapper<Beneficiarymodel>().map(JSONObject: json)
                    if self.BeneficiaryModel?.response == 0
                    {
                        if let message = self.BeneficiaryModel?.message {
                            self.showAlert(title: "", message: message, completion: nil)
                        }
                    }
                    //                self.BeneficiaryModel = response.result.value
                    if self.BeneficiaryModel?.response == 2 || self.BeneficiaryModel?.response == 1 {
                        
                        self.tableview.reloadData()
                        self.tableview.delegate = self
                        self.tableview.dataSource = self
                    }
                    else  {
                        if let message = self.BeneficiaryModel?.message{
                            self.showAlert(title: "", message: message, completion: {
                                //                        self.navigationController?.popToRootViewController(animated: true)
                            })
                        }
                    }
                }
                else {
                    if let message = self.BeneficiaryModel?.message{
                        if message == "Unauthenticated - Token Expired."{
                            self.showAlert(title: "", message: message, completion: {
                                self.navigationController?.popToRootViewController(animated: true)
                            })
                        }
                        else {
                            self.showAlert(title: "", message: message, completion: {
                                //                    self.navigationController?.popToRootViewController(animated: true)
                            })
                        }
                    }
                    
                    if let message = self.BeneficiaryModel?.message{
                        self.showAlert(title: "", message: message, completion: {
                            self.navigationController?.popToRootViewController(animated: true)
                        })
                    }
                    
                }
            }
        }
    }
    
    
    
    
    
    private func deleteBeneficiary() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        let compelteUrl = Constants.BASE_URL + "api/v1/Customers/Sparrow/Beneficiary/"+String(self.beneID!)
        let params = ["lat":DataManager.instance.Latitude!,"lng":DataManager.instance.Longitude!,"imei":DataManager.instance.imei!] as [String : Any]
        
        let header: HTTPHeaders = ["Accept":"application/json","Authorization":"Bearer \(DataManager.instance.accessToken!)"]
        print(header)
        print(compelteUrl)
        print(params)
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .delete, parameters: params, encoding: URLEncoding.httpBody, headers:header).response { response in
            //            Object { (response: DataResponse<GenericResponse>) in
            
            //        Alamofire.request(compelteUrl, method: .delete, parameters: params , encoding: URLEncoding.httpBody, headers:header).responseObject { (response: DataResponse<GenericResponse>) in
            
            
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                if response.response?.statusCode == 200 {
                    self.genericObj = Mapper<GenericResponse>().map(JSONObject: json)
                    
                    if self.BeneficiaryModel?.response == 401
                    {
                        if let message = self.BeneficiaryModel?.message {
                            self.showAlert(title: "", message: message, completion: {
                                self.navigationController?.popToRootViewController(animated: true)
                            })
                        }
                    }
                    
//                    self.genericObj = response.result.value
                    if self.genericObj?.response == 2 || self.genericObj?.response == 1 {
                        if let message = self.genericObj?.message{
                            
                            let alert = UIAlertController(title: "", message:message, preferredStyle: UIAlertControllerStyle.alert)
                            // add an action (button)
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { _ in
                                //            self.beneficiaryTableView.reloadData()
                                //                            beneficiaryTableView.reloadData()
                                self.getBeneficiary()
                                
                                
                            }))
                            // show the alert
                            self.rootVC?.present(alert, animated: true, completion: nil)
                            
                            //                        self.showToast(title: message)
                        }
                    }
                    else {
                        if let message = self.genericObj?.message{
                            self.showDefaultAlert(title: "", message: message)
                        }
                        
                    }
                }
                else {
                    if let message = self.genericObj?.message{
                        if message == "Unauthenticated - Token Expired."{
                            self.showAlert(title: "", message: message, completion: {
                                self.navigationController?.popToRootViewController(animated: true)
                            })
                            
                        }
                        else{
                            self.showAlert(title: "", message: message, completion: {
                                //                    self.navigationController?.popToRootViewController(animated: true)
                            })
                        }
                        
                        //                if let message = self.genericObj?.message{
                        //                    self.showDefaultAlert(title: "", message: message)
                        //                }
//                        print(response.result.value)
                        print(response.response?.statusCode)
                    }
                }
            }
        }
    }
}

extension BenefiaryListVC : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let count = self.BeneficiaryModel?.data?.count
            
        {
            return count
        }
        return 0
        //        return arrIbftBene?.count ?? -1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aCell = tableView.dequeueReusableCell(withIdentifier: "RaastbeneficiaryCell") as! RaastbeneficiaryCell
        let tag = indexPath.row
        aCell.selectionStyle = .none
        let aQuickPay = self.BeneficiaryModel?.data?[indexPath.row]
        aCell.backview.dropShadow1()
        //        if AliasType == "IBAN"
        //        {
        //            aCell.lblname.text = aQuickPay?.name
        //            aCell.lblAccountNumber.text = aQuickPay?.account
        //            aCell.lblCompany.text = aQuickPay?.beneficiary_code
        //            aCell.btndelete.tag = indexPath.row
        //        }
        //        else{
        aCell.lblname.text = aQuickPay?.name
        aCell.lblAccountNumber.text = aQuickPay?.account
        aCell.lblCompany.text = aQuickPay?.beneficiary_code
        aCell.btndelete.setTitle("", for: .normal)
        aCell.btndelete.tag = indexPath.row
        
        //        }
        return aCell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let aIbftBene = self.BeneficiaryModel?.data?[indexPath.row]
        
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "TransferByAliasVC") as! TransferByAliasVC
        vc.sourcAcc = aIbftBene?.mobile
        vc.AccNo = aIbftBene?.beneficiary_code
        vc.IBAN = aIbftBene?.account
        vc.IsFromRaast = "true"
        self.navigationController!.pushViewController(vc, animated: true)
    }
}
