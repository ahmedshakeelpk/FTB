//
//  StatusCheckVC.swift
//  First Touch Banking
//
//  Created by Arsalan Amjad on 14/12/2021.
//  Copyright © 2021 Syed Uzair Ahmed. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
//import AlamofireObjectMapper
class StatusCheckVC: BaseVC {
    
    var StatusCheckObj : StatusCheckModel?
    var genericoBj : GenericResponse?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.rowHeight = 150
        tableview.delegate = self
        tableview.dataSource = self
        CheckStatus()
        lblMainTitle.text = "ChequeBook Status".addLocalizableString(languageCode: languageCode)
    }
    @IBOutlet weak var lblMainTitle: UILabel!
    @IBOutlet weak var tableview: UITableView!
    
    
    
    
    
    @IBAction override func backPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func CheckStatus(){
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        showActivityIndicator()
        let compelteUrl = Constants.BASE_URL + "api/v1/Customers/Accounts/ChequeBookStatus"
        let header: HTTPHeaders =
        ["Accept":"application/json","Content-Type":"application/x-www-form-urlencoded","Authorization":"Bearer \(DataManager.instance.accessToken!)"]
        print(compelteUrl)
        print(DataManager.instance.stringHeader!)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .get, encoding: URLEncoding.httpBody, headers:header).response { response in
            //        Object { (response: DataResponse<StatusCheckModel>) in
            
            //        Alamofire.request(compelteUrl, headers:header).responseObject { (response: DataResponse<StatusCheckModel>) in
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                self.StatusCheckObj = Mapper<StatusCheckModel>().map(JSONObject: json)
                if response.response?.statusCode == 200 {
                    if self.StatusCheckObj?.response == 2 || self.StatusCheckObj?.response == 1 {
                        
                        self.tableview.reloadData()
                        //                    if let message = self.StatusCheckObj?.message{
                        //                        self.showDefaultAlert(title: "", message:message)
                        //                    }
                    }
                    else {
                        if let message = self.StatusCheckObj?.message{
                            self.showDefaultAlert(title: "", message: message)
                        }
                    }
                }
                else {
                    if let message = self.StatusCheckObj?.message{
                        self.showDefaultAlert(title: "", message: message)
                    }
//                    print(response.result.value)
                    print(response.response?.statusCode)
                }
            }
        }
    }
}
extension StatusCheckVC : UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = StatusCheckObj?.SCdata?.count{
            return count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aCell = tableView.dequeueReusableCell(withIdentifier: "StatusCheckTableViewCellVc") as! StatusCheckTableViewCellVc
        let aStatement = StatusCheckObj?.SCdata![indexPath.row]
        aCell.lblLeavesValue.text = aStatement?.vCHeck_leaves
        aCell.backview.dropShadow1()
        aCell.lblAccNOValue.text = aStatement?.vAccount
        aCell.lblStatusValue.text = aStatement?.vREQUEST_STATUS
        aCell.lblLocation.text = DataManager.instance.ChequeLocation ?? ""
        aCell.selectionStyle = .none
        return aCell
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
    
}
