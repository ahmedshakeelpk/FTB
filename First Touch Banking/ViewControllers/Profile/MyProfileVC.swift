//
//  MyProfileVC.swift
//  First Touch Banking
//
//  Created by Syed Uzair Ahmed on 27/06/2018.
//  Copyright © 2018 Syed Uzair Ahmed. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Alamofire
//import AlamofireObjectMapper
import SwiftKeychainWrapper
import ObjectMapper

class MyProfileVC: BaseVC , UITableViewDelegate , UITableViewDataSource {
    var CustomerprofileOBj: Customerprofile?
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAccountNumbeer: UILabel!
    @IBOutlet weak var lblTaxType: UILabel!
    
    @IBOutlet  var emailTextField: SkyFloatingLabelTextField!
    @IBOutlet  var mobileNumberTextField: SkyFloatingLabelTextField!
    @IBOutlet  var maritalStatusTextField: SkyFloatingLabelTextField!
    
    @IBOutlet  var CurrAddressLineOne: SkyFloatingLabelTextField!
    @IBOutlet  var CurrAddressLineTwo: SkyFloatingLabelTextField!
    @IBOutlet  var CurrAddressLineThree: SkyFloatingLabelTextField!
    @IBOutlet weak var lblUpdateInformation: UILabel!
    @IBOutlet  var CorrAddressLineOne: SkyFloatingLabelTextField!
    @IBOutlet  var CorrAddressLineTwo: SkyFloatingLabelTextField!
    @IBOutlet  var CorrAddressLineThree: SkyFloatingLabelTextField!
    @IBOutlet weak var btnsave: UIButton!
    @IBOutlet weak var lblmain: UILabel!
    @IBOutlet weak var accountNumTableView: UITableView!
    var profileUpdateObj: PrifleUpdate?
    var genericResponse:GenericResponse?
    var accountNumbersList = [SingleAccountNumber]()
    var UpdatedCustomerProfile = [AccountsCustomer]()
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bottomSaveButton: UIButton!
    
    @IBOutlet var dropDownCountriesStay: UIDropDown!
    @IBOutlet var dropDownCountryBirth: UIDropDown!
    @IBOutlet var dropDownCountriesTax: UIDropDown!
    
    var selectedCountryBirth:String?
    var selectedCountryStay:String?
    var selectedCountryTaxResidence:String?
    var afterVerification:Bool = false
    var custNumber:String?
    var contactNumber:String?
    
    @IBOutlet weak var lblCorrespondingAdrss: UILabel!
    @IBOutlet weak var lblCurrentAddress: UILabel!
    
    var countriesList: [String] = ["PAKISTAN","AFGHANISTAN","ALBANIA","ALGERIA","AMERICAN SAMOA","ANDORRA","ANGOLA","ANGUILLA","ANTARCTICA","ANTIGUA","ARGENTINA","ARMENIA","ARUBA","AUSTRALIA","AUSTRIA","AZERBAIJAN","BAHAMAS","BAHRAIN","BANGLADESH","BARBADOS","BELARUS","BELGIUM","BELIZE","BENIN","BERMUDA","BHUTAN","BOLIVIA","BOSNIA AND HERZEGOVINA","BOTSWANA","BRAZIL","BRITISH VIRGIN ISLANDS","BRUNEI","BULGARIA","BURKINA FASO,BURUNDI","CAMBODIA","CAMEROON","CANADA","CAYMAN ISLANDS","CENTRAL AFRICAN REPUBLIC","CHAD","CHILE","CHINA","CHRISTMAS ISLAND","COLOMBIA","COMOROS","CONGO", "COOK ISLANDS","COSTA RICA","CROATIA","CUBA","CYPRUS","CZECH REPUBLIC","Cape Verde Islands","DENMARK","DJIBOUTI","DOMINICA","DOMINICAN REPUBLIC","ECUADOR","EGYPT","EL SALVADOR","EQUATORIAL GUINEA","ERITREA","ESTONIA","ETHIOPIA","Europe","FALKLAND ISLANDS","FAROE ISLANDS","FIJI","FINLAND","FRANCE","FRENCH GUIANA","FRENCH POLYNESIA","GABON","GAMBIA","GEORGIA","GERMANY","GHANA","GIBRALTAR","GREECE","GREENLAND","GRENADA","GUADELOUPE","GUAM","GUATEMALA","GUINEA","GUINEA-BISSAU","GUYANA","HAITI","HONDURAS","HONG KONG","HUNGARY","ICELAND","INDIA","INDONESIA","IRAN","IRAQ","IRELAND","ISRAEL","ITALY","JAMAICA","JAPAN","JORDAN","KAZAKHSTAN","KENYA","KIRIBATI","KOREA North","KOREA South","KUWAIT","KYRGYZSTAN", "LATVIA","LEBANON","LESOTHO","LIBERIA","LIBYA","LIECHTENSTEIN","LITHUANIA","LUXEMBOURG","MACAO","MACEDONIA","MADAGASCAR","MALAWI","MALAYSIA","MALDIVES","MALTA","MARSHALL ISLANDS","MARTINIQUE","MAURITANIA","MAURITIUS","MEXICO","MICRONESIA","MOLDOVA","MONACO","MONGOLIA","MONTSERRAT","MOROCCO","MOZAMBIQUE","MYANMAR","NAMIBIA","NAURU","NEPAL","NETHERLANDS","NETHERLANDS ANTILLES","NEW CALEDONIA","NEW ZEALAND","NICARAGUA","NIGER","NIGERIA","NIUE","NORFOLK ISLAND","NORWAY","OMAN","Others","PALAU","PALESTINE","PANAMA","PAPUA NEW GUINEA","PARAGUAY","PERU","PHILIPPINES","POLAND","PORTUGAL","PUERTO RICO","QATAR","ROMANIA","RUSSIA","RWANDA","SAINT HELENA","SAINT LUCIA","SAN MARINO","SAUDI ARABIA","SENEGAL","SERBIA","SIERRA LEONE","SINGAPORE","SLOVENIA","SOLOMON ISLANDS","SOMALIA","SOUTH AFRICA","SPAIN","SRI LANKA","SUDAN","SURINAME","SWAZILAND","SWEDEN","SWITZERLAND","SYRIA","TAIWAN","TAJIKISTAN","TANZANIA","THAILAND","TOGO","TOKELAU","TUNISIA","TURKEY","TURKMENISTAN","TURKS AND CAICOS ISLANDS","TUVALU","UGANDA","UKRAINE","UNITED ARAB EMIRATES","UNITED KINGDOM","UNITED STATES OF AMERICA","URUGUAY","US VIRGIN ISLANDS","UZBEKISTAN","VANUATU","VATICAN CITY","VENEZUELA","VIETNAM","Wallis and Futuna Islands","YEMEN","Yugoslavia","ZAMBIA","ZIMBABWE"]
    
    var countries: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //        for code in NSLocale.isoCountryCodes  {
        //            let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
        //            let name = NSLocale(localeIdentifier: "en_UK").displayName(forKey: NSLocale.Key.identifier, value: id) ?? "Country not found for code: \(code)"
        //            countries.append(name)
        //        }
        
        print(countries)
        getcnic()
        self.lblAccountNumbeer.text = self.userCnic!
        self.lblName.text =  DataManager.instance.accountTitle
        getCustomerProfile()
        lblmain.text = "My Profile".addLocalizableString(languageCode: languageCode)
        lblUpdateInformation.text = "Update Information".addLocalizableString(languageCode: languageCode)
        btnsave.setTitle("SAVE".addLocalizableString(languageCode: languageCode), for: .normal)
        lblCurrentAddress.text = "Current Address:".addLocalizableString(languageCode: languageCode)
        lblCorrespondingAdrss.text = "Correspondence Address".addLocalizableString(languageCode: languageCode)
        self.getProfileUpdate()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: (self.bottomSaveButton.frame.origin.y) + (self.bottomSaveButton.frame.size.height) + 20)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Utility Methods
    
    private func updateUI(){
        
        //        if let fullName  = self.profileUpdateObj?.full_name{
        //            self.lblName.text = fullName
        //        };;;;
        
        //        if let accountNumner  = self.profileUpdateObj?.accountNumbers?[0].account_number{
        //            self.lblAccountNumbeer.text = accountNumner
        //        }
        
        if let taxType  = self.profileUpdateObj?.tax_group{
            self.lblTaxType.text = taxType
        }
        if let email  = self.profileUpdateObj?.email{
            self.emailTextField.text = email
        }
        if let mobileNumber  = self.profileUpdateObj?.mobile_number{
            self.mobileNumberTextField.text = mobileNumber
        }
        if let marStatus  = self.profileUpdateObj?.marital_status{
            self.maritalStatusTextField.text = marStatus
        }
        if let currAddressOne = self.profileUpdateObj?.current_add_line1{
            self.CurrAddressLineOne.text = currAddressOne
        }
        if let currAddressTwo = self.profileUpdateObj?.current_add_line2{
            self.CurrAddressLineTwo.text = currAddressTwo
        }
        if let currAddressThree = self.profileUpdateObj?.current_add_line3{
            self.CurrAddressLineThree.text = currAddressThree
        }
        if let corresAddressOne = self.profileUpdateObj?.corres_add_line1{
            self.CorrAddressLineOne.text = corresAddressOne
        }
        if let corresAddressTwo = self.profileUpdateObj?.corres_add_line2{
            self.CorrAddressLineTwo.text = corresAddressTwo
        }
        if let corresAddressThree = self.profileUpdateObj?.corres_add_line3{
            self.CorrAddressLineThree.text = corresAddressThree
        }
        //        if let countryOfBirthText = self.profileUpdateObj?.country_of_birth{
        //            self.countryOfBirthTextField.text = Constants.codeToCountries[countryOfBirthText]
        //        }
        //        if let countryTaxResidenceText = self.profileUpdateObj?.country_of_tax_residence{
        //            self.countryOfTaxTextField.text = Constants.codeToCountries[countryTaxResidenceText]
        //        }
        self.methodDropDownStayCountries(Countries: countriesList)
        self.methodDropDownBirthCountries(Countries: countriesList)
        self.methodDropDownTaxResidenceCountries(Countries: countriesList)
        
        if let customerNumber = self.profileUpdateObj?.customer_no{
            custNumber = customerNumber
        }
        //        if afterVerification == true{
        //            self.saveProfileUpdates()
        //        }
    }
    
    
    //MARK: - DropDown
    
    private func methodDropDownStayCountries(Countries:[String]) {
        
        if let countryOfStayText = self.profileUpdateObj?.country_of_stay{
            self.dropDownCountriesStay.placeholder = Constants.codeToCountries[countryOfStayText]
            self.selectedCountryStay = countryOfStayText
        }
        else{
            self.dropDownCountriesStay.placeholder = ""
        }
        self.dropDownCountriesStay.tableHeight = 200.0
        self.dropDownCountriesStay.rowBackgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.dropDownCountriesStay.options = Countries
        self.dropDownCountriesStay.didSelect(completion: {
            (option , index) in
            print("You Just select: \(option) at index: \(index)")
            //       self.sourceAccount = option
            self.selectedCountryStay = Countries[index]
        })
    }
    
    private func methodDropDownBirthCountries(Countries:[String]) {
        
        if let countryOfBirthText = self.profileUpdateObj?.country_of_birth{
            self.dropDownCountryBirth.placeholder = Constants.codeToCountries[countryOfBirthText]
            self.selectedCountryBirth = countryOfBirthText
        }
        else{
            self.dropDownCountryBirth.placeholder = ""
        }
        self.dropDownCountryBirth.tableHeight = 150.0
        self.dropDownCountryBirth.rowBackgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.dropDownCountryBirth.options = Countries
        self.dropDownCountryBirth.didSelect(completion: {
            (option , index) in
            print("You Just select: \(option) at index: \(index)")
            //       self.sourceAccount = option
            self.selectedCountryBirth = Countries[index]
        })
    }
    
    private func methodDropDownTaxResidenceCountries(Countries:[String]) {
        
        if let countryOfTaxResidenceText = self.profileUpdateObj?.country_of_tax_residence{
            self.dropDownCountriesTax.placeholder = Constants.codeToCountries[countryOfTaxResidenceText]
            self.selectedCountryTaxResidence = countryOfTaxResidenceText
        }
        else{
            self.dropDownCountriesStay.placeholder = ""
        }
        self.dropDownCountriesTax.tableHeight = 150.0
        self.dropDownCountriesTax.rowBackgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.dropDownCountriesTax.options = Countries
        self.dropDownCountriesTax.didSelect(completion: {
            (option , index) in
            print("You Just select: \(option) at index: \(index)")
            //       self.sourceAccount = option
            self.selectedCountryTaxResidence = Countries[index]
        })
    }
    
    
    // MARK: - Table View Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //            if let count = self.agentObj?.agentLocators?.count {
        //                return count
        //            }
        
        return self.accountNumbersList.count
        //        return self.UpdatedCustomerProfile.count
        //return (self.notificationsObj?.notifications?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let aCell = tableView.dequeueReusableCell(withIdentifier: "MyProfileAccountsTableViewCell") as! MyProfileAccountsTableViewCell
        
        aCell.selectionStyle = .none
        
        //        if let accountNumber = self.CustomerprofileOBj?.data?.accounts?[0].account_number{
        aCell.lblAccountNumber.text = "Account # :\(DataManager.instance.accountno!)"
        //        }
        //        aCell.lblAccountNumber.text = "Account # :\( self.CustomerprofileOBj?.data?.accounts?[0].account_number! ?? "")"
        
        //        if let accountNumber = self.UpdatedCustomerProfile[indexPath.row].account_number {
        //            aCell.lblAccountNumber.text = "Account # :\(accountNumber)"
        //        }
        //        if let accountNumber = self.CustomerprofileOBj?.data?.accounts?[0].iban {
        //            aCell.lblIBAN.text = "IBAN  :\(accountNumber)"
        //        }
        aCell.lblIBAN.text  = "IBAN:  \(DataManager.instance.IBAN ?? "")"
        //        if let accountClass = self.CustomerprofileOBj?.data?.accounts?[0].account_class {
        //            aCell.lblAccountType.text = "Account Type : \(accountClass)"
        //        }
        //        if let accountClass =  self.profileUpdateObj?.tax_group {
        aCell.lblAccountType.text = "Account Type : \(DataManager.instance.customerType! ?? "" )"
        //                }
        
        return aCell
    }
    
    // MARK: - Action Methods
    
    
    private func saveValues(){
        
        var userCnic : String?
        if KeychainWrapper.standard.hasValue(forKey: "userCnic"){
            userCnic = KeychainWrapper.standard.string(forKey: "userCnic")
        }
        DataManager.instance.userCnic = userCnic
        DataManager.instance.customer_no = self.custNumber!
        
        if (mobileNumberTextField.text?.isEmpty)!{
            mobileNumberTextField.text = ""
        }
        if (emailTextField.text?.isEmpty)!{
            emailTextField.text = ""
        }
        if (CurrAddressLineOne.text?.isEmpty)!{
            CurrAddressLineOne.text = ""
        }
        if (CurrAddressLineTwo.text?.isEmpty)!{
            CurrAddressLineTwo.text = ""
        }
        if (CurrAddressLineThree.text?.isEmpty)!{
            CurrAddressLineThree.text = ""
        }
        if (CorrAddressLineOne.text?.isEmpty)!{
            CorrAddressLineOne.text = ""
        }
        if (CorrAddressLineTwo.text?.isEmpty)!{
            CorrAddressLineTwo.text = ""
        }
        if (CorrAddressLineThree.text?.isEmpty)!{
            CorrAddressLineThree.text = ""
        }
        if (maritalStatusTextField.text?.isEmpty)!{
            maritalStatusTextField.text = ""
        }
        
        DataManager.instance.mobile_number = self.mobileNumberTextField.text!
        DataManager.instance.email_address = self.emailTextField.text!
        DataManager.instance.current_address_line_1 = self.CurrAddressLineOne.text!
        DataManager.instance.current_address_line_2 = self.CurrAddressLineTwo.text!
        DataManager.instance.current_address_line_3 = self.CurrAddressLineThree.text!
        DataManager.instance.correspondence_address_line_1 = self.CorrAddressLineOne.text!
        DataManager.instance.correspondence_address_line_2 = self.CorrAddressLineTwo.text!
        DataManager.instance.correspondence_address_line_3 = self.CorrAddressLineThree.text!
        DataManager.instance.marital_status = self.maritalStatusTextField.text!
        if let birthCountry = self.selectedCountryBirth{
            DataManager.instance.country_of_birth = birthCountry
        }
        else {
            DataManager.instance.country_of_birth = ""
        }
        if let stayCountry = self.selectedCountryStay{
            DataManager.instance.country_of_stay = stayCountry
        }
        else {
            DataManager.instance.country_of_stay = ""
        }
        if let taxCountry = self.selectedCountryTaxResidence{
            DataManager.instance.country_of_tax_residence = taxCountry
        }
        else{
            DataManager.instance.country_of_tax_residence = ""
        }
        
        
    }
    
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        
        self.saveValues()
        self.showAlert(title: "We will send an OTP Code on your mobile number via SMS", message: self.contactNumber!, completion:{
            self.getOTPInitiate()
        })
        
        
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    var userCnic : String?
    func getcnic()
    {
        
        if KeychainWrapper.standard.hasValue(forKey: "userCnic"){
            userCnic = KeychainWrapper.standard.string(forKey: "userCnic")
        }
        else{
            userCnic = ""
        }
        
    }
    
    private func getCustomerProfile() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        if KeychainWrapper.standard.hasValue(forKey: "userCnic"){
            userCnic = KeychainWrapper.standard.string(forKey: "userCnic")
        }
        else{
            userCnic = ""
        }
        
        showActivityIndicator()
        
        let compelteUrl = Constants.BASE_URL + "api/v1/Customers/Profile"
        
        let header: HTTPHeaders = ["Accept":"application/json","Authorization":"Bearer \(DataManager.instance.accessToken!)","Content-Type":"application/x-www-form-urlencoded"]
        
        print(header)
        print(compelteUrl)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .get, encoding: URLEncoding.httpBody, headers:header).response { response in
            //        Object { (response: DataResponse<Customerprofile>) in
            
            //        Alamofire.request(compelteUrl, headers:header).responseObject { (response: DataResponse<Customerprofile>) in
            
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                if response.response?.statusCode == 200 {
                    self.CustomerprofileOBj = Mapper<Customerprofile>().map(JSONObject: json)
                    
                    if self.CustomerprofileOBj?.response == 2 || self.CustomerprofileOBj?.response == 1 {
                        
                        self.lblAccountNumbeer.text = self.userCnic!
                        self.lblName.text = self.CustomerprofileOBj?.data?.customer_name1
                        
                        //                    self.lblBalanceValue.text = self.CustomerprofileOBj?.data?
                        
                        
                    }
                    else  { if let message = self.CustomerprofileOBj?.message{
                        self.showAlert(title: "", message: message, completion: {
                            //                        self.navigationController?.popToRootViewController(animated: true)
                        })
                    }                }
                }
                else {
                    
                    if let message = self.CustomerprofileOBj?.message{
                        self.showAlert(title: "", message: message, completion: {
                            //                    self.navigationController?.popToRootViewController(animated: true)
                        })
                    }
                }
            }
        }
    }
    
    // MARK: - API CALL
    private func getProfileUpdate() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        let compelteUrl = Constants.BASE_URL + "api/v1/Customers/Profile"
        let header: HTTPHeaders = ["Accept":"application/json","Authorization":"Bearer \(DataManager.instance.accessToken!)"]
        
        print(header)
        print(compelteUrl)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .get, encoding: URLEncoding.httpBody, headers:header).response { response in
            //        Object { (response: DataResponse<PrifleUpdate>) in
            //        Alamofire.request(compelteUrl, headers:header).responseObject { (response: DataResponse<PrifleUpdate>) in
            
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                if response.response?.statusCode == 200 {
                    self.profileUpdateObj = Mapper<PrifleUpdate>().map(JSONObject: json)
                    
                    self.accountNumbersList = (self.profileUpdateObj?.accountNumbers  ?? [])
                    self.updateUI()
                    self.contactNumber = self.profileUpdateObj?.mobile_number_for_OTP
                    self.accountNumTableView.reloadData()
                }
                else {
                    //                print(response.result.value)
                    print(response.response?.statusCode)
                }
            }
        }
    }
    private func getOTPInitiate() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        
        let compelteUrl = Constants.BASE_URL + "api/v1/Customers/Profile/OTP"
        
        let header: HTTPHeaders = ["Accept":"application/json","Authorization":"Bearer \(DataManager.instance.accessToken!)","Content-Type":"application/x-www-form-urlencoded"]
        
        print(header)
        print(compelteUrl)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .get, encoding: URLEncoding.httpBody, headers:header).response { response in
            //        Object { (response: DataResponse<GenericResponse>) in
            //            Alamofire.request(compelteUrl, headers:header).responseObject { (response: DataResponse<GenericResponse>) in
            
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                self.genericResponse = Mapper<GenericResponse>().map(JSONObject: json)
                
                if response.response?.statusCode == 200 {
                    
                    if self.genericResponse?.response == 2 || self.genericResponse?.response == 1 {
                        let OTPVerifyVC = self.storyboard!.instantiateViewController(withIdentifier: "OTPVerifyVC") as! OTPVerifyVC
                        OTPVerifyVC.mainTitle = "Enter OTP for Profile Update"
                        OTPVerifyVC.FromProfileUpdate = true
                        self.navigationController!.pushViewController(OTPVerifyVC, animated: true)
                    }
                    else {
                        if let message = self.genericResponse?.message{
                            self.showAlert(title: "", message: message, completion: {
                                let OTPVerifyVC = self.storyboard!.instantiateViewController(withIdentifier: "OTPVerifyVC") as! OTPVerifyVC
                                OTPVerifyVC.mainTitle = "Enter OTP for Profile Update"
                                OTPVerifyVC.FromProfileUpdate = true
                                self.navigationController!.pushViewController(OTPVerifyVC, animated: true)})
                        }
                    }
                }
                else {
                    if let message = self.genericResponse?.message{
                        self.showDefaultAlert(title: "", message: message)
                    }
                    self.showDefaultAlert(title: "Error", message: "OTP cannot be sent. Please Try Again")
                    //                print(response.result.value)
                    print(response.response?.statusCode)
                }
            }
        }
    }
}
