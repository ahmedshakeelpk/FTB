//
//  AgentLocatorVC.swift
//  First Touch Banking
//
//  Created by Syed Uzair Ahmed on 12/12/2017.
//  Copyright © 2017 Syed Uzair Ahmed. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
//import AlamofireObjectMapper

class AgentLocatorVC: BaseVC , UITableViewDelegate , UITableViewDataSource ,UISearchResultsUpdating  {
    
    @IBOutlet var agentTableView: UITableView!
    var agentObj : AgentLocator?
    var filteredObjects = [SingleAgentLocator]()
    let searchController = UISearchController(searchResultsController: nil)
    static let networkManager = NetworkManager()

    @IBOutlet weak var lblmain: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        lblmain.text = "Agent Locator".addLocalizableString(languageCode: languageCode)
        
        self.agentTableView.rowHeight = UITableViewAutomaticDimension
        self.agentTableView.estimatedRowHeight = 130.0
        self.getAgentLocations()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchController.dismiss(animated: false, completion: nil)
    }
    
    func updateResults(){
        
        self.filteredObjects = (self.agentObj?.agentLocators)!
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.definesPresentationContext = true
        self.searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.barTintColor = #colorLiteral(red: 0.2156862745, green: 0.4823529412, blue: 0.737254902, alpha: 1)
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.agentTableView.tableHeaderView = searchController.searchBar
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        if searchController.searchBar.text == ""{
            self.filteredObjects = (self.agentObj?.agentLocators)!
        }
        else{
            self.filteredObjects = (self.agentObj?.agentLocators?.filter {
                $0.name?.lowercased().range(of: searchController.searchBar.text!.lowercased()) != nil
                })!
        }
        
        self.agentTableView.reloadData()
    }
    
    
    // MARK: - Table View Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //            if let count = self.agentObj?.agentLocators?.count {
        //                return count
        //            }
        
        return self.filteredObjects.count
        
        //return (self.notificationsObj?.notifications?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let aCell = tableView.dequeueReusableCell(withIdentifier: "AgentLocatorTableViewCell") as! AgentLocatorTableViewCell
        aCell.selectionStyle = .none
        
//        let aAtm = self.agentObj?.agentLocators![indexPath.row]
        
        aCell.lblAgentTitle.text = self.filteredObjects[indexPath.row].name
        aCell.lblAgentAddress.text = self.filteredObjects[indexPath.row].address

        
//        aCell.lblAgentTitle.text = aAtm?.name
        
        return aCell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        NSLog ("You selected row: %@ \(indexPath)")
        
        let aValue:SingleAgentLocator = (self.agentObj?.agentLocators![indexPath.row])!
        
//        let detailsVC = self.storyboard?.instantiateViewController(withIdentifier: "CustomAlertVC") as! CustomAlertVC
//        detailsVC.titleStr = aValue.name
//        detailsVC.desStr = aValue.address
        
        print(aValue.lat)
        print(aValue.lng)
        
        self.seeOnMap(lat: aValue.lat!, long: aValue.lng!)
        
//        detailsVC.modalPresentationStyle = .overCurrentContext;
//        self.rootVC?.present(detailsVC, animated: true, completion: nil)
    }
    
    // MARK: - Action Method

    private func seeOnMap(lat:Double , long:Double){
        
        let actionSheetController = UIAlertController(title:"Please select", message:"your desired", preferredStyle: .actionSheet)
        
        // Create and add the Cancel action
        let cancelAction = UIAlertAction(title:"Cancel", style: .cancel) { action -> Void in
            actionSheetController.dismiss(animated: true, completion: nil)
            self.dismiss(animated: true, completion: nil)
        }
        actionSheetController.addAction(cancelAction)
        // Create and add first option action
        let pdfAction = UIAlertAction(title: "Apple Maps", style: .default) { action -> Void in
            self.goToApple(lat: lat, long: long)
        }
        actionSheetController.addAction(pdfAction)
        
        // Create and add a second option action
        let excelAction = UIAlertAction(title: "Google Maps", style: .default) { action -> Void in
            self.goToGoogle(lat: lat, long: long)
        }
        actionSheetController.addAction(excelAction)
        self.rootVC?.present(actionSheetController, animated: true, completion: nil)
        

    }
    
    private func goToGoogle(lat:Double , long:Double){
                print("Go to Google Maps")
        
                if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
                    UIApplication.shared.openURL(NSURL(string:
                        "comgooglemaps://?saddr=&daddr=\(Float(lat)),\(Float(long))&directionsmode=driving")! as URL)
                }
                else {
                    self.showAlert(title: "", message: "Google Maps app is not installed", completion: nil)
                }
    }
    private func goToApple(lat:Double , long:Double){
        print("Go to Apple Maps")
        
        if (UIApplication.shared.canOpenURL(URL(string:"http://maps.apple.com")!)) {
            UIApplication.shared.openURL(NSURL(string:
                "http://maps.apple.com/maps?daddr=\(Float(lat)),\(Float(long))")! as URL)
        }
        else {
            self.showAlert(title: "", message: "Maps app is not installed", completion: nil)
        }

    }
    
    // MARK: - API CALL
    
    
    private func getAgentLocations() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        showActivityIndicator()
        
        
        let compelteUrl = Constants.BASE_URL + "api/v1/Locations/Agent"
        let header: HTTPHeaders = ["Accept":"application/json"]
        
        print(header)
        print(compelteUrl)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .get, encoding: URLEncoding.httpBody, headers:header).response { response in
            //        Object { (response: DataResponse<AgentLocator>) in
            //        Alamofire.request(compelteUrl, headers:header).responseObject { (response: DataResponse<AgentLocator>) in
            
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                if response.response?.statusCode == 200 {
                    self.agentObj = Mapper<AgentLocator>().map(JSONObject: json)
                    
                    self.updateResults()
                    self.agentTableView.reloadData()
                }
                else {
                    //                print(response.result.value)
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
