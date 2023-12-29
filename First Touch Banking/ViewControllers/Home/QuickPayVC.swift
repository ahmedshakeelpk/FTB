//
//  QuickPayVC.swift
//  First Touch Banking
//
//  Created by Syed Uzair Ahmed on 27/12/2017.
//  Copyright © 2017 Syed Uzair Ahmed. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
//import AlamofireObjectMapper

class QuickPayVC: BaseVC , UITableViewDelegate , UITableViewDataSource {
    
    @IBOutlet var beneficiaryTableView: UITableView!
    var quickPayObj : QuickPay?
    var genericObj: GenericResponse?
    var beneID : Int?
    static let networkManager = NetworkManager()
    var isFromAddBene:Bool = false
    
    
    
    @IBOutlet weak var btnaddbene: UIButton!
    @IBOutlet weak var lblMaintitle: UILabel!
    
    //  var singlBenef : SingleBeneficiary?
    var arrIbftBene = [SingleBeneficiary]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblMaintitle.text = "Quick Pay".addLocalizableString(languageCode: languageCode)
        btnaddbene.setTitle("Add Beneficiary".addLocalizableString(languageCode: languageCode), for: .normal)
        self.getBeneficiaryList()
        
        //        if isFromAddBene == true{
        //            btnaddbene.isHidden = false
        //        }
        //        else{
        //            btnaddbene.isHidden = true
        //        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.beneficiaryTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func buttontaped(_sender:UIButton)
    {
        let tag = _sender.tag
        //
        //      let cell = beneficiaryTableView.cellForRow(at: IndexPath(row: tag, section: 0)) as! QuickPayListTableViewCell
        if isFromAddBene == true
        {
            let aValue:SingleBeneficiary = (self.arrIbftBene[tag])
            self.beneID = aValue.id
            self.deleteBeneficiary(row: tag)
        }
        else{
            let aValue:SingleBeneficiary = (self.quickPayObj?.beneficiaries![tag])!
            
            self.beneID = aValue.id
            self.deleteBeneficiary(row: tag)
        }
        
    }
    
    // MARK: - Table View Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFromAddBene == true {
            return arrIbftBene.count
        }
        else{
            
            if let count = self.quickPayObj?.beneficiaries?.count{
                return count
            }
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let aCell = tableView.dequeueReusableCell(withIdentifier: "QuickPayListTableViewCell") as! QuickPayListTableViewCell
        aCell.selectionStyle = .none
        //
        if isFromAddBene == true {
            
            let aIbftBene = self.arrIbftBene[indexPath.row]
            
            if aIbftBene.beneficiary_type == "IBFT"{
                
                aCell.lblName.text = aIbftBene.name
                aCell.lblAccountNumber.text = aIbftBene.account
                aCell.btn_Delete.tag = indexPath.row
                aCell.lblBankName.text = aIbftBene.beneficiary_company
                aCell.btn_Delete.addTarget(self, action: #selector(buttontaped), for: .touchUpInside)
                //                aCell.lblBankName.text = aIbftBene.beneficiary_company
                
            }
        }
        else {
            
            let aQuickPay = self.quickPayObj?.beneficiaries![indexPath.row]
            
            aCell.lblName.text = aQuickPay?.name
            aCell.lblAccountNumber.text = aQuickPay?.account
            aCell.lblBankName.text = aQuickPay?.beneficiary_company
            aCell.btn_Delete.tag = indexPath.row
            aCell.btn_Delete.addTarget(self, action: #selector(buttontaped), for: .touchUpInside)
        }
        
        return aCell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isFromAddBene == true {
            
            let aIbftBene = self.arrIbftBene[indexPath.row]
            
            if aIbftBene.beneficiary_type == "IBFT"{
                
                let interBankFundVC = self.storyboard!.instantiateViewController(withIdentifier: "InterBankFundTransferVC") as! InterBankFundTransferVC
                interBankFundVC.varBeneAccountNum = aIbftBene.account
                interBankFundVC.sourceBank = aIbftBene.beneficiary_company
                interBankFundVC.isFromQuickPay = true
                interBankFundVC.isFromHome = false
                self.navigationController!.pushViewController(interBankFundVC, animated: true)
                
            }
            
            NSLog ("You selected row: %@ \(indexPath)")
            
            print("Name : \(aIbftBene.name))")
            print("Account Number : \(aIbftBene.account))")
            print("Bank Name : \(aIbftBene.beneficiary_company))")
            print("Bene Code : \(aIbftBene.beneficiary_code))")
            print("Type : \(aIbftBene.beneficiary_type))")
        }
        else{
            
            let aValue:SingleBeneficiary = (self.quickPayObj?.beneficiaries![indexPath.row])!
            
            
            // type check implementation for Postpaid
            
            if let type = aValue.beneficiary_type{
                
                if type == "IBT"{
                    let localFundVC = self.storyboard!.instantiateViewController(withIdentifier: "LocalFundsTransferVC") as! LocalFundsTransferVC
                    localFundVC.beneficiaryAccount = aValue.account
                    localFundVC.isFromQuickPay = true
                    self.navigationController!.pushViewController(localFundVC, animated: true)
                }
                else if type == "IBFT"{
                    let interBankFundVC = self.storyboard!.instantiateViewController(withIdentifier: "InterBankFundTransferVC") as! InterBankFundTransferVC
                    interBankFundVC.varBeneAccountNum = aValue.account
                    interBankFundVC.sourceBank = aValue.beneficiary_company
                    interBankFundVC.isFromQuickPay = true
                    self.navigationController!.pushViewController(interBankFundVC, animated: true)
                }
                else if type == "MTUP"{
                    let prepaidTopupVC = self.storyboard?.instantiateViewController(withIdentifier: "PrePaidTopUpVC") as! PrePaidTopUpVC
                    prepaidTopupVC.isFromQuickPay = true
                    prepaidTopupVC.companyCode = aValue.beneficiary_code
                    prepaidTopupVC.mainTitle = aValue.beneficiary_company
                    prepaidTopupVC.consumerNumber = aValue.account
                    self.navigationController?.pushViewController(prepaidTopupVC, animated: true)
                }
                else {
                    let utilityInfoVC = self.storyboard!.instantiateViewController(withIdentifier: "UtilityBillInfoVC") as! UtilityBillInfoVC
                    utilityInfoVC.companyID = aValue.beneficiary_code!
                    utilityInfoVC.mainTitle = aValue.beneficiary_company
                    utilityInfoVC.consumerNumber = aValue.account
                    utilityInfoVC.isFromQuickPay = true
                    self.navigationController!.pushViewController(utilityInfoVC, animated: true)
                }
                
            }
            
            NSLog ("You selected row: %@ \(indexPath)")
            
            print("Name : \(aValue.name))")
            print("Account Number : \(aValue.account))")
            print("Bank Name : \(aValue.beneficiary_company))")
            print("Bene Code : \(aValue.beneficiary_code))")
            print("Type : \(aValue.beneficiary_type))")
            
        }
        
        
    }
    // MARK: - Action Method
    
    @IBAction func deleteBenePressed(_ sender: UIButton) {
        //        let tag = sender.tag
        //        let aValue:SingleBeneficiary = (self.quickPayObj?.beneficiaries![tag])!
        //        self.beneID = aValue.id
        //        self.deleteBeneficiary(row: tag)
        //
    }
    
    @IBAction func addBeneButtonPressed(_ sender: Any) {
        let interFundBankTransVC = self.storyboard!.instantiateViewController(withIdentifier: "InterBankFundTransferVC") as! InterBankFundTransferVC
        interFundBankTransVC.isFromHome = true
        interFundBankTransVC.arrIbftBene = self.quickPayObj?.beneficiaries ?? []
        self.navigationController!.pushViewController(interFundBankTransVC, animated: true)
    }
    
    
    
    // MARK: - API CALL
    
    private func deleteBeneficiary(row: Int) {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        let compelteUrl = Constants.BASE_URL + "api/v1/Customers/Beneficiary/"+String(self.beneID!)
        let params = ["lat":DataManager.instance.Latitude!,"lng":DataManager.instance.Longitude!,"imei":DataManager.instance.imei!] as [String : Any]
        
        let header: HTTPHeaders = ["Accept":"application/json","Authorization":"Bearer \(DataManager.instance.accessToken!)"]
                
        print(header)
        print(compelteUrl)
        print(params)
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .delete , parameters: params, encoding: URLEncoding.httpBody, headers:header).response { response in
            //        Object { (response: DataResponse<GenericResponse>) in
            //        Alamofire.request(compelteUrl, method: .delete, parameters: params , encoding: URLEncoding.httpBody, headers:header).responseObject { (response: DataResponse<GenericResponse>) in
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                if response.response?.statusCode == 200 {
                    self.genericObj = Mapper<GenericResponse>().map(JSONObject: json)
                    
                    if self.genericObj?.response == 2 || self.genericObj?.response == 1 {
                        if let message = self.genericObj?.message{
                            
                            let alert = UIAlertController(title: "", message:message, preferredStyle: UIAlertControllerStyle.alert)
                            // add an action (button)
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { _ in
                                //                            self.beneficiaryTableView.beginUpdates()
                                
                                if self.isFromAddBene == true {
                                    self.arrIbftBene.remove(at: row)
                                }
                                else{
                                    
                                    if let count = self.quickPayObj?.beneficiaries?.count{
                                        self.quickPayObj?.beneficiaries?.remove(at: row)
                                    }
                                }
                                
                                
                                //                            self.beneficiaryTableView.deleteRows(at: [IndexPath(row: row, section: 1)], with: .none)
                                //                            self.beneficiaryTableView.endUpdates()
                                self.beneficiaryTableView.reloadData()
                                //                          self.getBeneficiaryList()
                                
                            }))
                            // show the alert
                            self.rootVC?.present(alert, animated: true, completion: nil)
                            self.beneficiaryTableView.reloadData()
                            //                        self.showToast(title: message)
                        }
                    }
                    else {
                        if let message = self.genericObj?.message{
                            self.showDefaultAlert(title: "", message: message)
                        }
                        // self.showAlert(title: "", message: (self.shopInfo?.resultDesc)!, completion: nil)
                    }
                }
                else {
                    //                    print(response.result.value)
                    print(response.response?.statusCode)
                }
            }
        }
    }
    private func getBeneficiaryList() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        showActivityIndicator()
        let compelteUrl = Constants.BASE_URL + "api/v1/Customers/Beneficiary"
        let header: HTTPHeaders = ["Accept":"application/json","Authorization":"Bearer \(DataManager.instance.accessToken!)"]
        
        print(header)
        print(compelteUrl)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .get, encoding: URLEncoding.httpBody, headers:header).response { response in
            //        Object { (response: DataResponse<QuickPay>) in
            //        Alamofire.request(compelteUrl, headers:header).responseObject { (response: DataResponse<QuickPay>) in
            
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                if response.response?.statusCode == 200 {
                    self.quickPayObj = Mapper<QuickPay>().map(JSONObject: json)
                    
                    if self.quickPayObj?.response == 2 || self.quickPayObj?.response == 1 {
                        
                        if self.isFromAddBene == true {
                            for aBene in (self.quickPayObj?.beneficiaries)!{
                                if aBene.beneficiary_type == "IBFT"{
                                    self.arrIbftBene.append(aBene)
                                }
                            }
                        }
                        self.beneficiaryTableView.reloadData()
                    }
                    else {
                        // self.showAlert(title: "", message: (self.shopInfo?.resultDesc)!, completion: nil)
                    }
                }
                else {
//                    print(response.result.value)
                    print(response.response?.statusCode)
                }
            }
        }
    }
}
