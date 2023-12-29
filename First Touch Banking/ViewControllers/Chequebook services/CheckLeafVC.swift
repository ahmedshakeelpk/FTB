//
//  CheckLeafVC.swift
//  First Touch Banking
//
//  Created by Arsalan Amjad on 14/12/2021.
//  Copyright © 2021 Syed Uzair Ahmed. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
//import AlamofireObjectMapper
class CheckLeafVC: BaseVC {

    
    
    
    var CheckLeafObj : LeafInq?
    override func viewDidLoad() {
        super.viewDidLoad()
        ChequeLeafInquiry()
        tableview.delegate = self
        tableview.dataSource = self
        tableview.rowHeight = 120
        lblMain.text = "Check Leaf".addLocalizableString(languageCode: languageCode)
        // Do any additional setup after loading the view.
    }
    

    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var lblMain: UILabel!
   
    @IBAction func backpressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
       
    }
    private func ChequeLeafInquiry(){
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        showActivityIndicator()
        let compelteUrl = Constants.BASE_URL + "/api/v1/Customers/Accounts/ChequeLeafInquiry"
        let header: HTTPHeaders =
        ["Accept":"application/json","Content-Type":"application/x-www-form-urlencoded","Authorization":"Bearer \(DataManager.instance.accessToken!)"]
        print(compelteUrl)
        print(DataManager.instance.stringHeader!)

        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .get, encoding: URLEncoding.httpBody, headers:header).response { response in
            //            Object { (response: DataResponse<LeafInq>) in
            
            
            
            //        Alamofire.request(compelteUrl, headers:header).responseObject { (response: DataResponse<LeafInq>) in
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                self.CheckLeafObj = Mapper<LeafInq>().map(JSONObject: json)
                if response.response?.statusCode == 200 {
                    
                    if self.CheckLeafObj?.response == 2 || self.CheckLeafObj?.response == 1 {
                        
                        
                        
                        self.tableview.reloadData()
                        //                    if let message = self.CheckLeafObj?.message{
                        //                        self.showDefaultAlert(title: "", message:message)
                        //                    }
                    }
                    else {
                        if let message = self.CheckLeafObj?.message{
                            self.showDefaultAlert(title: "", message: message)
                        }
                    }
                }
                else {
                    if let message = self.CheckLeafObj?.message{
                        self.showDefaultAlert(title: "", message: message)
                    }
                    //                print(response.result.value)
                    print(response.response?.statusCode)
                }
            }
        }
    }
}
extension CheckLeafVC : UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = CheckLeafObj?.LIdata?.count{
            return count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aCell = tableView.dequeueReusableCell(withIdentifier: "LeafCellVC") as! LeafCellVC
        let aStatement = CheckLeafObj?.LIdata?[indexPath.row]
//        irum
        aCell.lblCheckNovalue.text = aStatement?.leaf_no?[indexPath.row].value
        aCell.backview.dropShadow1()
        aCell.lblcheckbookValue.text  = "\(aStatement?.chequebook_no! ?? 0)"
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
