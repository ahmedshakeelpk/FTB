//
//  BaseVC.swift
//  First Touch Banking
//
//  Created by Syed Uzair Ahmed on 23/11/2017.
//  Copyright © 2017 Syed Uzair Ahmed. All rights reserved.
//

import UIKit
import KYDrawerController
import Toaster
import Alamofire
import ObjectMapper
//import AlamofireObjectMapper

extension String {
    /// Encode a String to Base64
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
    
    /// Decode a String from Base64. Returns nil if unsuccessful.
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    func split(by length: Int) -> [String] {
        var startIndex = self.startIndex
        var results = [Substring]()
        
        while startIndex < self.endIndex {
            let endIndex = self.index(startIndex, offsetBy: length, limitedBy: self.endIndex) ?? self.endIndex
            results.append(self[startIndex..<endIndex])
            startIndex = endIndex
        }
        
        return results.map { String($0) }
    }
    
}

class BaseVC: UIViewController {
    
    var rootVC:UIViewController?
    var miniStatementObj:MiniStatement?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let delegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        self.rootVC = delegate.window?.rootViewController
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    public  func  popUpLogout(){
        
        let consentAlert = UIAlertController(title: "Alert", message: "Do you want to Logout?".addLocalizableString(languageCode: languageCode), preferredStyle: UIAlertControllerStyle.alert)
        
        consentAlert.addAction(UIAlertAction(title: "Yes".addLocalizableString(languageCode: languageCode), style: .default, handler: { (action: UIAlertAction!) in
            
            self.logoutUser()
            //            NotificationCenter.default.post(name: Notification.Name("batteryLevelChanged"), object: nil)
            //            print("Handle Ok logic here")
        }))
        
        consentAlert.addAction(UIAlertAction(title: "Cancel".addLocalizableString(languageCode: languageCode), style: .cancel, handler: { (action: UIAlertAction!) in
            //            print("Handle Cancel Logic here")
            self.dismiss(animated: true, completion:nil)
        }))
        //        UserDefaults.standard.set()
        self.present(consentAlert, animated: true, completion: nil)
    }
    // MARK: - Navigation
    
    @IBAction func backPressed(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func menuPressed(_ sender: UIButton){
        if let drawerController = self.parent?.parent as? KYDrawerController {
            drawerController.setDrawerState(.opened, animated: true)
        }
    }
    
    
    
    func base64EncodedString( params : [String : Any]) -> String {
        
        let base64EncodedString : String
        
        let jsonData = try! JSONSerialization.data(withJSONObject: params, options: [])
        let decodedString = String(data: jsonData, encoding: .utf8)!
        
        //          let encoder = JSONEncoder()
        //          let jsonData = (try? encoder.encode(params))!
        //          let jsonString = String(data: jsonData, encoding: .utf8)
        //            print(jsonString!)
        
        base64EncodedString = decodedString.toBase64()
        return base64EncodedString
    }
    
    // MARK: - Split String by Length
    
    func splitString(stringToSplit : String) -> (apiAttribute1:String,apiAttribute2:String) {
        
        let varLength : Int?
        var attr1 : String?
        var attr2 : String?
        
        varLength = stringToSplit.count/2
        
        let splitString = stringToSplit.split(by: varLength!)
        let arr = Array(splitString).map { String($0) }
        //        print(arr)
        
        if arr.count == 0 {
            return ("","")
        }
        
        attr1 = arr[0]
        if arr.count%2 == 0{
            attr2 = arr[1]
        }
        else{
            attr2 = arr[1] + arr[2]
        }
        
        return (attr1!,attr2!)
        
        
    }
    
    @IBAction func logOutPressed(_ sender: Any) {
        self.popUpLogout()
        
    }
    
    func setDrawerState(state: DrawerState, animated: Bool){
        
    }
    
    // MARK: - Activity Indicator
    
    public func showActivityIndicator() {
        customActivityIndicatory(self.view, startAnimate: true)
        
    }
    
    public func hideActivityIndicator() {
        customActivityIndicatory(self.view, startAnimate: false)
        
    }
    
    // MARK: - Show Alert
    
    public func showAlert (title:String, message:String, completion:CompletionBlock?){
        let customAlertVC = self.storyboard?.instantiateViewController(withIdentifier: "CustomAlertVC") as! CustomAlertVC
        customAlertVC.titleStr = title
        customAlertVC.desStr = message
        
        if completion != nil {
            customAlertVC.completionBlock = completion
        }
        else {
            customAlertVC.completionBlock = {
                self.dismiss(animated: true, completion:nil)
            }
        }
        customAlertVC.modalPresentationStyle = .overCurrentContext;
        self.rootVC?.present(customAlertVC, animated: true, completion: nil)
        
    }
    
    public func showDefaultAlert(title:String , message:String) {
        
        let alert = UIAlertController(title: title, message:message, preferredStyle: UIAlertControllerStyle.alert)
        // add an action (button)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
        }))
        // show the alert
        self.rootVC?.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Show Toast
    
    public func showToast(title:String){
        Toast(text:title, duration: Delay.long).show()
    }
    
    // MARK: - Log Out User
    
    public func logoutUser() {
        UserDefaults.standard.synchronize()
        
        DataManager.instance.accessToken = nil
        DataManager.instance.accountTitle = ""
        DataManager.instance.beneficaryTitle = nil
        DataManager.instance.imei = nil
        DataManager.instance.Latitude = nil
        DataManager.instance.Longitude = nil
        NotificationCenter.default.post(name: Notification.Name("LanguageChangeThroughObserver"), object: nil)
        reloadStoryBoard()
    }
    
    public func convertToCurrrencyFormat(amount:String) -> String{
        
        let amountReal = amount
        let numberFormatter = NumberFormatter()
        numberFormatter.groupingSeparator = ","
        numberFormatter.numberStyle = .decimal
        numberFormatter.locale = Locale(identifier:"en_PK")
        numberFormatter.generatesDecimalNumbers = true
        
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2
        
        let formattedNumber = numberFormatter.string(from: Double(amountReal)! as NSNumber)
        return ("\(formattedNumber!)")
    }
    
    
    public func reloadStoryBoard() {
        
        let delegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let storyBoardName = "Main"
        let storyBoard = UIStoryboard(name: storyBoardName,bundle: nil)
        
        languageCode = UserDefaults.standard.string(forKey: "language-Code") ?? ""
        delegate.window?.rootViewController = storyBoard.instantiateInitialViewController()
    }
    
    // MARK: - Get Mini Statement
    
    public func getMiniStatement(completionHandler: @escaping (_ result:MiniStatement) -> Void) {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        let compelteUrl = Constants.BASE_URL + "api/v1/Transactions/MiniStatement"
        
        let params = ["lat":DataManager.instance.Latitude!,"lng":DataManager.instance.Longitude!,"imei":DataManager.instance.imei!] as [String : Any]
        let header: HTTPHeaders = ["Accept":"application/json","Authorization":"Bearer \(DataManager.instance.accessToken!)"]
        
        print(params)
        print(compelteUrl)
        print(header)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: URLEncoding.httpBody, headers:header).response { response in
            //        Object { (response: DataResponse<MiniStatement>) in
            
            //        Alamofire.request(compelteUrl, method: .post, parameters: params , encoding: URLEncoding.httpBody, headers:header).responseObject { (response: DataResponse<MiniStatement>) in
            
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                self.miniStatementObj = Mapper<MiniStatement>().map(JSONObject: json)
                
                if response.response?.statusCode == 200 {
                    if self.miniStatementObj?.response == 2 || self.miniStatementObj?.response == 1 {
                        if self.miniStatementObj != nil {
                            completionHandler(self.miniStatementObj!)
                        }
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
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
extension String {
//    var languageCodes = UserDefaults.standard.string(forKey: "language-Code") ?? ""
    func addLocalizableString(languageCode:String) -> String {
        guard let path = Bundle.main.path(forResource: languageCode, ofType: "lproj") else { return "" }
        let bundle = Bundle(path: path)
        return NSLocalizedString(self, tableName: "", bundle: bundle!, value: "", comment: "")
    }
}
extension UIDevice {
    var isSimulator: Bool {
        return TARGET_OS_SIMULATOR != 0
    }
    
    var isJailBroken: Bool {
        get {
            if UIDevice.current.isSimulator { return false }
            if JailBrokenHelper.hasCydiaInstalled() { return true }
            if JailBrokenHelper.isContainsSuspiciousApps() { return true }
            if JailBrokenHelper.isSuspiciousSystemPathsExists() { return true }
            return JailBrokenHelper.canEditSystemFiles()
        }
    }
}
    
private struct JailBrokenHelper {
    static func hasCydiaInstalled() -> Bool {
        return UIApplication.shared.canOpenURL(URL(string: "cydia://")!)
    }
    
    static func isContainsSuspiciousApps() -> Bool {
        for path in suspiciousAppsPathToCheck {
            if FileManager.default.fileExists(atPath: path) {
                return true
            }
        }
        return false
    }
    
    static func isSuspiciousSystemPathsExists() -> Bool {
        for path in suspiciousSystemPathsToCheck {
            if FileManager.default.fileExists(atPath: path) {
                return true
            }
        }
        return false
    }
    
    static func canEditSystemFiles() -> Bool {
        let jailBreakText = "Developer Insider"
        do {
            try jailBreakText.write(toFile: jailBreakText, atomically: true, encoding: .utf8)
            return true
        } catch {
            return false
        }
    }
    
    /**
     Add more paths here to check for jail break
     */
    static var suspiciousAppsPathToCheck: [String] {
        return ["/Applications/Cydia.app",
                "/Applications/blackra1n.app",
                "/Applications/FakeCarrier.app",
                "/Applications/Icy.app",
                "/Applications/IntelliScreen.app",
                "/Applications/MxTube.app",
                "/Applications/RockApp.app",
                "/Applications/SBSettings.app",
                "/Applications/WinterBoard.app"
        ]
    }
    
    static var suspiciousSystemPathsToCheck: [String] {
        return ["/Library/MobileSubstrate/DynamicLibraries/LiveClock.plist",
                "/Library/MobileSubstrate/DynamicLibraries/Veency.plist",
                "/private/var/lib/apt",
                "/private/var/lib/apt/",
                "/private/var/lib/cydia",
                "/private/var/mobile/Library/SBSettings/Themes",
                "/private/var/stash",
                "/private/var/tmp/cydia.log",
                "/System/Library/LaunchDaemons/com.ikey.bbot.plist",
                "/System/Library/LaunchDaemons/com.saurik.Cydia.Startup.plist",
                "/usr/bin/sshd",
                "/usr/libexec/sftp-server",
                "/usr/sbin/sshd",
                "/etc/apt",
                "/bin/bash",
                "/Library/MobileSubstrate/MobileSubstrate.dylib"
        ]
    }
}
