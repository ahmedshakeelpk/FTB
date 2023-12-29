//
//  MovieTicketConfirmationVC.swift
//  First Touch Banking
//
//  Created by Syed Uzair Ahmed on 25/10/2018.
//  Copyright © 2018 Syed Uzair Ahmed. All rights reserved.
//

import UIKit
import Nuke
import Alamofire
import ObjectMapper
//import AlamofireObjectMapper


class MovieTicketConfirmationVC: BaseVC {
    
    var seatsConfirmSelected = [String]()
    
    @IBOutlet weak var lblmain: UILabel!
    @IBOutlet weak var lblMovieName: UILabel!
    @IBOutlet weak var lblCinemaName: UILabel!
    @IBOutlet weak var lblTicketsQuantity: UILabel!
    @IBOutlet weak var lblSeatsSelected: UILabel!
    @IBOutlet weak var lblHandlingCharges: UILabel!
    @IBOutlet weak var lblTotalPrice: UILabel!
    @IBOutlet weak var imgMovieThumbnail: UIImageView!
    
    var ticketPriceDouble:Double?
    var ticketPriceTotalDouble:Double?
    var handlingChargesDouble:Double?
    
    @IBOutlet weak var btncancel: UIButton!
    var moviePaymentSuccessObj : MoviePaymentSuccess?
    
    @IBOutlet weak var btnpay: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblmain.text = "Confirmation".addLocalizableString(languageCode: languageCode)
        btncancel.setTitle("CANCEL".addLocalizableString(languageCode: languageCode), for: .normal)
        btnpay.setTitle("Pay".addLocalizableString(languageCode: languageCode), for: .normal)
        print("\(self.seatsConfirmSelected)")
        print("\(self.seatsConfirmSelected.count)")
        
        self.updateUI()
        
        // Do any additional setup after loading the view.
    }
    
    
    // MARK: - Utility Methods
    
    private func updateUI(){
        
        self.lblMovieName.text = DataManager.instance.movieName
        self.lblCinemaName.text = DataManager.instance.cinemaName
        self.lblTicketsQuantity.text = String(seatsConfirmSelected.count)
        
        self.lblSeatsSelected.text = self.seatsConfirmSelected.joined(separator: ",")
        
        self.lblHandlingCharges.text = "\(DataManager.instance.handlingCahrges ?? 0)"
        
        
        if let ticketPrice = (DataManager.instance.ticketPrice){
            self.ticketPriceDouble = Double(ticketPrice)
        }
        let seatsCount = Double(self.seatsConfirmSelected.count)
        
        self.ticketPriceTotalDouble = self.ticketPriceDouble! * seatsCount
        
        if let handlingCharges = (DataManager.instance.handlingCahrges){
            self.handlingChargesDouble = handlingCharges
        }
        
        self.lblTotalPrice.text = String(self.ticketPriceTotalDouble! + self.handlingChargesDouble!)
        
        if let url = URL(string: (DataManager.instance.imgURL)!) {
            Nuke.loadImage(with: url, into: self.imgMovieThumbnail)
        }
        
    }
    
    @IBAction func btnProceedToPayPressed(_ sender: Any) {
        self.payMovieBill()
        
    }
    
    // MARK: - API CALL
    
    private func payMovieBill() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        let compelteUrl = Constants.BASE_URL + "api/v1/BookMe/Movies"
        
        let params = ["lat":DataManager.instance.Latitude!,"lng":DataManager.instance.Longitude!,"imei":DataManager.instance.imei!,"show_id":DataManager.instance.showID!,"booking_type":DataManager.instance.bookingType!,"seats":self.seatsConfirmSelected.count,"seat_numbers":self.lblSeatsSelected.text!,"name":DataManager.instance.accountTitle,"email":"abc@gmail.com","phone":"03346481616","city":"Isb","address":"Blue Area","payment_type":"ep","movie_id":DataManager.instance.movieID!] as [String : Any]
        let header: HTTPHeaders = ["Accept":"application/json","Authorization":"Bearer \(DataManager.instance.tempAccessToken!)"]
        
        
        print(params)
        print(compelteUrl)
        print(header)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .get, encoding: URLEncoding.httpBody, headers:header).response {
            response in
            
            //        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .get, encoding: URLEncoding.httpBody, headers:header).responseObject { (response: DataResponse<MoviePaymentSuccess>) in
            
            //        Alamofire.request(compelteUrl, method: .post, parameters: params , encoding: URLEncoding.httpBody, headers:header).responseObject { (response: DataResponse<MoviePaymentSuccess>) in
            
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                if response.response?.statusCode == 200 {
                    self.moviePaymentSuccessObj = Mapper<MoviePaymentSuccess>().map(JSONObject: json)
                    
                    if self.moviePaymentSuccessObj?.response == 2 || self.moviePaymentSuccessObj?.response == 1 {
                        
                        //                    if let message = self.moviePaymentSuccessObj?.message{
                        //                        self.showDefaultAlert(title: "Sucess", message: message)
                        //                    }
                        self.showAlert(title: "Success", message: "Thank you for Booking", completion:{
                            self.navigationController?.popToRootViewController(animated: true)
                        })
                        //                    if let message = self.moviePaymentSuccessObj?.message{
                        //                        self.showAlert(title: "Success", message: "Thank you for Booking", completion:{
                        //                            self.navigationController?.popToRootViewController(animated: true)
                        //                        })
                        //                    }
                        
                    }
                    else {
                        //                    if let message = self.genericObj?.message{
                        //                        self.showAlert(title: "", message: message, completion:nil)
                        //                    }
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
