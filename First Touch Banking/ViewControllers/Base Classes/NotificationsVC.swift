//
//  NotificationsVC.swift
//  First Touch Banking
//
//  Created by Syed Uzair Ahmed on 11/12/2017.
//  Copyright © 2017 Syed Uzair Ahmed. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
//import AlamofireObjectMapper

class NotificationsVC: BaseVC , UITableViewDelegate , UITableViewDataSource  {
    
    
    /* Remaining : Access Token Orignal  */
    
    
    @IBOutlet var notificationsTableView: UITableView!
    var notificationObj : Notifications?
    
    static let networkManager = NetworkManager()
    
    @IBOutlet weak var lblMain: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblMain.text = "Notification".addLocalizableString(languageCode: languageCode)
        self.notificationsTableView.rowHeight = UITableViewAutomaticDimension
        self.notificationsTableView.estimatedRowHeight = 130.0
        self.getNotifications()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table View Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let count = self.notificationObj?.notifications?.count {
            return count
        }
        
        return 0
        
        //return (self.notificationsObj?.notifications?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let aCell = tableView.dequeueReusableCell(withIdentifier: "NotificationsTableViewCell") as! NotificationsTableViewCell
        aCell.selectionStyle = .none
        
        let aNotification = self.notificationObj?.notifications![indexPath.row]
        
        aCell.lblTitle.text = aNotification?.NotifMessage
        aCell.lblID.text = String(describing: aNotification?.id)
        aCell.lblStatus.text = String(describing: aNotification?.status)
        
        return aCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        NSLog ("You selected row: %@ \(indexPath)")
        
        let aValue:SingleNotification = (self.notificationObj?.notifications![indexPath.row])!
        
        let notificationPopUpVC = self.storyboard?.instantiateViewController(withIdentifier: "NotificationPopUpVC") as! NotificationPopUpVC
        notificationPopUpVC.titleStr = aValue.NotifMessage
        notificationPopUpVC.statusVar = aValue.status
        notificationPopUpVC.idVar = aValue.id
        
        notificationPopUpVC.modalPresentationStyle = .overCurrentContext;
        self.rootVC?.present(notificationPopUpVC, animated: true, completion: nil)
    }
    
    // MARK: - API CALL
    
    private func getNotifications() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        //        let accessToken = "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6ImQ3ZmRhM2M0NjEyODYyNzcxNDNlOTU5YTFmNjFmMjBiMmQxMjExN2JjOWM1ZDg5ODhhNmNiZjVlY2QyNDgwNTQ2MWVlNWJkYmY4NjYxZGJkIn0.eyJhdWQiOiIyIiwianRpIjoiZDdmZGEzYzQ2MTI4NjI3NzE0M2U5NTlhMWY2MWYyMGIyZDEyMTE3YmM5YzVkODk4OGE2Y2JmNWVjZDI0ODA1NDYxZWU1YmRiZjg2NjFkYmQiLCJpYXQiOjE1MTMwNzIwMDAsIm5iZiI6MTUxMzA3MjAwMCwiZXhwIjoxNTE5NzM4NjYwLCJzdWIiOiIxIiwic2NvcGVzIjpbXX0.t2XH_aA2_CsiWKcPLF2eqFdH2CDEF0Yk_BnJXRF4_sP4F9F8FjZftJ5HsGxN0t2BqEPqZ9duFmxQ2svbXFslleIoYkYhxG7nGaTqJlZ2lnBBtjAulZ23tR6fhp6oEoNKqbaO_xcX1uK2Ot94LUAqjojfL7dIxol90ruPwHBJnM_YcsDBWr0q9cMr9rsmQNN78Ql3DhbkilIsbsbORxmLRHt-DDqQPEguR5n_YztOUl727Yg2FSKz-WYqcsx4oJqgVO8DrdjpI9Fp2oG-3NAYeq0rwC_ibRP0JUmD_9R9iUTR8TZRF265-ivRK8dZyqVgROU58kobIHItNrPO8pFGWWVuWkZSug-UBXxQrk75CWeSVQkITDDJ3bTDm3BBDde3AWxNf0LrjMYBMVfyJSuzQJaeHK7B23usqdRWOCkl5KjYurHLVuhwx7ExTMb23lIMSuwVtxDDPi2u9liyNkltUMwP9gEIwpfgi_wRD__042S8EiP9QhUZSHvoedJcFwJUbVtx0S0kaVoT0Gg3Yb6Rg-AleRrRjZfO9OOQeSQ-Yb70DE2wezzAEEtf1MXmHl8M7y7OxsCcdMbRXL5MnUDrctOq4HFwPP0uaxbLCZr3t3j7-2DWrQdpHixkJKHINJIUBD1KyKmkwUvCTHiZ3voqs_u52Cb-CEbLwqYaNkf9CDI"
        
        
        
        let compelteUrl = Constants.BASE_URL + "api/v1/Customers/Notifications"
        let header: HTTPHeaders = ["Accept":"application/json","Authorization":"Bearer \(DataManager.instance.accessToken!)"]
        //        let header = ["Accept":"application/json","Authorization":accessToken]
        
        print(header)
        print(compelteUrl)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .get, encoding: URLEncoding.httpBody, headers:header).response { response in
            //        Object { (response: DataResponse<Notifications>) in
            //        Alamofire.request(compelteUrl, headers:header).responseObject { (response: DataResponse<Notifications>) in
            
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                if response.response?.statusCode == 200 {
                    self.notificationObj = Mapper<Notifications>().map(JSONObject: json)
                    
                    
                    //                self.notificationObj = response.result.value
                    if self.notificationObj?.response == 2 || self.notificationObj?.response == 1 {
                        
                        self.notificationsTableView.reloadData()
                        
                    }
                    else {
                        // self.showAlert(title: "", message: (self.shopInfo?.resultDesc)!, completion: nil)
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
