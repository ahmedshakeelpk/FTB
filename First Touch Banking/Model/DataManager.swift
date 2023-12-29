//
//  DataManager.swift
//  First Touch Banking
//
//  Created by Syed Uzair Ahmed on 23/11/2017.
//  Copyright © 2017 Syed Uzair Ahmed. All rights reserved.
//

import UIKit
import Alamofire

class DataManager: NSObject {
    var channelID : String = "1"
    var stringHeader:[String:String]?
    var userCnic:String?
    var accessToken : String?
    var regAccessToken : String?
    var accountTitle = ""
    var beneficaryTitle: String?
    var imei:String?
    var Latitude:Double?
    var Longitude:Double?
    var imagePath : URL?
    var ipAddress : String?
    var externalIpAddress : String?
    var currentBalance : String?
    var CityName:String?
    var isFromRegisteration:Bool?
    var reasonForTrans : String?
    var accountno : String?
    var AliasType : String?
    var AliasValue : String?
    var selectedSourceAccount :String?
    var sourceAccount:String?
    var beneficaryAccount:String?
    var benealias : String?
    var bebeiban :String?
    var transferAmount:String?
    var reason : String?
    var sourceiban : String?
    var sourceAccTitle: String?
    var sourceAccountTitle : String?
    var uniquekey : String?
    var mid : String?
    var uniqkey : String?
    var BeneficiaryBankname: String?
    // Book Me 
    var showID:String?
    var movieID:String?
    var bookingType:String?
    var handlingCahrges:Double?
    var imgURL:String?
    var movieName:String?
    var cinemaName:String?
    var ticketPrice:String?
    var transferaliasAmount : String?
    var userpaessi : String?
    var tempAccessToken: String?
    var IBAN = ""
    var customerType : String?
    var ChequeLocation : String?
    // For Profile Update
    
    var customer_no: String?
    var mobile_number: String?
    var email_address: String?
    var current_address_line_1: String?
    var current_address_line_2: String?
    var current_address_line_3: String?
    var correspondence_address_line_1: String?
    var correspondence_address_line_2: String?
    var correspondence_address_line_3: String?
    var marital_status: String?
    var country_of_birth: String?
    var country_of_stay: String?
    var country_of_tax_residence: String?
    var Qr_Crc = ""
    var BankFormat : String?
    //    Limitmanagment
        var frequencyATM : String?
        var keyATm  : String?
        var identifierATm  : String?
        var  transactionNameATm : String?
        var frequencyMB : String?
        var keyMB  : String?
        var identifierMB  : String?
        var transactionNameMB  :String?
    var dcLastDigits :String?
    
    // For QRCODE
    var Amount_Value : Double?
    var expirydateqrcode : String?
    
    static let instance : DataManager = DataManager()
        
    private override init() {
   
            self.stringHeader = [String:String]()
            self.stringHeader?["Accept"] = "application/json"
            self.stringHeader?["Content-Type"] = "application/x-www-form-urlencoded"
          //  self.stringHeader?["Authorization"] = "Bearer" + DataManager.instance.accessToken!
        
    }
    
    public static func sharedManager() -> DataManager {
        return instance
    }
    var clientSecretReg = "Bearer-MrhQVYIOkuistFtZwgba6bvqAtw5uQN6esgQavwflk2Hh18JufVOtKu3Rab9WbuH6s/ezC1dumUqqvkWK/y5QqlqMzCEj9cg5wBLzWx7tCbr3qR9DLyN2np6B/uyvY1XD4Dpy783/hRK0O5PB/TI1AHfkacU6N08JOKa6WlCVhOkxl4DzGgqh28Fx7L7/rfIrmnyj3PPl1eUXoy2/K61tU1fPzYZFFzLZtbHsxZAvulNHbdnO25pU46rrcICnuLfpyiQTG2mqWtJ4+Qvui7ythlymVZWjUy1UFzescpN29Y="

//    public  func refreshAccessToken()  {
//
//        let compelteUrl = Constants.BASE_URL + "api/v1/oauth/token"
//
//        let params = [ "grant_type" : "password",
//                       "client_id" : self.getClientID(),
//                       "client_secret" : self.getClientSecret(),
//                       "username" : self.getUsername(),
//                       "password":   DataManager.instance.userpaessi
//                       "scope": "customer-login",
//                       ]
//
//        // let combinedParams = ""
//
//        Alamofire.request(compelteUrl, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil)
//            .responseJSON { response in
//                print(response.request as Any)  // original URL request
//                print(response.response as Any) // URL response
//                print(response.result.value as Any)   // result of response serialization
//
//
//                //Parse Authentication token and store its value
//        }
//    }


}
