//
//  TransportListVC.swift
//  First Touch Banking
//
//  Created by Syed Uzair Ahmed on 20/11/2018.
//  Copyright © 2018 Syed Uzair Ahmed. All rights reserved.
//

import UIKit
import Alamofire
//import AlamofireObjectMapper
import Nuke
import ObjectMapper

class TransportListVC: BaseVC , UITableViewDelegate , UITableViewDataSource{
    
    @IBOutlet var transportListTableView: UITableView!
   var transportListObj : TransportListModel?
    
    @IBOutlet weak var lblmain: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblmain.text = "Transport List".addLocalizableString(languageCode: languageCode)
        self.getTransportList()
    }
    
    // MARK: - Table View Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let count = self.transportListObj?.transport?.count {
            return count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let aCell = tableView.dequeueReusableCell(withIdentifier: "MoviesListTableViewCell") as! MoviesListTableViewCell
        aCell.selectionStyle = .none
        
        let aTransport = self.transportListObj?.transport![indexPath.row]
        
        aCell.lblMovieTitle.text = aTransport?.service_name
        aCell.lblMovieGenre.text = aTransport?.address
        aCell.lblLength.text = aTransport?.phone
        
        let url = URL(string: (aTransport?.thumbnail)!)
        if let imgUrl = url{
            Nuke.loadImage(with: imgUrl, into: aCell.imgMovieThumbnail)
        }
        
        return aCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let aTransport:SingleTransport = (self.transportListObj?.transport![indexPath.row])!
        
        NSLog ("You selected row: %@ \(indexPath)")
        
        let transSelectedVC = self.storyboard!.instantiateViewController(withIdentifier: "TransportSelectedVC") as! TransportSelectedVC
        transSelectedVC.serviceID = aTransport.service_id
        self.navigationController!.pushViewController(transSelectedVC, animated: true)
        print("Service Id : \(aTransport.service_id))")
        print("Service Name : \(aTransport.service_name))")
        print("Address : \(aTransport.address))")
        print("Phone : \(aTransport.phone))")
        print("C Phone : \(aTransport.c_phone))")
        print("Status : \(aTransport.status))")
        print("Cod : \(aTransport.cod))")
        print("Flexifare : \(aTransport.flexifare))")
        print("Thumbnail : \(aTransport.thumbnail))")
        print("Background : \(aTransport.background))")
        print("Background img : \(aTransport.background_img))")
        print("Facilities : \(aTransport.facilities))")
        print("Careem : \(aTransport.careem))")
    }

    // MARK: - API Call
    
    private func getTransportList() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        //      let compelteUrl = Constants.BASE_URL + "api/v1/BookMe/Movies"
        let compelteUrl = "http://59.103.248.78:8070/api/v1/BookMe/TransportServices"
        //      let header = ["Accept":"application/json","Authorization":"Bearer \(DataManager.instance.accessToken!)"]
        
        let header: HTTPHeaders = ["Accept":"application/json","Authorization":"Bearer \(DataManager.instance.tempAccessToken!)"]
        
        print(header)
        print(compelteUrl)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .get, encoding: URLEncoding.httpBody, headers:header).response {response in
            //            Object { (response: DataResponse<TransportListModel>) in
            
            //        Alamofire.request(compelteUrl, headers:header).responseObject { (response: DataResponse<TransportListModel>) in
            
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                if response.response?.statusCode == 200 {
                    self.transportListObj = Mapper<TransportListModel>().map(JSONObject: json)
                    
                    if self.transportListObj?.response == 2 || self.transportListObj?.response == 1 {
                        self.transportListTableView.reloadData()
                    }
                    else {
                        // self.showAlert(title: "", message: (self.shopInfo?.resultDesc)!, completion: nil)
                    }
                }
                else {
                    //                print(response.result.value)
                    print(response.response?.statusCode)
                }
            }
        }
    }
}
