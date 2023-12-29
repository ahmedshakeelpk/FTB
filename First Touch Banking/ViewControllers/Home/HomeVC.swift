//
//  HomeVC.swift
//  First Touch Banking
//
//  Created by Syed Uzair Ahmed on 23/11/2017.
//  Copyright © 2017 Syed Uzair Ahmed. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
//import AlamofireObjectMapper


var languageCode = "en"
class HomeVC: BaseVC , UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    let crc_table: [UInt16] = [
        
        0x0000, 0x1021, 0x2042, 0x3063, 0x4084, 0x50a5, 0x60c6, 0x70e7,
        0x8108, 0x9129, 0xa14a, 0xb16b, 0xc18c, 0xd1ad, 0xe1ce, 0xf1ef,
        0x1231, 0x0210, 0x3273, 0x2252, 0x52b5, 0x4294, 0x72f7, 0x62d6,
        0x9339, 0x8318, 0xb37b, 0xa35a, 0xd3bd, 0xc39c, 0xf3ff, 0xe3de,
        0x2462, 0x3443, 0x0420, 0x1401, 0x64e6, 0x74c7, 0x44a4, 0x5485,
        0xa56a, 0xb54b, 0x8528, 0x9509, 0xe5ee, 0xf5cf, 0xc5ac, 0xd58d,
        0x3653, 0x2672, 0x1611, 0x0630, 0x76d7, 0x66f6, 0x5695, 0x46b4,
        0xb75b, 0xa77a, 0x9719, 0x8738, 0xf7df, 0xe7fe, 0xd79d, 0xc7bc,
        0x48c4, 0x58e5, 0x6886, 0x78a7, 0x0840, 0x1861, 0x2802, 0x3823,
        0xc9cc, 0xd9ed, 0xe98e, 0xf9af, 0x8948, 0x9969, 0xa90a, 0xb92b,
        0x5af5, 0x4ad4, 0x7ab7, 0x6a96, 0x1a71, 0x0a50, 0x3a33, 0x2a12,
        0xdbfd, 0xcbdc, 0xfbbf, 0xeb9e, 0x9b79, 0x8b58, 0xbb3b, 0xab1a,
        0x6ca6, 0x7c87, 0x4ce4, 0x5cc5, 0x2c22, 0x3c03, 0x0c60, 0x1c41,
        0xedae, 0xfd8f, 0xcdec, 0xddcd, 0xad2a, 0xbd0b, 0x8d68, 0x9d49,
        0x7e97, 0x6eb6, 0x5ed5, 0x4ef4, 0x3e13, 0x2e32, 0x1e51, 0x0e70,
        0xff9f, 0xefbe, 0xdfdd, 0xcffc, 0xbf1b, 0xaf3a, 0x9f59, 0x8f78,
        0x9188, 0x81a9, 0xb1ca, 0xa1eb, 0xd10c, 0xc12d, 0xf14e, 0xe16f,
        0x1080, 0x00a1, 0x30c2, 0x20e3, 0x5004, 0x4025, 0x7046, 0x6067,
        0x83b9, 0x9398, 0xa3fb, 0xb3da, 0xc33d, 0xd31c, 0xe37f, 0xf35e,
        0x02b1, 0x1290, 0x22f3, 0x32d2, 0x4235, 0x5214, 0x6277, 0x7256,
        0xb5ea, 0xa5cb, 0x95a8, 0x8589, 0xf56e, 0xe54f, 0xd52c, 0xc50d,
        0x34e2, 0x24c3, 0x14a0, 0x0481, 0x7466, 0x6447, 0x5424, 0x4405,
        0xa7db, 0xb7fa, 0x8799, 0x97b8, 0xe75f, 0xf77e, 0xc71d, 0xd73c,
        0x26d3, 0x36f2, 0x0691, 0x16b0, 0x6657, 0x7676, 0x4615, 0x5634,
        0xd94c, 0xc96d, 0xf90e, 0xe92f, 0x99c8, 0x89e9, 0xb98a, 0xa9ab,
        0x5844, 0x4865, 0x7806, 0x6827, 0x18c0, 0x08e1, 0x3882, 0x28a3,
        0xcb7d, 0xdb5c, 0xeb3f, 0xfb1e, 0x8bf9, 0x9bd8, 0xabbb, 0xbb9a,
        0x4a75, 0x5a54, 0x6a37, 0x7a16, 0x0af1, 0x1ad0, 0x2ab3, 0x3a92,
        0xfd2e, 0xed0f, 0xdd6c, 0xcd4d, 0xbdaa, 0xad8b, 0x9de8, 0x8dc9,
        0x7c26, 0x6c07, 0x5c64, 0x4c45, 0x3ca2, 0x2c83, 0x1ce0, 0x0cc1,
        0xef1f, 0xff3e, 0xcf5d, 0xdf7c, 0xaf9b, 0xbfba, 0x8fd9, 0x9ff8,
        0x6e17, 0x7e36, 0x4e55, 0x5e74, 0x2e93, 0x3eb2, 0x0ed1, 0x1ef0
    ]
    var balanceObj:BalanceInquiry?
    var qrcodeImage: CIImage!
    
    var CRCvalue = ""
    var concatestring: String?
    var getiban : String?
    @IBOutlet weak var imgLocalFunds: UIImageView!
    @IBOutlet weak var imgMiniState: UIImageView!
    @IBOutlet weak var imgInterBank: UIImageView!
    @IBOutlet weak var imgTopUp: UIImageView!
    @IBOutlet weak var imgUtilityBill: UIImageView!
    @IBOutlet weak var imgContactUs: UIImageView!
    @IBOutlet weak var imgProfilePhoto: UIImageView!
    var CustomerprofileOBj: Customerprofile?
    @IBOutlet weak var lblLastTransactionValue: UILabel!
    @IBOutlet weak var lblBalanceValue: UILabel!
    @IBOutlet weak var lblAccountNumValue: UILabel!
    @IBOutlet weak var lblAccountBalanceValue: UILabel!
    @IBOutlet weak var lblAccountTitle: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblDegree: UILabel!
    @IBOutlet weak var lblDegreeDesc: UILabel!
    @IBOutlet weak var viewForImgMini: UIView!
    @IBOutlet weak var viewForLFT: UIView!
    @IBOutlet weak var viewForImgIBFT: UIView!
    @IBOutlet weak var viewForImgTopUp: UIView!
    @IBOutlet weak var viewForImgUBP: UIView!
    @IBOutlet weak var viewForImgQuickPay: UIView!
    @IBOutlet weak var mainContentView: UIView!
    @IBOutlet weak var lblquickpay: UILabel!
    @IBOutlet weak var lblutility: UILabel!
    @IBOutlet weak var lbltopup: UILabel!
    @IBOutlet weak var lblInterbank: UILabel!
    @IBOutlet weak var lbllocalfunds: UILabel!
    @IBOutlet weak var lblministat: UILabel!
    @IBOutlet weak var Activity_Indicator: UIActivityIndicatorView!
    @IBOutlet weak var lbllasttra: UILabel!
    @IBOutlet weak var lblbal: UILabel!
    @IBOutlet weak var lblhome: UILabel!
    @IBOutlet weak var lbl_LastIBAN: UILabel!
    @IBOutlet weak var ImgView_QR: UIImageView!
    @IBOutlet weak var lblDonation: UILabel!
    @IBOutlet weak var btn_ScanQR: UIButton!
    @IBOutlet weak var btn_Generate: UIButton!
    
    
    
    
    
    
    //  var balanceObj:BalanceInquiry?
    //  var TitleObj:TitleFetch?
    var TitleBalanceStatementObj:TitleBalanceStatementModel?
    var weatherObj:Weather?
    
    
    var picker = UIImagePickerController()
    var selectedImage : UIImage!
    
    static let networkManager = NetworkManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Activity_Indicator.startAnimating()
        getCustomerProfile()
        convertLanguage()
        ImgView_QR.isHidden = true
        isFromQR = "false"
        
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(viewDidLoadCustom), name: Notification.Name("LanguageChangeThroughObserver"), object: nil)
        print("selected language is: ", LanguageCheck)
        self.updateButtonsRadius()
        if DataManager.instance.Latitude == nil {
            self.showToast(title: "Please enable Location from settings")
            self.logoutUser()
            return
        }
        
        
        
        //           self.mainContentView.addSubview(self.refreshControl)
        
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        ImgView_QR.isUserInteractionEnabled = true
        ImgView_QR.addGestureRecognizer(tapGestureRecognizer)
        // Do any additional setup after loading the view.
    }
    var String_Combined = ""
    var qrEmvData = ""
    var result = ""
    func ConcateStaticQR()
    {
        //        concatestring = "\(PayloadformatindicatorId)\(PayLoadIDLength)\(Payloadformatindicatorvalue)\(Pointofinitiationmethodid)\(InitiationMethodLength)\(Pointofinitiationmethodstaticvalue)\(Schemeidentifierid)\(SchemeIdentifierLength)\(Schemeidentifiervalue)\(IBANid)\(Iban_Length)\(DataManager.instance.IBAN!)\(CRCid)\(CRD_Length)\(CRCvalue)"
        
        //        QR enable
        //        if DataManager.instance.IBAN != nil && DataManager.instance.accountTitle != nil
        //        {
        //            ImgView_QR.isHidden = false
        //        }
        
        String_Combined = "\("00")\("02")\("02")\("01")\("02")\("11")\("02")\("02")\("00")\("04")\("24")\(DataManager.instance.IBAN ?? "")\("10")\("04")"
        print("concate string is",  String_Combined)
        print("my string count is",  String_Combined)
        let tData = Data(String_Combined.utf8.map{$0})
        let crcString = String.init(format: "%04X", tData.crc16Check())
        CRCvalue = crcString
        print(crcString)
        String_Combined = "\("00")\("02")\("02")\("01")\("02")\("11")\("02")\("02")\("00")\("04")\("24")\(DataManager.instance.IBAN ?? "")\("10")\("04")\(CRCvalue)"
        qrEmvData = String_Combined
        //qr enable
        //        let a = DataManager.instance.IBAN ?? ""
        //        lbl_LastIBAN.text =  String(a.suffix(4))
        //        let myQRimage: UIImage? = UIImage(ciImage: createQRFromString(str: "\(String_Combined)")!)
        //        ImgView_QR.image = myQRimage
    }
    var crcValue : String?
    var dateValue : String?
    var staticQRValue : String?
    var ibanValue : String?
    var ConcateString : String?
    var FetchDatafromString = ""
    func decodeEMVQR(qr: String) {
        guard let dic = decodeEMV(qrData: qr) else {
            print("Error")
            return
        }
        var payloadIndicator = ""
        var pointOfInitiation = ""
        var schemeIdentifire = ""
        var iBAN = ""
        var Crc = ""
        
        for (key, value) in dic {
            print("\(key) -> \(value)")
            
            if key == "01"
            {
                pointOfInitiation = "\(key)\("02")\(value)"
                staticQRValue = value
                print("dynamicQRValue", staticQRValue!)
            }
            else if key == "10"
            {
                Crc = " \(key)\("04")\(value)"
                crcValue = value
                print("crcValue", crcValue!)
            }
            else if key  == "00"
            {
                payloadIndicator = " \(key)\("02")\(value)"
            }
            else if key  == "02"
            {
                schemeIdentifire = "\(key)\("02")\(value)"
            }
            else if key  == "04"
            {
                print("iban")
                ibanValue  = value
                iBAN = "\(key)\("24")\(value)"
            }
            FetchDatafromString = "\(payloadIndicator)\(pointOfInitiation)\(schemeIdentifire)\(iBAN)\(Crc)"
            FetchDatafromString =   FetchDatafromString.replacingOccurrences(of: " ", with: "")
            print("output is",   FetchDatafromString)
            
            
            
        }
        func parseData(data: String) -> (String, String, String)? {
            let keyIndex = data.index(data.startIndex, offsetBy: 1)
            let key = String(data[...keyIndex])
            
            let tempStartIndex = data.index(data.startIndex, offsetBy: 2)
            let temp = String(data[tempStartIndex...])
            
            let lengthIndex = temp.index(temp.startIndex, offsetBy: 1)
            if let length = Int(String(temp[...lengthIndex])) {
                let valueStartIndex = temp.index(temp.startIndex, offsetBy: 2)
                let valueEndIndex = temp.index(temp.startIndex, offsetBy: 1 + length)
                let value = String(temp[valueStartIndex...valueEndIndex])
                
                let newDataIndex = temp.index(temp.startIndex, offsetBy: 2 + length)
                let newData = String(temp[newDataIndex...])
                
                return (key, value, newData)
            }
            
            return nil
        }
        
        //    var arr = dic.map { "\($0.key) \($0.value)" }
        var arr = [String]()
        func decodeEMV(qrData: String) -> [String:String]? {
            var data = qrData
            var dic : [String: String] = [String:String]()
            //        var dic = [String:String]()
            
            while data.isEmpty == false {
                if let dataParsed = parseData(data: data) {
                    data = dataParsed.2
                    if dataParsed.0.isEmpty == false, dataParsed.1.isEmpty == false{
                        dic[dataParsed.0]  =   dataParsed.1
                        print("get text is",  dic[dataParsed.0])
                    }
                    
                } else {
                    data = ""
                }
                
            }
            print("errorr")
            return dic
            print("text")
        }
    }
    
    
    
    private func createQRFromString(str: String) -> CIImage? {
        
        let stringData = str.data(using: .utf8)
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setValue(stringData, forKey: "inputMessage")
        filter?.setValue("H", forKey: "inputCorrectionLevel")
        
        return filter?.outputImage
    }
    
    @objc func viewDidLoadCustom() {
        convertLanguage()
        self.dismissKeyboard()
        self.hideKeyboardWhenTappedAround()
        
    }
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        //        apicall
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        if #available(iOS 13.0, *) {
            let quickPayVC = self.storyboard!.instantiateViewController(withIdentifier: "StaticQRVC") as! StaticQRVC
            getCustomerProfile()
            self.navigationController!.pushViewController(quickPayVC, animated: true)
            // Your action
        }
    }
    func  convertLanguage()
    {
        
        languageCode = UserDefaults.standard.string(forKey: "language-Code") ?? ""
        lblhome.text = "Home".addLocalizableString(languageCode: languageCode)
        lbllasttra.text = "Last Transaction".addLocalizableString(languageCode: languageCode)
        lblbal.text = "Balance".addLocalizableString(languageCode: languageCode)
        lblministat.text = "Mini Statment".addLocalizableString(languageCode: languageCode)
        lbllocalfunds.text = "Local Funds Transfer".addLocalizableString(languageCode: languageCode)
        lbltopup.text = "Top Up".addLocalizableString(languageCode: languageCode)
        lblutility.text = "Utility Bill Payments".addLocalizableString(languageCode: languageCode)
        lblquickpay.text = "RAAST".addLocalizableString(languageCode: languageCode)
        lblInterbank.text = "Inter Bank Funds Transfer".addLocalizableString(languageCode: languageCode)
        lblDonation.text = "Donations".addLocalizableString(languageCode: languageCode)
        lblRaast.text = "Quick Pay".addLocalizableString(languageCode: languageCode)
        lblDebitCard.text = "Debit card".addLocalizableString(languageCode: languageCode)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //    // MARK: -  Pull to Refresh
    //
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh),for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.gray
        return refreshControl
    }()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.getBalanceInquiry()
        refreshControl.endRefreshing()
    }
    override func viewWillAppear(_ animated: Bool)  {
        var refreshControl: UIRefreshControl = {
            languageCode = UserDefaults.standard.string(forKey: "language-Code") ?? ""
            let refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: #selector(handleRefresh),for: UIControlEvents.valueChanged)
            refreshControl.tintColor = UIColor.gray
            return refreshControl
        }()
    }
    // MARK: -  Utility Methods
    
    private func updateButtonsRadius(){
        
        self.viewForImgMini.layer.cornerRadius = self.viewForImgMini.bounds.height / 2
        self.viewForLFT.layer.cornerRadius = self.viewForLFT.bounds.height / 2
        self.viewForImgIBFT.layer.cornerRadius = self.viewForImgIBFT.bounds.height / 2
        self.viewForImgTopUp.layer.cornerRadius = self.viewForImgTopUp.bounds.height / 2
        self.viewForImgUBP.layer.cornerRadius = self.viewForImgUBP.bounds.height / 2
        self.viewForImgQuickPay.layer.cornerRadius = self.viewForImgQuickPay.bounds.height / 2
        self.imgProfilePhoto.layer.cornerRadius = self.imgProfilePhoto.bounds.height / 2
        self.updateProfilePhoto()
    }
    
    private func updateUI(){
        
        //        self.getMiniStatement(completionHandler: {(result:MiniStatement) in
        //
        //            let aStatement = result.ministatement![0]
        //            if let lastTrans = aStatement.lcy_amount{
        //                self.lblLastTransactionValue.text = "PKR \(lastTrans)"
        //            }
        //        })
        
        
        if let lastTrans = self.TitleBalanceStatementObj?.lcy_amount{
            self.lblLastTransactionValue.text = "PKR \(lastTrans)"
        }
        // uzair     self.getWeather()
        
        if let accountTitle = self.TitleBalanceStatementObj?.account_title{
            self.lblAccountTitle.text = accountTitle
            DataManager.instance.accountTitle = accountTitle
        }
        
        if let accountNumValue = self.TitleBalanceStatementObj?.account_number  {
            //            self.lblAccountNumValue.text = "               Account # : \(accountNumValue)"
            DataManager.instance.accountno = accountNumValue
            
        }
        if let balanceValue = self.TitleBalanceStatementObj?.account_curr_balance {
            self.lblBalanceValue.text = "PKR \(convertToCurrrencyFormat(amount:balanceValue))"
            //  self.lblBalanceValue.text = "PKR \(balanceValue)"
            DataManager.instance.currentBalance = balanceValue
        }
        self.lblLocation.text = DataManager.instance.CityName
    }
    
    private func updateProfilePhoto(){
        
        if let imageCheck = UserDefaults.standard.object(forKey: "proImage"){
            imgProfilePhoto.layer.cornerRadius = imgProfilePhoto.frame.height / 2
            imgProfilePhoto.layer.masksToBounds = false
            imgProfilePhoto.clipsToBounds = true
            let retrievedImage = imageCheck
            self.imgProfilePhoto.image = UIImage(data: retrievedImage as! Data)
        }
    }
    
    // MARK: - Image Picker Methods
    
    // when popUpThePickerButton is clicked
    
    
    @IBAction func btnDebitCard(_ sender: UIButton) {
        showDefaultAlert(title: "", message: "Coming Soon")
    }
    
    
    @IBAction func Action_GenerateQR(_ sender: UIButton) {
        //        let changePassVC = self.storyboard?.instantiateViewController(withIdentifier: "StaticQRVC") as! StaticQRVC
        //        self.navigationController?.pushViewController(changePassVC, animated: true)
    }
    
    @IBAction func Action_DownloadQR(_ sender: UIButton) {
        let afterconvert =  ImgView_QR.screenshotImage()
        
        let image = afterconvert
        
        let imageToShare = [ image ]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        
        // present the view controller
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func Action_ScanQR(_ sender: UIButton) {
        let changePassVC = self.storyboard?.instantiateViewController(withIdentifier: "ScanReader_VC") as! ScanReader_VC
        self.navigationController?.pushViewController(changePassVC, animated: true)
    }
    @IBOutlet weak var lblDebitCard: UILabel!
    @IBAction func btnRAASt(_ sender: UIButton) {
        //        showDefaultAlert(title: "", message: "Coming Soon")
        let quickPayVC = self.storyboard!.instantiateViewController(withIdentifier: "RaastMainVC") as! RaastMainVC
        isFromRaast = "false"
        isFromQuickPay = "true"
        IsFromIBFT = "false"
        self.navigationController!.pushViewController(quickPayVC, animated: true)
    }
    @IBOutlet weak var lblRaast: UILabel!
    
    
    
    @IBAction func btnDonation(_ sender: UIButton) {
        let quickPayVC = self.storyboard!.instantiateViewController(withIdentifier: "DonationsMainVC") as! DonationsMainVC
        
        self.navigationController!.pushViewController(quickPayVC, animated: true)
        
    }
    @IBAction func selectPictureFromPhotos(sender: UIButton) {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { _ in
            self.openGallery()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        //If you want work actionsheet on ipad then you have to use popoverPresentationController to present the actionsheet, otherwise app will crash in iPad
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            alert.popoverPresentationController?.sourceView = sender
            alert.popoverPresentationController?.sourceRect = sender.bounds
            alert.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func openGallery(){
        
        picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    func openCamera(){
        
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
            picker.sourceType = UIImagePickerControllerSourceType.camera
            //If you dont want to edit the photo then you can set allowsEditing to false
            picker.allowsEditing = true
            picker.delegate = self
            self.present(picker, animated: true, completion: nil)
        }
        else{
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let img = info[UIImagePickerControllerEditedImage] as? UIImage{
            self.selectedImage = img
        }
        else if let img = info[UIImagePickerControllerOriginalImage] as? UIImage{
            self.selectedImage = img
        }
        
        let image = self.selectedImage
        let pngImage =  UIImagePNGRepresentation(image!)
        UserDefaults.standard.set(pngImage, forKey: "proImage")
        
        self.updateProfilePhoto()
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - API CALL
    
    private func getWeather(){
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        //        let compelteUrl = "http://api.weatherunlocked.com/api/current/33.69,72.97?app_id=88f5ab3a&app_key=2d41dabe0ba2909ab9c9271d31d7e588"
        
        let compelteUrl = "http://api.weatherunlocked.com/api/current/\(DataManager.instance.Latitude!),\(DataManager.instance.Longitude!)?app_id=88f5ab3a&app_key=2d41dabe0ba2909ab9c9271d31d7e588"
        
        print(compelteUrl)
        
        AF.request(compelteUrl).response { response in
            //            Object { (response: DataResponse<Weather>) in
            
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                if response.response?.statusCode == 200 {
                    self.weatherObj = Mapper<Weather>().map(JSONObject: json)
                    if let weather = self.weatherObj{
                        if let degree = weather.temp_c{
                            self.lblDegree.text = "\(degree) °C"
                        }
                        if let degreeDesc = weather.wx_desc{
                            self.lblDegreeDesc.text = degreeDesc
                        }
                    }
                }
            }
        }
    }
    private func getLocationName(){
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        
        let compelteUrl = "http://api.weatherunlocked.com/api/current/\(DataManager.instance.Latitude!),\(DataManager.instance.Longitude!)?app_id=88f5ab3a&app_key=2d41dabe0ba2909ab9c9271d31d7e588"
        
        print(compelteUrl)
        
        AF.request(compelteUrl).response { response in
            //            Object { (response: DataResponse<Weather>) in
            
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                if response.response?.statusCode == 200 {
                    self.weatherObj = Mapper<Weather>().map(JSONObject: json)
                    if let weather = self.weatherObj{
                        if let degree = weather.temp_c{
                            self.lblDegree.text = "\(degree) °C"
                        }
                        if let degreeDesc = weather.wx_desc{
                            self.lblDegreeDesc.text = degreeDesc
                        }
                    }
                }
            }
        }
    }
    /* if token is expired. Check on message and call refresh token
     {
     "response": 401,
     "message": "Unauthenticated - Token Expired."
     }
     
     */
    
    private func getTitleBalanceStatement() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        showActivityIndicator()
        
        
        //        let account = self.balanceObj?.account_number!
        //        let accountIMD = "220557"
        
        let compelteUrl = Constants.BASE_URL + "api/v1/Transactions/TitleBalanceStatement"
        
        let params = ["lat":DataManager.instance.Latitude!,"lng":DataManager.instance.Longitude!,"imei":DataManager.instance.imei!] as [String : Any]
        
        let header: HTTPHeaders = ["Accept":"application/json","Authorization":"Bearer \(DataManager.instance.accessToken!)","Content-Type":"application/x-www-form-urlencoded"]
        //       let header = ["Accept":"application/json","Authorization":"Bearer \(Constants.ACCESS_TOKEN)","Content-Type":"application/x-www-form-urlencoded"]
        
        
        print(params)
        print(compelteUrl)
        //        print(header)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: URLEncoding.httpBody, headers:header).response { response in
            //            Object { (response: DataResponse<TitleBalanceStatementModel>) in
            //        Alamofire.request(compelteUrl, method: .post, parameters: params , encoding: URLEncoding.httpBody, headers:header).responseObject { (response: DataResponse<TitleBalanceStatementModel>) in
            
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                if response.response?.statusCode == 200 {
                    self.TitleBalanceStatementObj = Mapper<TitleBalanceStatementModel>().map(JSONObject: json)
                    
                    if self.TitleBalanceStatementObj?.response == 2 || self.TitleBalanceStatementObj?.response == 1 {
                        self.updateUI()
                        self.ConcateStaticQR()
                    }
                    else {
                        // self.showAlert(title: "", message: (self.shopInfo?.resultDesc)!, completion: nil)
                    }
                }
                else {
                    //                        print(response.result.value)
                    print(response.response?.statusCode)
                }
            }
        }
    }
    
    private func getBalanceInquiry() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        let compelteUrl = Constants.BASE_URL + "api/v1/Transactions/AccountBalanceInquiry"
        
        let params = ["lat":DataManager.instance.Latitude!,"lng":DataManager.instance.Longitude!,"imei":DataManager.instance.imei!] as [String : Any]
        let header: HTTPHeaders = ["Accept":"application/json","Authorization":"Bearer \(DataManager.instance.accessToken!)"]
        
        print(params)
        print(compelteUrl)
        print(header)
        
        //NetworkManager.sharedInstance.enableCertificatePinning()
        
        AF.request(compelteUrl, method: .post, parameters: params , encoding: URLEncoding.httpBody, headers:header).response { response in
            //        Object { [self] (response: DataResponse<BalanceInquiry>) in
            
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                self.balanceObj = Mapper<BalanceInquiry>().map(JSONObject: json)
                if response.response?.statusCode == 200 {
                    
                    if self.balanceObj?.response == 0
                    {
                        if let message = self.balanceObj?.message {
                            self.showAlert(title: "", message: message, completion: nil)
                        }
                    }
                    
                    if self.balanceObj?.response == 2 || self.balanceObj?.response == 1 {
                        self.Activity_Indicator.stopAnimating()
                        self.Activity_Indicator.isHidden = true
                        self.getTitleBalanceStatement()
                        
                    }
                    else {
                        if let message = self.balanceObj?.message {
                            self.showDefaultAlert(title: "", message:message)
                        }
                    }
                }
                else {
                    if let message = self.balanceObj?.message{
                        if message == "Unauthenticated - Token Expired."{
                            self.showAlert(title: "", message: message, completion: {
                                self.logoutUser()
                            })
                            
                        }
                        else{
                            self.showAlert(title: "", message: message, completion: {
                                //                    self.navigationController?.popToRootViewController(animated: true)
                            })
                        }
                        
                        //                if let message = self.genericObj?.message{
                        //                    self.showDefaultAlert(title: "", message: message)
                        //                }
                        //                            print(response.result.value)
                        print(response.response?.statusCode)
                    }
                }
            }
        }
    }
    
    private func getCustomerProfile() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        let compelteUrl = Constants.BASE_URL + "api/v1/Customers/Profile"
        
        let header: HTTPHeaders = ["Accept":"application/json","Authorization":"Bearer \(DataManager.instance.accessToken!)","Content-Type":"application/x-www-form-urlencoded"]
        
        print(header)
        print(compelteUrl)
        
        //        NetworkManager.sharedInstance.enableCertificatePinning()
        //        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .get, encoding: URLEncoding.httpBody, headers:header).responseObject { (response: DataResponse<Customerprofile>) in
        
        AF.request(compelteUrl, headers:header).response { response in
            //            Object { [self] (response: DataResponse<Customerprofile>) in
            
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                self.CustomerprofileOBj = Mapper<Customerprofile>().map(JSONObject: json)
                if response.response?.statusCode == 200 {
                    
                    if self.CustomerprofileOBj?.response == 2 || self.CustomerprofileOBj?.response == 1 {
                        self.lblAccountNumValue.text = (self.CustomerprofileOBj?.data?.accounts?[0].iban! ?? "")
                        self.lblAccountTitle.text = self.CustomerprofileOBj?.data?.customer_name1
                        //                    self.lblBalanceValue.text =
                        //                    self.CustomerprofileOBj?.data?.customerba
                        //                    DataManager.instance.IBAN = "PK96FMFB0021122403871012"
                        DataManager.instance.IBAN = (self.CustomerprofileOBj?.data?.accounts?[0].iban! ?? "")
                        DataManager.instance.IBAN =   DataManager.instance.IBAN.replacingOccurrences(of: " ", with: "")
                        DataManager.instance.customerType   = (self.CustomerprofileOBj?.data?.accounts?[0].account_class! ?? "")
                        
                        
                        self.getBalanceInquiry()
                        
                        
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
    
    // MARK: - Action Methods
    
    @IBAction func bookmePressed(_ sender: Any) {
        let bookMeVC = self.storyboard!.instantiateViewController(withIdentifier: "BookMeVC") as! BookMeVC
        self.navigationController!.pushViewController(bookMeVC, animated: true)
    }
    @IBAction func miniStatementPressed(_ sender: Any) {
        let miniStatementVC = self.storyboard!.instantiateViewController(withIdentifier: "MiniStatementVC") as! MiniStatementVC
        miniStatementVC.balanceAmount = self.TitleBalanceStatementObj?.account_curr_balance
        self.navigationController!.pushViewController(miniStatementVC, animated: true)
    }
    @IBAction func localFundTransPressed(_ sender: Any) {
        let localFundVC = self.storyboard!.instantiateViewController(withIdentifier: "LocalFundsTransferVC") as! LocalFundsTransferVC
        localFundVC.isFromHome = true
        self.navigationController!.pushViewController(localFundVC, animated: true)
    }
    @IBAction func interBankFundTransPressed(_ sender: Any) {
        let quickPayVC = self.storyboard!.instantiateViewController(withIdentifier: "RaastMainVC") as! RaastMainVC
        isFromRaast = "false"
        isFromQuickPay = "false"
        IsFromIBFT = "true"
        self.navigationController!.pushViewController(quickPayVC, animated: true)
        
        //
    }
    @IBAction func topUpPressed(_ sender: Any) {
        let topUpVC = self.storyboard!.instantiateViewController(withIdentifier: "TopUpMainVC") as! TopUpMainVC
        self.navigationController!.pushViewController(topUpVC, animated: true)
    }
    @IBAction func utilityBillPressed(_ sender: Any) {
        let utilityVC = self.storyboard!.instantiateViewController(withIdentifier: "UtilityBillMainVC") as! UtilityBillMainVC
        self.navigationController!.pushViewController(utilityVC, animated: true)
    }
    @IBAction func quickPayPressed(_ sender: Any) {
        
        let quickPayVC = self.storyboard!.instantiateViewController(withIdentifier: "RaastSubViewVc") as! RaastSubViewVc
        isFromRaast = "true"
        isFromQuickPay = "false"
        self.navigationController!.pushViewController(quickPayVC, animated: true)
        
    }
}
