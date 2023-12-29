//
//  DonationsMainVC.swift
//  First Touch Banking
//
//  Created by Syed Uzair Ahmed on 29/04/2020.
//  Copyright © 2020 Syed Uzair Ahmed. All rights reserved.
//

import UIKit
import Alamofire
//import AlamofireObjectMapper

class DonationsMainVC: BaseVC , UITableViewDelegate , UITableViewDataSource{
    
    @IBOutlet var donationsTableView: UITableView!
    
    var arrList = ["DIAMER-BASHA AND MOHMAND DAMS FUND", "COVID-19 FUND 2020"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    // MARK: - Table View Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let aCell = tableView.dequeueReusableCell(withIdentifier: "DonationsTableViewCell") as! DonationsTableViewCell
        aCell.selectionStyle = .none

        aCell.lblTitle.text = arrList[indexPath.row]
        return aCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        NSLog ("You selected row: %@ \(indexPath)")
        
        if indexPath.row == 1 {
            let interBankFundVC = self.storyboard!.instantiateViewController(withIdentifier: "InterBankFundTransferVC") as! InterBankFundTransferVC
            interBankFundVC.varBeneAccountNum = "4162786786"
            interBankFundVC.sourceBank = "National Bank of Pakistan"
            interBankFundVC.sourceReasonForTrans = "Donations Charity"
            interBankFundVC.isFromQuickPay = true
            interBankFundVC.isFromHome = false
            interBankFundVC.isFromDonations = true
            self.navigationController!.pushViewController(interBankFundVC, animated: true)
        }
        
        if indexPath.row == 0 {
            
            let localFundVC = self.storyboard!.instantiateViewController(withIdentifier: "LocalFundsTransferVC") as! LocalFundsTransferVC
            localFundVC.beneficiaryAccount = "0021011474997014"
            localFundVC.isFromQuickPay = true
            self.navigationController!.pushViewController(localFundVC, animated: true)
            
        }
    
    }

}
