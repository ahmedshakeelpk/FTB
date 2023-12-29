//
//  LimitManagementMainVc.swift
//  First Touch Banking
//
//  Created by Arsalan Amjad on 03/02/2022.
//  Copyright © 2022 irum Zubair. All rights reserved.
//

import UIKit
import Alamofire
//import AlamofireObjectMapper
import SwiftKeychainWrapper
import ObjectMapper
var limitflag = ""
class LimitManagementMainVc: BaseVC{
    
    
    var ATMID : String?
    var MBID : String?
    var arrMBItems = [MB]()
    var arrATMItems = [ATM]()
    var LimitManagmentObj : AtmMobilebankingModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        //        getChannelLimits()
        self.Tableview1.reloadData()
        self.Tableview2.reloadData()
        print("array is ", arrMBItems.count)
        print("ATM data is", arrATMItems.count)
        
        Tableview1.rowHeight = 100
        Tableview2.rowHeight = 100
        lblMain.text = "Account Limit Management".addLocalizableString(languageCode: languageCode)
        Tableview2.isHidden = true
        Tableview1.isHidden = true
        lblMB.isHidden = true
        lblATM.isHidden = true
        
    }
    
    
    @IBOutlet weak var lblMain: UILabel!
    
    
    @IBAction func back(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var lblMB: UILabel!
    
    
    
    @IBOutlet weak var Tableview1: UITableView!
    
    @IBOutlet weak var Tableview2: UITableView!
    
    @IBOutlet weak var lblATM: UILabel!
    
    @IBAction func changelimitATM(_ sender: UIButton) {
        limitflag = "false"
        let tag = sender.tag
        let cell = Tableview2.cellForRow(at: IndexPath(row: tag, section: 0))
        as! ATMCellvC
        
        DataManager.instance.frequencyATM = LimitManagmentObj?.data?.aTM?[tag].frequency
        DataManager.instance.keyATm = LimitManagmentObj?.data?.aTM?[tag].key
        DataManager.instance.identifierATm = LimitManagmentObj?.data?.aTM?[tag].identifier
        
        ATMID = LimitManagmentObj?.data?.aTM?[tag].limitID
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "SelectLimitMangamnetLovVC") as!
        SelectLimitMangamnetLovVC
        DataManager.instance.transactionNameATm = LimitManagmentObj?.data?.aTM?[tag].transactionName! ?? ""
        ATMIdget = self.ATMID ?? ""
        
        vc.maximumAllowedLimitATM = LimitManagmentObj?.data?.aTM?[tag].maximumAllowedLimit! ?? ""
        vc.IsFromATM = "True"
        
        //        vc.MBidget = self.MBID ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
        
        
        
        
        
        
    }
    
    @IBAction func ChangelimitMBa(_ sender: UIButton) {
        limitflag = "true"
        let tag = sender.tag
        let cell = Tableview1.cellForRow(at: IndexPath(row: tag, section: 0))
        as! MobileBankingCell
        MBID = LimitManagmentObj?.data?.mB?[tag].limitID
        let vc = storyboard?.instantiateViewController(withIdentifier: "SelectLimitMangamnetLovVC") as!
        SelectLimitMangamnetLovVC
        
        DataManager.instance.frequencyMB = LimitManagmentObj?.data?.mB?[tag].frequency
        
        DataManager.instance.keyMB = LimitManagmentObj?.data?.mB?[tag].key
        
        DataManager.instance.identifierMB = LimitManagmentObj?.data?.mB?[tag].identifier
        //        vc.ATMIdget = self.ATMID ?? ""
        MBidget = self.MBID ?? ""
        vc.maximumAllowedLimitMB = LimitManagmentObj?.data?.mB?[tag].maximumAllowedLimit
        vc.IsFromMb = "true"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        getChannelLimits()
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.Tableview1.reloadData()
        }
        
        self.Tableview2.reloadData()
        
    }
    @IBOutlet weak var ChanglimitMB: UITableView!
    
    private func getChannelLimits() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        var userCnic : String?
        if KeychainWrapper.standard.hasValue(forKey: "userCnic"){
            userCnic = KeychainWrapper.standard.string(forKey: "userCnic")
        }
        else{
            userCnic = ""
        }
        
        
        let compelteUrl = Constants.BASE_URL + "api/v1/Customers/Accounts/getAccountLimits"
        
        let parameters = ["lat": DataManager.instance.Latitude!,"lng": DataManager.instance.Longitude!,"imei": DataManager.instance.imei!] as [String : Any]
        
        print(parameters)
        
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        
        print(result.apiAttribute1)
        print(result.apiAttribute2)
        
        //        let params = ["ApiAttribute1":result.apiAttribute1,"ApiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        
        let header: HTTPHeaders =
        ["Accept":"application/json","Content-Type":"application/json","Authorization":"Bearer \(DataManager.instance.accessToken!)"]
        
        //        print(params)
        print(compelteUrl)
        print(header)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: parameters , encoding: JSONEncoding.default, headers:header).response { response in
            //        Object { (response: DataResponse<AtmMobilebankingModel>) in
            
            
            //        Alamofire.request(compelteUrl, method: .post, parameters: parameters , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<AtmMobilebankingModel>) in
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                self.LimitManagmentObj = Mapper<AtmMobilebankingModel>().map(JSONObject: json)
                //            self.LimitManagmentObj = response.result.value
                if response.response?.statusCode == 200 {
                    self.Tableview2.isHidden = false
                    self.Tableview1.isHidden = false
                    self.lblMB.isHidden = false
                    self.lblATM.isHidden = false
                    
                    if self.LimitManagmentObj?.response == 2 || self.LimitManagmentObj?.response == 1 {
                        if self.LimitManagmentObj?.data?.aTM != nil{
                            self.Tableview2.isHidden = false
                            self.Tableview1.isHidden = false
                            self.lblMB.isHidden = false
                            self.lblATM.isHidden = false
                            self.lblATM.text = "ATM".addLocalizableString(languageCode: languageCode)
                        }
                        if  self.LimitManagmentObj?.data?.mB != nil
                        {
                            self.lblMB.text = "Mobile Banking".addLocalizableString(languageCode: languageCode)
                            
                        }
                        
                        print("Atm  array is",self.LimitManagmentObj?.data?.aTM)
                        print("MB  array is", self.LimitManagmentObj?.data?.mB)
                        self.Tableview1.delegate = self
                        self.Tableview1.dataSource = self
                        self.Tableview2.delegate = self
                        self.Tableview2.dataSource = self
                        DispatchQueue.main.async {
                            self.Tableview1.reloadData()
                            self.Tableview2.reloadData()
                        }
                        self.Tableview1.reloadData()
                        self.Tableview2.reloadData()
                    }
                    else {
                        if let message = self.LimitManagmentObj?.message{
                            self.showDefaultAlert(title: "", message: message)
                        }
                        // self.showAlert(title: "", message: (self.shopInfo?.resultDesc)!, completion: nil)
                    }
                }
                else {
                    if let message = self.LimitManagmentObj?.message{
                        self.showDefaultAlert(title: "", message: message)
                    }
                    //                print(response.result.value)
                    //                print(response.response?.statusCode)
                }
            }
        }
    }
}
extension LimitManagementMainVc: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == self.Tableview1{
            if self.arrMBItems != nil {
                return self.LimitManagmentObj?.data?.mB?.count ?? -1
                
            }
            
        }
        if tableView == self.Tableview2{
            if self.arrATMItems != nil
            {
                return self.LimitManagmentObj?.data?.aTM?.count ?? -1
            }
            
        }
        return 0
        //
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == Tableview1
        {
            let Cell1 = tableView.dequeueReusableCell(withIdentifier: "MobileBankingCell") as! MobileBankingCell
            Cell1.selectionStyle = .none
            
            Cell1.btnchangelimit.tag = indexPath.row
            //            let aValue = arrMBItems[indexPath.row]
            //            DataManager.instance.frequencyMB = LimitManagmentObj?.data?.mB?[indexPath.row].frequency
            print("seleted MBId is",MBID)
            Cell1.backview.dropShadow1()
            Cell1.btnchangelimit.setTitle("Change Limit".addLocalizableString(languageCode: languageCode), for: .normal)
            Cell1.lblamount.text = LimitManagmentObj?.data?.mB?[indexPath.row].limitAmount!
            Cell1.lblTransactionname.text = "\(LimitManagmentObj?.data?.mB?[indexPath.row].transactionName! ?? "")"
            
            return Cell1
        }
        
        else
        {
            
            let Cell2 = tableView.dequeueReusableCell(withIdentifier: "ATMCellvC") as! ATMCellvC
            //            DataManager.instance.frequencyATM = LimitManagmentObj?.data?.aTM?[indexPath.row].frequency
            print("seleted ATmId is",ATMID as Any)
            Cell2.btnlimitchange.tag = indexPath.row
            Cell2.btnlimitchange.setTitle("Change Limit".addLocalizableString(languageCode: languageCode), for: .normal)
            Cell2.lblAmount.text = LimitManagmentObj?.data?.aTM?[indexPath.row].limitAmount! ?? ""
            Cell2.lblTransactionname.text = "\(LimitManagmentObj?.data?.aTM?[indexPath.row].transactionName! ?? "")"
            
            
            Cell2.selectionStyle = .none
            
            return Cell2
        }
        
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
        UIView.animate(withDuration: 0.3, animations: {
            cell.layer.transform = CATransform3DMakeScale(1.05,1.05,1)
        },completion: { finished in
            UIView.animate(withDuration: 0.1, animations: {
                cell.layer.transform = CATransform3DMakeScale(1,1,1)
            })
        })
    }
    
    //
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        if tableView == tableview1
        //        {
        //            MBID = GetChangeLimitObj?.limitmangemnetdata?.mB?[indexPath.row].limitId
        //            print("seleted Id is",MBID ?? "")
        //        }
        //        else
        //         {
        //             ATMID = GetChangeLimitObj?.limitmangemnetdata?.aTM?[indexPath.row].limitId
        //             print("seleted Id is",ATMID as Any)
        //         }
        
        
    }
}
