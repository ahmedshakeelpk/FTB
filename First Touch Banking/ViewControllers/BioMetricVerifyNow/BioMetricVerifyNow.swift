//
//  BioMetricVerifyNow.swift
//  First Touch Banking
//
//  Created by Shakeel Ahmed on 04/01/2024.
//  Copyright © 2024 irum Zubair. All rights reserved.
//

import UIKit
import FingerprintSDK
import Alamofire

class BioMetricVerifyNow: BaseVC, FingerprintResponseDelegate {
    
    
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var buttonVerifyNow: UIButton!
    var fingerprintPngs : [Png]?
    var verifyOTPInfo:VerifyOTP?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonVerifyNow.layer.cornerRadius = 8
        // Do any additional setup after loading the view.
    }
    
    @IBAction func buttonBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonVerifyNow(_ sender: Any) {
        fingerPrintVerification()
//        self.openEnterPasswordVC()
    }
    
    func fingerPrintVerification() {
        //#if targetEnvironment(simulator)
        //        #else
        
        let customUI = CustomUI(
            topBarBackgroundImage: nil,
            topBarColor: UIColor.red,
            topBarTextColor: UIColor.white,
            containerBackgroundColor: UIColor.white,
            scannerOverlayColor: UIColor.green,
            scannerOverlayTextColor: UIColor.white,
            instructionTextColor: UIColor.white,
            buttonsBackgroundColor: UIColor.red,
            buttonsTextColor: UIColor.white,
            imagesColor: UIColor.green,
            isFullWidthButtons: true,
            guidanceScreenButtonText: "NEXT",
            guidanceScreenText: "User Demo",
            guidanceScreenAnimationFilePath: nil,
            showGuidanceScreen: true)
        
        let customDialog = CustomDialog(
            dialogImageBackgroundColor: UIColor.white,
            dialogImageForegroundColor: UIColor.green,
            dialogBackgroundColor: UIColor.white,
            dialogTitleColor: UIColor.green,
            dialogMessageColor: UIColor.black,
            dialogButtonTextColor: UIColor.white,
            dialogButtonBackgroundColor: UIColor.orange)
        
        let uiConfig = UIConfig(
            splashScreenLoaderIndicatorColor: UIColor.black,
            splashScreenText: "Please wait",
            splashScreenTextColor: UIColor.white,
            customUI: customUI,
            customDialog: customDialog,
            customFontFamily: nil)
        
        let fingerprintConfig = FingerprintConfig(mode: .EXPORT_WSQ,
                                                  hand: .BOTH_HANDS,
                                                  fingers: .TWO_THUMBS,
                                                  isPackPng: true, uiConfig: uiConfig)
        //        let fingerprintConfig = FingerprintConfig(
        //            mode: .EXPORT_WSQ,
        //            hand: .BOTH_HANDS,
        //            fingers: .TWO_THUMBS,
        //            liveness: true,
        //            isPackPng: false)
        
        let vc = FaceoffViewController.init(nibName: "FaceoffViewController", bundle: Bundle(for: FaceoffViewController.self))
        
        vc.fingerprintConfig = fingerprintConfig
        vc.fingerprintResponseDelegate = self
        DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
            self.present(vc, animated: true, completion: nil)
        }
        
        //        #endif
    }
    func openEnterPasswordVC() {
        let nextVC = self.storyboard!.instantiateViewController(withIdentifier: "EnterPasswordVC") as! EnterPasswordVC
        if let key = self.verifyOTPInfo?.data?.unique_key {
            nextVC.uniqueKey = key
        }
        self.navigationController!.pushViewController(nextVC, animated: true)
    }
    
    func onScanComplete(fingerprintResponse: FingerprintSDK.FingerprintResponse) {
        //Shakeel ! added
        if fingerprintResponse.response == Response.SUCCESS_WSQ_EXPORT {
            //            print(fingerprintResponse.response)
            //            print(fingerprintResponse.response)


            fingerprintPngs = fingerprintResponse.pngList
            var fingerprintsList = [Fingerprints]()

            var tempFingerPrintDictionary = [[String:Any]]()
            if let fpPNGs = fingerprintPngs {
                for item in fpPNGs {
                    guard let imageString = item.binaryBase64ObjectPNG else { return }
                    guard let instance = Fingerprints(fingerIndex: "\(item.fingerPositionCode)", fingerTemplate: imageString) else { return }

                    tempFingerPrintDictionary.append(
                        ["FINGER_INDEX":"\(item.fingerPositionCode)",
                         "FINGER_TEMPLATE":imageString,
//                         "TEMPLATE_TYPE":"WSQ"
                        ]
                    )
                }
            }
            self.bioVerisys(fingerprints: tempFingerPrintDictionary)
        }
        else {
            //            self.showDefaultAlert(title: "Faceoff Results", message: fingerprintResponse.response.message)
            //            self.showAlertCustomPopup(title: "Faceoff Results", message: fingerprintResponse.response.message, iconName: .iconError) {_ in
            //                self.dismiss(animated: true)
            //            }

            let actionSheetController = UIAlertController (title: "Faceoff Results", message: fingerprintResponse.response.message, preferredStyle: UIAlertControllerStyle.actionSheet)

            //Add OK-Action
            actionSheetController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (actionSheetController) -> Void in


            }))

            //present actionSheetController
            self.present(actionSheetController, animated: true, completion: nil)
        }
    }
    override func motionCancelled(_ motion: UIEventSubtype, with event: UIEvent?) {
        self.dismiss(animated: true)
    }
}

extension BioMetricVerifyNow {
    private func bioVerisys(fingerprints: [[String:Any]]) {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        showActivityIndicator()
        let compelteUrl = Constants.BASE_URL + "api/v1/Customers/BioVerisys"
        let jsonDataaa = try! JSONSerialization.data(withJSONObject: fingerprints as Any, options: .prettyPrinted)
        let decoded = try! JSONSerialization.jsonObject(with: jsonDataaa, options: [])
        print(decoded)
        if let dicFromJson = decoded as? [[String:Any]] {
            print(dicFromJson)
            print(dicFromJson)
        }
        let decoded2 = try! JSONSerialization.jsonObject(with: jsonDataaa, options: .fragmentsAllowed)
        print(decoded2)
        if let dicFromJson = decoded2 as? [[String:Any]] {
            print(dicFromJson)
            print(dicFromJson)
        }
        //        if let jsonsss = try? JSONSerialization.jsonObject(with: jsonDataaa2, options: []) {
        //            print(jsonsss)
        //            print(jsonsss)
        //        }
        let params = [
            "TEMPLATE_TYPE": "WSQ",
            //            "TEMPLATE_TYPE": "ISO_19794_2",
            "LOCATION_LAT": "33.6844",
            "LOCATION_LONG": "73.0479",
            "imei":"\(DataManager.instance.imei ?? "")",
            "nadra":decoded
        ] as [String : Any]
        let jsonDataaaParams = try! JSONSerialization.data(withJSONObject: params as Any, options: .prettyPrinted)
        print(jsonDataaaParams)
        let decoded3 = try! JSONSerialization.jsonObject(with: jsonDataaaParams, options: [])
        print(decoded3)
        if let dicFromJson = decoded3 as? [[String:Any]] {
            print(dicFromJson)
            print(dicFromJson)
        }
        
        
        //        let params = [
        //            "TEMPLATE_TYPE": "ISO_19794_2",
        //            "LOCATION_LAT": "\(DataManager.instance.Latitude!)",
        //            "LOCATION_LONG": "DataManager.instance.Longitude!",
        //            "imei":"\(DataManager.instance.imei ?? "")",
        //            "nadra":decoded
        //        ]
        
        let header: HTTPHeaders = [
            "Accept":"application/json",
            "Content-Type":"application/json",
            "Authorization":"Bearer \(DataManager.instance.regAccessToken!)"]
        print("Parameters Before Sending: \(params)")
        print("Url Before Sending: \(compelteUrl)")
        print("Token Before Sending: \(DataManager.instance.stringHeader!)")
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        let url = URL(string: compelteUrl)!
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Authorization", forHTTPHeaderField: "Bearer \(DataManager.instance.regAccessToken!)")
        
        let jsonDataaa2 = try! JSONSerialization.data(withJSONObject: params as Any, options: .prettyPrinted)
        request.httpBody = jsonDataaa2
        if let jsonsss = try? JSONSerialization.jsonObject(with: jsonDataaa2, options: []) {
            print(jsonsss)
            print(jsonsss)
        }
        
        NetworkManager.sharedInstance.sessionManager?.request(request.url!, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).response { response in
            
            //        NetworkManager.sharedInstance.serverRequest().request(compelteUrl, method: .post, parameters: params , encoding: URLEncoding.httpBody, headers:header).response { response in
            //        Object { (response: DataResponse<Registeration>) in
            
            //     Alamofire.request(compelteUrl, method: .post, parameters: params , encoding: URLEncoding.httpBody, headers:header).responseObject { (response: DataResponse<Registeration>) in
            
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                //                self.registerInfo = Mapper<Registeration>().map(JSONObject: json)
                print(json)
                if response.response?.statusCode == 200 {
                    let model: ModelBioMetricVerificationSuccessfull? = self.decodeDataToObject(data: response.data)
                    self.showAlert(title: "Success", message: model?.message ?? "", completion: {
                        self.openEnterPasswordVC()
                    })
                    
                }
                else {
                    let model: ModelErrorBioVerisys? = self.decodeDataToObject(data: response.data)
                    self.showAlert(title: "Error", message: model?.data.responseStatus.message ?? "", completion: nil)
                }
                //                    print(response.result.value)
                print(response.response?.statusCode)
            }
        }
    }
    func decodeDataToObject<T: Codable>(data : Data?)->T?{
        if let dt = data{
            do{
                return try JSONDecoder().decode(T.self, from: dt)
                
            }  catch let DecodingError.dataCorrupted(context) {
                print(context)
            } catch let DecodingError.keyNotFound(key, context) {
                print("Key '\(key)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch let DecodingError.valueNotFound(value, context) {
                print("Value '\(value)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch let DecodingError.typeMismatch(type, context)  {
                print("Type '\(type)' mismatch:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch {
                print("error: ", error)
            }
        }
        return nil
    }
}

extension BioMetricVerifyNow {
    // MARK: - ModelErrorBioVerisys
    struct ModelErrorBioVerisys: Codable {
        let response: Int
        let message: String
        let data: DataClass
    }
    
    // MARK: - DataClass
    struct DataClass: Codable {
        let responseStatus: ResponseStatus
        let transactionID, sessionID, citizenNumber: String
        let fingerIndex: FingerIndex
        
        enum CodingKeys: String, CodingKey {
            case responseStatus = "RESPONSE_STATUS"
            case transactionID = "TRANSACTION_ID"
            case sessionID = "SESSION_ID"
            case citizenNumber = "CITIZEN_NUMBER"
            case fingerIndex = "FINGER_INDEX"
        }
    }
    
    // MARK: - FingerIndex
    struct FingerIndex: Codable {
        let finger: [Int]
        
        enum CodingKeys: String, CodingKey {
            case finger = "FINGER"
        }
    }
    
    // MARK: - ResponseStatus
    struct ResponseStatus: Codable {
        let code: Int
        let message: String
        
        enum CodingKeys: String, CodingKey {
            case code = "CODE"
            case message = "MESSAGE"
        }
    }
    
    struct Fingerprints: Codable {
        var fingerIndex: String
        var fingerTemplate: String
        var templateType: String
        
        init?(fingerIndex: String, fingerTemplate: String) {
            self.fingerIndex = fingerIndex
            self.fingerTemplate = fingerTemplate
            self.templateType = ""
        }
    }
    
    // MARK: - ModelBioMetricVerificationSuccessfull
    struct ModelBioMetricVerificationSuccessfull: Codable {
        let data: DataClass
        let message: String
        let response: Int
    }

    // MARK: - DataClass
    struct ModelBioMetricVerificationSuccessfullData: Codable {
        let birthPlace, birthPlaceEn, cardType: String
        let clientID, cnic: Int
        let countryOfResidence, createdAt, dateOfBirth, entity: String
        let expiryDate, familyNumber, fatherHusbandName, fatherHusbandNameEn: String
        let id: Int
        let issueDate, lat, long, name: String
        let nameEn, nationality: String
        let parentID: Int
        let permanantAddress, permanantAddressEn, photograph, presentAddress: String
        let presentAddressEn: String
        let sessionID: Double
        let statusCode: Int
        let statusMessage: String
        let transactionID: Double
        let updatedAt: String

        enum CodingKeys: String, CodingKey {
            case birthPlace = "birth_place"
            case birthPlaceEn = "birth_place_en"
            case cardType = "card_type"
            case clientID = "client_id"
            case cnic
            case countryOfResidence = "country_of_residence"
            case createdAt = "created_at"
            case dateOfBirth = "date_of_birth"
            case entity
            case expiryDate = "expiry_date"
            case familyNumber = "family_number"
            case fatherHusbandName = "father_husband_name"
            case fatherHusbandNameEn = "father_husband_name_en"
            case id
            case issueDate = "issue_date"
            case lat, long, name
            case nameEn = "name_en"
            case nationality
            case parentID = "parent_id"
            case permanantAddress = "permanant_address"
            case permanantAddressEn = "permanant_address_en"
            case photograph
            case presentAddress = "present_address"
            case presentAddressEn = "present_address_en"
            case sessionID = "session_id"
            case statusCode = "status_code"
            case statusMessage = "status_message"
            case transactionID = "transaction_id"
            case updatedAt = "updated_at"
        }
    }

}



