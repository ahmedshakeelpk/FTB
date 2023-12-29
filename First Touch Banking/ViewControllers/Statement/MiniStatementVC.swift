//
//  MiniStatementVC.swift
//  First Touch Banking
//
//  Created by Syed Uzair Ahmed on 13/12/2017.
//  Copyright © 2017 Syed Uzair Ahmed. All rights reserved.
//

import UIKit
import Alamofire
//import AlamofireObjectMapper
import SkyFloatingLabelTextField


class MiniStatementVC: BaseVC , UITableViewDelegate , UITableViewDataSource {

    @IBOutlet var miniStatementTableView: UITableView!
    @IBOutlet weak var lblBalance: UILabel!
    var balanceAmount:String?
    
    @IBOutlet weak var lblmain: UILabel!
    static let networkManager = NetworkManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        lblmain.text = "Mini Statement".addLocalizableString(languageCode: languageCode)
        lblbalnce.text = "Balance".addLocalizableString(languageCode: languageCode)
        self.updateUI()
        self.getMiniStatement(completionHandler: {(result:MiniStatement) in
            self.miniStatementTableView.reloadData()
        })
        self.miniStatementTableView.addSubview(self.refreshControl)

    }
    
    @IBOutlet weak var lblbalnce: UILabel!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func updateUI(){
//        if let balance = balanceAmount{
//            self.lblBalance.text = "PKR \(balance)"
//        }
        if let balance = balanceAmount{
            self.lblBalance.text = "PKR \(convertToCurrrencyFormat(amount:balance))"
        }
        
        
    }
    
    //MARK: - Utility Methods
    
    func convertDateFormater(_ date: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ddMMyyyy"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "dd-MMM-yyyy" // MMM d, yyyy
        return  dateFormatter.string(from: date!)
        
    }
    
    // MARK: -  Pull to Refresh
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh),for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.gray
        return refreshControl
    }()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.getMiniStatement(completionHandler: {(result:MiniStatement) in
            self.miniStatementTableView.reloadData()
        })
        
        refreshControl.endRefreshing()
    }
    
    // MARK: - Table View Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let count = self.miniStatementObj?.ministatement?.count{
            return count
        }
        return 0
        
        //return (self.notificationsObj?.notifications?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let aCell = tableView.dequeueReusableCell(withIdentifier: "MiniStatementTableViewCell") as! MiniStatementTableViewCell
        aCell.selectionStyle = .none
        
        //            let aStatement = miniStatementObj?.ministatement[indexpath]
        //            if let lastTrans = aStatement.lcy_amount{
        //            }
       
        let aStatement = self.miniStatementObj?.ministatement![indexPath.row]
        aCell.lblTitle.text = aStatement?.trn_des
        aCell.lblDate.text = convertDateFormater((aStatement?.trn_dt)!)
//        aCell.lblDate.text = aStatement?.trn_dt
//        aCell.lblType.text = aStatement?.drcr_ind
        if aStatement?.drcr_ind == "C"{
            aCell.lblType.text = "Credit"
            aCell.lblAmount.textColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            aCell.imgCreditDebit.image = UIImage(named: "arrow_credit")
        }
        else if aStatement?.drcr_ind == "D" {
            aCell.lblType.text = "Debit"
            aCell.lblAmount.textColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
            aCell.imgCreditDebit.image = #imageLiteral(resourceName: "arrow_debits")
        }
        if let amount = aStatement?.lcy_amount{
             aCell.lblAmount.text = "PKR \(amount)"
        }
       
        
        return aCell;
    }

}
