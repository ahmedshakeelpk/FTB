//
//  TopUpMainVC.swift
//  First Touch Banking
//
//  Created by Syed Uzair Ahmed on 09/01/2018.
//  Copyright © 2018 Syed Uzair Ahmed. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
//import AlamofireObjectMapper

class TopUpMainVC: BaseVC , UICollectionViewDelegate , UICollectionViewDataSource {
    
    var sideBarImgsArr: [String] = ["postpaid","prepaid"]
    
    @IBOutlet var collectionView : UICollectionView!
    var billCompanyObj : BillPaymentCompanies?
    var filteredCompanies = [SingleCompany]()
    static let networkManager = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblMain.text = "Top Up".addLocalizableString(languageCode: languageCode)
        self.getBillPaymentCompanies()
        
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var lblMain: UILabel!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - CollectionView Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.filteredCompanies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let aCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopUpCollectionViewCell", for: indexPath) as! TopUpCollectionViewCell
        
        //  let aCompany = self.billCompanyObj?.companies![indexPath.row]
        let aCompany = self.filteredCompanies[indexPath.row]
        
        //   aCell.imageView.layer.cornerRadius = aCell.imageView.bounds.height / 2
        aCell.viewForImage.layer.cornerRadius = aCell.viewForImage.bounds.height / 2
        aCell.imageView.image = UIImage(named : sideBarImgsArr[indexPath.row])
        if aCompany.code == "MBP" {
            aCell.title.text = "Postpaid"
        }else{
            aCell.title.text = "Prepaid"
        }
        return aCell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        NSLog ("You selected row: %@ \(indexPath)")
        
        let aSingleItem:SingleCompany = (self.filteredCompanies[indexPath.row])
        
        print(aSingleItem.name!)
        print(aSingleItem.code!)
        
        if let code = aSingleItem.code{
            if code == "MBP"{
                
                let utilityInfoVC = self.storyboard!.instantiateViewController(withIdentifier: "UtilityBillInfoVC") as! UtilityBillInfoVC
                utilityInfoVC.companyID = aSingleItem.code!
                utilityInfoVC.mainTitle = "Postpaid"
                utilityInfoVC.isFromHome = true
                
                self.navigationController!.pushViewController(utilityInfoVC, animated: true)
            }
            else if code == "MTUP"{
                let prepaidTopUpVC = self.storyboard!.instantiateViewController(withIdentifier: "PrePaidTopUpVC") as! PrePaidTopUpVC
                prepaidTopUpVC.companyID = aSingleItem.code!
                prepaidTopUpVC.mainTitle = aSingleItem.name
                prepaidTopUpVC.isFromHome = true
                
                self.navigationController!.pushViewController(prepaidTopUpVC, animated: true)
            }
        }
    }
    
    // MARK: - API CALL
    
    private func getBillPaymentCompanies() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        let compelteUrl = Constants.BASE_URL + "api/v1/Transactions/BillPayment/Companies"
        let header: HTTPHeaders = ["Accept":"application/json","Authorization":"Bearer \(DataManager.instance.accessToken!)"]
        
        print(header)
        print(compelteUrl)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .get, encoding: URLEncoding.httpBody, headers:header).response { response in
            //            Object { (response: DataResponse<BillPaymentCompanies>) in
            //        Alamofire.request(compelteUrl, headers:header).responseObject { (response: DataResponse<BillPaymentCompanies>) in
            //            
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                self.billCompanyObj = Mapper<BillPaymentCompanies>().map(JSONObject: json)
                if response.response?.statusCode == 200 {
                    
                    if self.billCompanyObj?.response == 2 || self.billCompanyObj?.response == 1 {
                        
                        for aCompany in (self.billCompanyObj?.companies)!{
                            if aCompany.code == "MBP" || aCompany.code == "MTUP"{
                                self.filteredCompanies.append(aCompany)
                            }
                        }
                        self.collectionView.reloadData()
                        
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

