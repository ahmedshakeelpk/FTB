//
//  LoginVC.swift
//  First Touch Banking
//
//  Created by Syed Uzair Ahmed on 23/11/2017.
//  Copyright © 2017 Syed Uzair Ahmed. All rights reserved.
//

import UIKit
import KYDrawerController
import Alamofire
//import AlamofireObjectMapper
import MapKit
import PinCodeTextField
import SwiftKeychainWrapper
import LocalAuthentication
import Crashlytics
import CoreLocation
import SafariServices
import Security
import ObjectMapper
//import FingerprintSDK

//extension LoginVC: FingerprintResponseDelegate {
//    func onScanComplete(fingerprintResponse: FingerprintResponse) {
//        //Shakeel ! added
//
//    }
//
//    override func motionCancelled(_ motion: UIEventSubtype, with event: UIEvent?) {
//        self.dismiss(animated: true)
//    }
//}


class LoginVC: BaseVC , CLLocationManagerDelegate {
    var kSecClassGZenericpassword: CFString!
    
    
    
    @IBOutlet weak var btnlogin: FTBButton!
    @IBOutlet weak var lblFirstAwz: UILabel!
    @IBOutlet weak var lbllOnginWith: UILabel!
    @IBOutlet weak var lblEnterPass: UILabel!
    @IBOutlet weak var pinTextField: PinCodeTextField!
    var tokenObj:AcessAndRefreshToken?
    var locationManagerObj = CLLocationManager()
    var currentLocation: CLLocation!
    var clientID = "2"
    
    
    var viaBio : Bool = false
    var locationEnabled : Bool = true
    static let networkManager = NetworkManager()
    @IBOutlet weak var lblCurrentBalanceAccountPreview: CLTypingLabel!
    var balanceObj:BalanceInquiry?
    @IBOutlet weak var btnTapHereReveal: UIButton!
    @IBOutlet weak var btnSignUp: UIButton!
    
    @IBOutlet weak var btnSignup: UIButton!
    @IBOutlet weak var btnfotgetPass: UIButton!
    var getLocationIP : GetIpLocationModel?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ChangeLanguage()
        pinTextField.keyboardType = .asciiCapable
        self.lblCurrentBalanceAccountPreview.isHidden = true
        print(UIDevice.current.name)
        print(UIDevice.current.model)
        
        if !KeychainWrapper.standard.hasValue(forKey: "userCnic"){
            // self.btnSignUp.isHidden = false
            self.showToast(title: "Please register yourself first")
            let registerVC = self.storyboard!.instantiateViewController(withIdentifier: "RegistrationVC") as! RegistrationVC
            registerVC.fromScreen = "signup"
            self.navigationController!.pushViewController(registerVC, animated: true)
        }
        
        //  IPA
        
        let udid = KeyChainUtils.getUUID()!
        print(udid)
        DataManager.instance.imei = udid
        //      DataManager.instance.imei = String(describing: UIDevice.current.identifierForVendor!)
        print(DataManager.instance.imei!)
        
        pinTextField.delegate = self
        //        pinTextField.keyboardType = .namePhonePad
        
        
        let addr = getWiFiAddress()
        if !addr.isEmpty{
            DataManager.instance.ipAddress = addr[0]
            print(DataManager.instance.ipAddress!)
        }
        else{
            DataManager.instance.ipAddress = ""
            print("No Address")
        }
        
        NotificationCenter.default.addObserver(self, selector:#selector(locationCheck), name: NSNotification.Name.UIApplicationWillEnterForeground, object: UIApplication.shared)
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
        
    }
    
    @IBOutlet weak var lblOR: UILabel!
    func ChangeLanguage()
    {
        lblOR.text = "OR".addLocalizableString(languageCode: languageCode)
        lblEnterPass.text = "Enter Your Password".addLocalizableString(languageCode: languageCode)
        lbllOnginWith.text = "Login With Touch ID/faceID".addLocalizableString(languageCode: languageCode)
        lblFirstAwz.text = "Awaaz".addLocalizableString(languageCode: languageCode)
        btnlogin.setTitle("LOGIN".addLocalizableString(languageCode: languageCode), for: .normal)
        btnfotgetPass.setTitle("FORGOT PASSWORD".addLocalizableString(languageCode: languageCode), for: .normal)
        btnSignup.setTitle("SIGN UP".addLocalizableString(languageCode: languageCode), for: .normal)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.locationCheck()
        
        if KeychainWrapper.standard.bool(forKey: "showAccountPreview") == true {
            //            self.lblCurrentBalanceAccountPreview.isHidden = false
            self.btnTapHereReveal.isHidden = false
            print("true")
        }
        else {
            //            self.lblCurrentBalanceAccountPreview.isHidden = true
            self.btnTapHereReveal.isHidden = true
            print("false")
        }
        
        if self.lblCurrentBalanceAccountPreview.isHidden == false{
            self.btnTapHereReveal.isHidden = true
        }
        else{
            self.btnTapHereReveal.isHidden = false
        }
        
        if DataManager.instance.isFromRegisteration == true {
            self.perform(#selector(self.showWelcomeNote),with:nil, afterDelay:1.0)
            
        }
        //        else {
        //            self.perform(#selector(self.loginActionviaTouchID(_:)),with:nil, afterDelay:0.7)
        //        }
    }
    
    
    @objc private func showWelcomeNote(){
        self.showDefaultAlert(title: "", message: "Welcome to Access Banking")
    }
    
    private func getLocationViaIp() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        let compelteUrl = "http://ip-api.com/json/"
        let header: HTTPHeaders = ["Accept":"application/json"]
        
        print(header)
        print(compelteUrl)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .get, encoding: URLEncoding.httpBody, headers:header).response { response in
            //        Object { (response: DataResponse<GetIpLocationModel>) in
            //        Alamofire.request(compelteUrl, headers:header).responseObject { (response: DataResponse<GetIpLocationModel>) in
            //
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                if response.response?.statusCode == 200 {
                    self.getLocationIP = Mapper<GetIpLocationModel>().map(JSONObject: json)
                    
                    if let lat = self.getLocationIP?.lat{
                        DataManager.instance.Latitude = lat.rounded()
                    }
                    if let lon = self.getLocationIP?.lon{
                        DataManager.instance.Longitude = lon.rounded()
                    }
                }
                else {
                    //                print(response.result.value)
                    print(response.response?.statusCode)
                }
            }
        }
    }
    
    
    //MARK: - Get IP Address
    
    func getWiFiAddress() -> [String] {
        
        var addresses = [String]()
        
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return [] }
        guard let firstAddr = ifaddr else { return [] }
        
        // For each interface ...
        for ptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let flags = Int32(ptr.pointee.ifa_flags)
            var addr = ptr.pointee.ifa_addr.pointee
            
            // Check for running IPv4, IPv6 interfaces. Skip the loopback interface.
            if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                    
                    // Convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),
                                    nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                        let address = String(cString: hostname)
                        addresses.append(address)
                    }
                }
            }
        }
        
        freeifaddrs(ifaddr)
        return addresses
    }
    
    @objc func locationCheck(){
        
        if !hasLocationPermission() {
            //self.showLocationDisabledPopUp()
            
            self.getLocationViaIp()
        }
        
        self.getCurrentLoc()
    }
    
    
    //MARK: - Get Current Location
    
    private func getCurrentLoc(){
        
        // For use when the app is open & in the background
        locationManagerObj.requestAlwaysAuthorization()
        locationManagerObj.requestWhenInUseAuthorization()
        // If location services is enabled get the users location
        if CLLocationManager.locationServicesEnabled() {
            locationManagerObj.delegate = self
            locationManagerObj.desiredAccuracy = kCLLocationAccuracyBest // You can change the locaiton accuary here.
            locationManagerObj.startUpdatingLocation()
        }
        //        locationManagerObj.delegate = self
        //        locationManagerObj.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    // Print out the location to the console
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            
            DataManager.instance.Latitude = location.coordinate.latitude.rounded()
            DataManager.instance.Longitude = location.coordinate.longitude.rounded()
            print(location.coordinate)
            print(location.coordinate.latitude.rounded())
            print(location.coordinate.longitude.rounded())
        }
    }
    
    // If we have been deined access give the user the option to change it
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if(status == CLAuthorizationStatus.denied) {
            self.getLocationViaIp()
        }
    }
    
    // Show the popup to the user if we have been deined access
    //    func showLocationDisabledPopUp() {
    //        let alertController = UIAlertController(title: "Background Location Access Disabled",
    //                                                message: "Location is required to secure the transaction history & it is always private",
    //                                                preferredStyle: .alert)
    //
    ////        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    ////        alertController.addAction(cancelAction)
    ////
    //        let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
    //            if let url = URL(string: UIApplicationOpenSettingsURLString) {
    //                if #available(iOS 10.0, *) {
    //                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
    //                } else {
    //                    // Fallback on earlier versions
    //                    UIApplication.shared.openURL(url)
    //                }
    //            }
    //        }
    //        alertController.addAction(openAction)
    //
    //        self.present(alertController, animated: true, completion: nil)
    //    }
    
    func hasLocationPermission() -> Bool {
        var hasPermission = false
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                hasPermission = false
            case .authorizedAlways, .authorizedWhenInUse:
                hasPermission = true
            }
        } else {
            hasPermission = false
        }
        
        return hasPermission
    }
    
    //    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    //        if status == .authorizedAlways || status == .authorizedWhenInUse{
    //            manager.startUpdatingLocation()
    //        }
    //        else{
    //            manager.requestWhenInUseAuthorization()
    //        }
    //    }
    
    //    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    //
    //
    //        if let location = locations.last{
    //            let myLocation = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
    //
    ////            DataManager.instance.Latitude = myLocation.latitude.rounded()
    ////            DataManager.instance.Longitude = myLocation.longitude.rounded()
    //
    //            var Latitude:Double?
    //            var Longitude:Double?
    //
    //
    //
    //            Latitude = myLocation.latitude
    //            Longitude = myLocation.longitude
    //
    //            if Latitude != nil{
    //                DataManager.instance.Latitude = Latitude
    //            }
    //            else {
    //                DataManager.instance.Latitude = Double("0.00")
    //            }
    //            if Longitude != nil {
    //                DataManager.instance.Longitude = Longitude
    //            }
    //            else{
    //                DataManager.instance.Longitude = Double("0.00")
    //            }
    //
    //
    //            if !NetworkConnectivity.isConnectedToInternet(){
    //                self.showToast(title: "No Internet Available")
    //                self.logoutUser()
    //                return
    //            }
    //
    //
    ////            let Fakelocation = CLLocation(latitude: Double("34.0151")!, longitude: Double("71.5249")!)
    //
    //            // Get user's current location name
    //            let geocoder = CLGeocoder()
    //            geocoder.reverseGeocodeLocation(location) { (placemarksArray, error) in
    ////                geocoder.reverseGeocodeLocation(Fakelocation) { (placemarksArray, error) in
    //
    //                if (placemarksArray == nil || (placemarksArray?.isEmpty)!)  {
    //                    self.showToast(title: "Check your Internet Connection")
    //                    return
    //                }
    //
    //                if (placemarksArray?.count)! > 0 {
    //
    //                    let placemark = placemarksArray?.first
    ////                    let number = placemark!.subThoroughfare
    ////                    let bairro = placemark!.subLocality
    ////                    let street = placemark!.thoroughfare
    //                    let city = placemark?.locality
    //                    if let cityName = city{
    //                        DataManager.instance.CityName = cityName
    //                    }
    //          //    print("\(number) \(bairro) \(street) \(city!)")
    //                    //      self.addressLabel.text = "\(street!), \(number!) - \(bairro!)"
    //                }
    //                else{
    //                    self.showToast(title: "Problem with the data received from GPS")
    //                }
    //            }
    //
    //            print("DataManager Lat : \(DataManager.instance.Latitude!)")
    //            print("DataManager Long : \(DataManager.instance.Longitude!)")
    //
    //            manager.stopUpdatingLocation()
    //        }
    //    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while updating location " + error.localizedDescription)
    }
    
    //    private func getLocation(){
    //
    //        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
    //            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
    //            currentLocation = locationManagerObj.location
    //
    //            DataManager.instance.Latitude = currentLocation.coordinate.latitude.rounded()
    //            DataManager.instance.Longitude = currentLocation.coordinate.longitude.rounded()
    //
    //            print("DataManager Lat : \(DataManager.instance.Latitude!)")
    //            print("DataManager Long : \(DataManager.instance.Longitude!)")
    //
    //        }
    //    }
    
    //MARK: - Utility Methods
    
    private func navigateToHome(){
        
        let mainViewController   = self.storyboard!.instantiateViewController(withIdentifier: "HomeNavCntlr") as! UINavigationController
        let drawerViewController = self.storyboard!.instantiateViewController(withIdentifier: "SideDrawerVC") as! SideDrawerVC
        var drawerController:KYDrawerController? = nil
        
        //        if Localize.currentLanguage() == "ar" {
        //            drawerController = KYDrawerController(drawerDirection: .right,drawerWidth: 290)
        //        }
        //        else {
        //            drawerController = KYDrawerController(drawerDirection: .left,drawerWidth: 290)
        //        }
        drawerController = KYDrawerController(drawerDirection: .left,drawerWidth: 290)
        drawerController!.mainViewController = mainViewController
        drawerController!.drawerViewController = drawerViewController
        self.navigationController! .pushViewController(drawerController!, animated: true)
    }
    
    //MARK: - TextField Delegates
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        //        if range.length + range.location > (textField.text?.characters.count)! {
        //            return false
        //        }
        //        let newLength:Int = (textField.text?.characters.count)! + string.characters.count - range.length
        if string.isEmpty {
            return true
        }
        let alphaNumericRegEx = "[a-zA-Z0-9]"
        let predicate = NSPredicate(format:"SELF MATCHES %@", alphaNumericRegEx)
        return predicate.evaluate(with: string)
        
        if range.length + range.location > (textField.text?.count)!{
            return false
        }
        let newLength:Int = (textField.text?.count)! + string.count - range.length
        //        uncommit
        //        if newLength == 6 {
        //            self.getAcessAndRefreshToken()
        //        }
        
        
        
        
        return true
    }
    //MARK: - Touch ID Implementations
    
    func authenticateUserViaTouchID() {
        
        let touchIDManager = PITouchIDManager()
        
        touchIDManager.authenticateUser(success: { () -> () in
            OperationQueue.main.addOperation({ () -> Void in
                self.getAcessAndRefreshToken()
            })
        }, failure: { (evaluationError: NSError) -> () in
            switch evaluationError.code {
            case LAError.Code.systemCancel.rawValue:
                print("Authentication cancelled by the system")
                self.showToast(title: "Authentication cancelled by the system")
            case LAError.Code.userCancel.rawValue:
                print("Authentication cancelled by the user")
                self.viaBio = false
                self.showToast(title: "Authentication cancelled by the user")
            case LAError.Code.userFallback.rawValue:
                print("User wants to use a password")
                OperationQueue.main.addOperation({ () -> Void in
                })
            case LAError.Code.touchIDNotEnrolled.rawValue:
                print("TouchID not enrolled") 
                self.showToast(title: "TouchID not enrolled")
            case LAError.Code.passcodeNotSet.rawValue:
                print("Passcode not set")
                self.showToast(title: "Passcode not set")
            default:
                print("Authentication failed")
                self.showToast(title: "Authentication failed")
                OperationQueue.main.addOperation({ () -> Void in
                })
            }
        })
    }
    
    //MARK: - IBActions
    
    @IBAction func firstAwaazPressed(_ sender: Any) {
        
        let url = URL(string: "https://awaz.hblmfb.com/")
        let vc = SFSafariViewController(url: url!)
        present(vc, animated: true, completion: nil)
        
        //        let webVC = self.storyboard?.instantiateViewController(withIdentifier:"WebViewVC") as! WebViewVC
        //        webVC.fileURL = "http://firstawaaz.fmfb.pk/"
        //        webVC.forAwaaz = true
        //        self.navigationController?.pushViewController(webVC, animated: true)
    }
    
    @IBAction func tapHereToReveal(_ sender: Any) {
        if KeychainWrapper.standard.bool(forKey: "showAccountPreview") == true {
            self.getBalancePreference()
            print("true")
        }
        else{
            self.showDefaultAlert(title: "Alert", message: "Activate it from Account Preview")
        }
    }
    
    @IBAction func loginActionviaTouchID(_ sender: Any) {
        
        if KeychainWrapper.standard.bool(forKey: "enableTouchID") == true {
            self.authenticateUserViaTouchID()
            viaBio = true
            print("true")
        }
        else {
            self.showToast(title: "Please Enable TouchID/FaceID by logging in with your PIN")
            print("false")
        }
        
    }
    @IBAction func loginAction(_ sender: Any) {
        
        if pinTextField.text?.count == 0  {
            self.showToast(title: "Please Enter Your Pin")
            return
        }
        if pinTextField.text == nil && viaBio == false {
            self.showToast(title: "Please Enter Your Pin")
            return
        }
        print("Pin: \(pinTextField.text)")
        self.getAcessAndRefreshToken()
        //navigateToHome()
    }
    
    @IBAction func signUpAction(_ sender: Any) {
        let registerVC = self.storyboard!.instantiateViewController(withIdentifier: "RegistrationVC") as! RegistrationVC
        registerVC.fromScreen = "signup"
        self.navigationController!.pushViewController(registerVC, animated: true)
        
    }
    @IBAction func forgotAction(_ sender: Any) {
        let registerVC = self.storyboard!.instantiateViewController(withIdentifier: "RegistrationVC") as! RegistrationVC
        registerVC.fromScreen = "forgot"
        self.navigationController!.pushViewController(registerVC, animated: true)
    }
    
    // MARK: - API CALL
    
    private func getBalancePreference() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        var userCnic : String?
        
        let compelteUrl = Constants.BASE_URL + "api/v1/Preference/Balance"
        
        if KeychainWrapper.standard.hasValue(forKey: "userCnic"){
            userCnic = KeychainWrapper.standard.string(forKey: "userCnic")
        }
        else{
            userCnic = ""
        }
        
        //        if CLLocationManager.locationServicesEnabled() {
        //            switch CLLocationManager.authorizationStatus() {
        //            case .notDetermined, .restricted, .denied:
        //                print("No access")
        //            case .authorizedAlways, .authorizedWhenInUse:
        //                print("Access")
        //            }
        //        } else {
        //            print("Location services are not enabled")
        //
        //        }
        
        
        let params = ["lat":DataManager.instance.Latitude!,"lng":DataManager.instance.Longitude!,"imei":DataManager.instance.imei!,"cnic":userCnic!] as [String : Any]
        
        let header: HTTPHeaders = ["Accept":"application/json","Content-Type":"application/x-www-form-urlencoded"]
        
        print(params)
        print(compelteUrl)
        print(header)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post , parameters: params, encoding: URLEncoding.httpBody, headers:header).response { response in
            //        Object { (response: DataResponse<BalanceInquiry>) in
            //        Alamofire.request(compelteUrl, method: .post, parameters: params , encoding: URLEncoding.httpBody, headers:header).responseObject { (response: DataResponse<BalanceInquiry>) in
            
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                self.balanceObj = Mapper<BalanceInquiry>().map(JSONObject: json)
                if response.response?.statusCode == 200 {
                    if self.balanceObj?.response == 2 || self.balanceObj?.response == 1 {
                        // label value update (account_curr_balance)
                        self.lblCurrentBalanceAccountPreview.isHidden = false
                        if let currentBalance = self.balanceObj?.account_curr_balance {
                            self.lblCurrentBalanceAccountPreview.text = "Current Balance : \(currentBalance)"
                        }
                        self.btnTapHereReveal.isHidden = true
                    }
                    else {
                        self.showAlert(title: "", message: (self.balanceObj?.message)!, completion: nil)
                    }
                }
                else {
                    
                    if let message = self.balanceObj?.message {
                        self.showAlert(title: "", message: message, completion: {
                            self.logoutUser()
                        })
                    }
                    //                    print(response.result.value)
                    print(response.response?.statusCode)
                }
            }
        }
    }
    func getAcessAndRefreshToken() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        if locationEnabled == false {
            self.showDefaultAlert(title: "Error", message: "Please Allow Location Access to Always")
            return
        }
        
        showActivityIndicator()
        
        var pessi : String?
        var userCnic : String?
        
        let compelteUrl = Constants.BASE_URL + "api/v1/oauth/token"
        
        // var cnic = DataManager.instance.userCnic
        
        //        if DataManager.instance.userCnic == nil{
        //            DataManager.instance.userCnic = ""
        //        }
        
        // simmulator Params
        //        let params = ["grant_type":"password","client_id":clientID,"client_secret":clientSecret,"password":pinTextField.text!,"username":cnicToBeRemoved] as [String : Any]
        
        if KeychainWrapper.standard.hasValue(forKey: "userKey") && viaBio == true {
            pessi = KeychainWrapper.standard.string(forKey: "userKey")
        }
        else if let password = pinTextField.text {
            pessi = password
            DataManager.instance.userpaessi =   pessi
        }
        else{
            self.showDefaultAlert(title: "", message: "Please Use PIN for first time Login after Registration")
            self.hideActivityIndicator()
            return
            
        }
        if KeychainWrapper.standard.hasValue(forKey: "userCnic"){
            userCnic = KeychainWrapper.standard.string(forKey: "userCnic")
        }
        else{
            
            userCnic = ""
        }
        //
        //        if CLLocationManager.locationServicesEnabled() {
        //            switch CLLocationManager.authorizationStatus() {
        //            case .notDetermined, .restricted, .denied:
        //                print("No access")
        //                self.hideActivityIndicator()
        //                self.showDefaultAlert(title: "Alert", message: "Kindly enable Location Services for Login")
        //                return
        //            case .authorizedAlways, .authorizedWhenInUse:
        //                print("Access")
        //            }
        //        } else {
        //            print("Location services are not enabled")
        //        }
        
        
        // IPA Params
        let params = ["grant_type":"password","client_id":clientID,"client_secret":Constants.clientSecret,"password":pessi!,"username":userCnic!,"lat":DataManager.instance.Latitude!,"lng":DataManager.instance.Longitude!,"imei":DataManager.instance.imei!, "scope":"customer-login"] as [String : Any]
        
        //        [
        //            "lat" => "2.17403"
        //            "lng" => "41.40338"
        //            "imei" => "864324024510348"
        //            "grant_type" => "password"
        //            "client_id" => "2"
        //            "client_secret" => "BggBFqk7SLBItjo28fAWRv67tgtcafNrrYlVlHeo"
        //            "username" => "7110362691757"
        //            "password" => "70511a"
        //            "scope" => "customer-login"
        //          ]
        //
        //        BggBFqk7SLBItjo28fAWRv67tgtcafNrrYlVlHeo
        let header: HTTPHeaders = ["Accept":"application/json","Content-Type":"application/x-www-form-urlencoded"]
        print(params)
        print(compelteUrl)
        print(DataManager.instance.stringHeader!)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post , parameters: params, encoding: URLEncoding.httpBody, headers:header).response { response in
            //        Object { (response: DataResponse<AcessAndRefreshToken>) in
            //        Alamofire.request(compelteUrl, method: .post, parameters: params , encoding: URLEncoding.httpBody, headers:header).responseObject { (response: DataResponse<AcessAndRefreshToken>) in
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                self.tokenObj = Mapper<AcessAndRefreshToken>().map(JSONObject: json)
                if response.response?.statusCode == 200 {
                    print(self.tokenObj?.data?.access_token)
                    if let accessToken = self.tokenObj?.data?.access_token{
                        if let authtoken = self.tokenObj?.data?.access_token{
                            let savedtokeychain : Bool = KeychainWrapper.standard.set(authtoken, forKey: "authtoken")
                            DataManager.instance.accessToken = KeychainWrapper.standard.string(forKey: "authtoken")
                            print("token is ", DataManager.instance.accessToken)
                            print("authtoken SuccessFully Added to KeyChainWrapper \(savedtokeychain)")
                        }
                        //                    DataManager.instance.accessToken = accessToken
                        if let passKey = self.pinTextField.text{
                            let saveSuccessful : Bool = KeychainWrapper.standard.set(passKey, forKey: "userKey")
                            print("Pin SuccessFully Added to KeyChainWrapper \(saveSuccessful)")
                        }
                        self.navigateToHome()
                    }
                    else{
                        if let message = self.tokenObj?.message {
                            self.showDefaultAlert(title: "error", message: message)
                            
                            
                        }
                        self.pinTextField.text = ""
                    }
                }
                else {
                    print(response.response?.statusCode)
                    if let message = self.tokenObj?.message {
                        self.showDefaultAlert(title: "", message: message)
                        self.pinTextField.text = ""
                    }
                }
            }
        }
    }
}

extension LoginVC: PinCodeTextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: PinCodeTextField) -> Bool {
        return true
    }
    func textFieldDidBeginEditing(_ textField: PinCodeTextField) {
    }
    func textFieldValueChanged(_ textField: PinCodeTextField) {
    }
    func textFieldShouldEndEditing(_ textField: PinCodeTextField) -> Bool {
        self.getAcessAndRefreshToken()
        return true
    }
    func textFieldShouldReturn(_ textField: PinCodeTextField) -> Bool {
        return true
    }
}
