//
//  UtilityBillMainVC.swift
//  First Touch Banking
//
//  Created by Syed Uzair Ahmed on 09/01/2018.
//  Copyright © 2018 Syed Uzair Ahmed. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
//import AlamofireObjectMapper

class UtilityBillMainVC: BaseVC , UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    var sideBarImgsArr: [String] = ["1Bill","broadband","education","electricity","gas","gov","insurance","investment","landline","onlineshopping","water","careem"]
    
    
    @IBOutlet weak var lblmain: UILabel!
    @IBOutlet var collectionView : UICollectionView!
    var billCompanyObj : BillPaymentCompanies?
    var filteredCompanies = [SingleCompany]()
    static let networkManager = NetworkManager()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        lblmain.text = "Utility Bill Payments".addLocalizableString(languageCode: languageCode)
        self.getBillPaymentCompanies()
       
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - CollectionView Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.filteredCompanies.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let aCell = collectionView.dequeueReusableCell(withReuseIdentifier: "UtilityBillCollectionViewCell", for: indexPath) as! UtilityBillCollectionViewCell
        
        
        let aCompany = self.filteredCompanies[indexPath.row]
        
        print(aCompany.name)
        print(aCompany.code)
        
        
        aCell.viewForImage.layer.cornerRadius = aCell.viewForImage.bounds.height / 2
        
         if sideBarImgsArr.count > indexPath.row{
                   
                   if aCompany.code == "1Bill"{
                       aCell.imageView.image = UIImage(named: "1Bill")
                   }
                   if aCompany.code == "BBP"{
                       aCell.imageView.image = UIImage(named: "broadband")
                   }
                   if aCompany.code == "CAREEM"{
                       aCell.imageView.image = UIImage(named: "careem")
                   }
                   if aCompany.code == "EP"{
                       aCell.imageView.image = UIImage(named: "education")
                   }
                   if aCompany.code == "EBP"{
                       aCell.imageView.image = UIImage(named: "electricity")
                   }
                   if aCompany.code == "GBP"{
                       aCell.imageView.image = UIImage(named: "gas")
                   }
                   if aCompany.code == "GOV"{
                       aCell.imageView.image = UIImage(named: "gov")
                   }
                   if aCompany.code == "IP"{
                       aCell.imageView.image = UIImage(named: "insurance")
                   }
                   if aCompany.code == "IBP"{
                       aCell.imageView.image = UIImage(named: "investment")
                   }
                   if aCompany.code == "LBP"{
                       aCell.imageView.image = UIImage(named: "landline")
                   }
                   if aCompany.name == "Online Shopping"{
                       aCell.imageView.image = UIImage(named: "onlineshopping")
                   }
                   if aCompany.code == "WBP"{
                       aCell.imageView.image = UIImage(named: "water")
                   }
               }
               else{
                   
                   aCell.imageView.image = UIImage(named: "water")
               }
        
        aCell.title.text = aCompany.name
        
        return aCell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        NSLog ("You selected row: %@ \(indexPath)")
        
        let aSingleItem:SingleCompany = (self.filteredCompanies[indexPath.row])
        
        print(aSingleItem.name!)
        print(aSingleItem.code!)
        
        let utilityInfoVC = self.storyboard!.instantiateViewController(withIdentifier: "UtilityBillInfoVC") as! UtilityBillInfoVC
        utilityInfoVC.companyID = aSingleItem.code!
        utilityInfoVC.mainTitle = aSingleItem.name
        utilityInfoVC.isFromHome = true
        
        //        ibftFundConfirmVC.sourceAccount = self.sourceAccount
        //        ibftFundConfirmVC.beneficaryAccount = self.accountNumberTextField.text
        //        ibftFundConfirmVC.transferAmount = self.ammountTextField.text
        //        ibftFundConfirmVC.beneficaryBankName = self.sourceBank
        
        //        let title = self.sourceBank
        //        for aBank in self.banksList {
        //            if aBank.name == title {
        //                ibftFundConfirmVC.singleBank = aBank
        //            }
        //        }
        self.navigationController!.pushViewController(utilityInfoVC, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let screenWidth = UIScreen.main.bounds.width
        let scaleFactor = (screenWidth / 3) - 6
        
        return CGSize(width: scaleFactor, height: scaleFactor)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: CGFloat(5.0), left: CGFloat(0.0), bottom: CGFloat(5.0), right: CGFloat(0.0))
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
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
            
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                self.billCompanyObj = Mapper<BillPaymentCompanies>().map(JSONObject: json)
                if response.response?.statusCode == 200 {
                    
                    if self.billCompanyObj?.response == 2 || self.billCompanyObj?.response == 1 {
                        
                        for aCompany in (self.billCompanyObj?.companies)!{
                            if aCompany.code != "MBP" && aCompany.code != "MTUP"{
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

//extension UtilityBillMainVC: UICollectionViewDelegateFlowLayout{
//
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
//    {
//        var collectionViewSize = collectionView.frame.size
//        collectionViewSize.width = collectionViewSize.width/3.0 //Display Three elements in a row.
//        collectionViewSize.height = collectionViewSize.height/4.0
//        return collectionViewSize
//}
//}

