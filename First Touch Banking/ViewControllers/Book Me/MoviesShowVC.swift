//
//  MoviesShowVC.swift
//  First Touch Banking
//
//  Created by Syed Uzair Ahmed on 23/10/2018.
//  Copyright © 2018 Syed Uzair Ahmed. All rights reserved.
//

import UIKit
import Alamofire
//import AlamofireObjectMapper
import Nuke
import ObjectMapper

class MoviesShowVC: BaseVC , UITableViewDelegate , UITableViewDataSource {
    
    var movieID : String?
    var movieShowInfoObj : MovieShowInfo?
    @IBOutlet weak var imgMovieThumbnail: UIImageView!
    @IBOutlet weak var lblRanking: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var lblDirector: UILabel!
    @IBOutlet weak var lblStars: UILabel!
    @IBOutlet weak var lblSynopsis: UILabel!
    @IBOutlet var moviesShowInfoTableView: UITableView!
    
    
    @IBOutlet weak var lblmain: UILabel!
    
    
    @IBOutlet weak var btnBookme: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblmain.text = "Movie Info".addLocalizableString(languageCode: languageCode)
        //        btnBookme.setTitle("Book Me".addLocalizableString(languageCode: languageCode), for: .normal)
        self.getMovieInfo()
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Utility Methods
    
    private func updateUI(){
        
        let aMovieInfo = self.movieShowInfoObj?.movieShows![0]
        
        if let url = URL(string: (aMovieInfo?.thumbnail)!){
            Nuke.loadImage(with: url, into: self.imgMovieThumbnail)
        }
        //let url = URL(string: (aMovieInfo?.thumbnail)!)
        
        if let ranking = aMovieInfo?.ranking{
            self.lblRanking.text = ranking
        }
        if let duration = aMovieInfo?.length{
            self.lblDuration.text = duration
        }
        if let director = aMovieInfo?.director{
            self.lblDirector.text = director
        }
        if let cast = aMovieInfo?.cast{
            self.lblStars.text = cast
        }
        if let synopsis = aMovieInfo?.synopsis{
            self.lblSynopsis.text = synopsis
        }
        self.moviesShowInfoTableView.reloadData()
    }
    
    // MARK: - Table View Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let count = self.movieShowInfoObj?.movieShows![0].shows?.count{
            return count
        }
        return 0
        
        //return (self.notificationsObj?.notifications?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let aCell = tableView.dequeueReusableCell(withIdentifier: "MoviesBookingTableViewCell") as! MoviesBookingTableViewCell
        aCell.selectionStyle = .none
        
        let aMovieShow = self.movieShowInfoObj?.movieShows![0].shows![indexPath.row]
        
        aCell.lblCinemaName.text = aMovieShow?.cinema_name
        aCell.lblCityName.text = aMovieShow?.city_name
        aCell.lblShowDate.text = aMovieShow?.show_start_time
        aCell.lblTicketPrice.text = "Rs. \(aMovieShow?.ticket_price ?? "Rs.")"
        //  aCell.btn_Delete.tag = indexPath.row
        
        return aCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let aValue:SingleShowInfo = (self.movieShowInfoObj?.movieShows![0].shows![indexPath.row])!
        
        let moviesBookingVC = self.storyboard!.instantiateViewController(withIdentifier: "MovieSeatSelectionVC") as! MovieSeatSelectionVC
        moviesBookingVC.showID = aValue.show_id
        
        self.navigationController!.pushViewController(moviesBookingVC, animated: true)
        
        NSLog ("You selected row: %@ \(indexPath)")
        
        
        DataManager.instance.showID = aValue.show_id
        DataManager.instance.movieID = aValue.show_movie_id
        DataManager.instance.handlingCahrges = aValue.handling_charges
        if let bookingType = self.movieShowInfoObj?.movieShows![0].booking_type{
            DataManager.instance.bookingType = bookingType
        }
        if let imgThumbnail = self.movieShowInfoObj?.movieShows![0].thumbnail{
            DataManager.instance.imgURL = imgThumbnail
        }
        if let movieTitle = self.movieShowInfoObj?.movieShows![0].title{
            DataManager.instance.movieName = movieTitle
        }
        DataManager.instance.cinemaName = aValue.cinema_name
        DataManager.instance.ticketPrice = aValue.ticket_price
        
        
        
        print("Cinema Name : \(aValue.cinema_name))")
        print("City Name : \(aValue.city_name))")
        print("Show Date  : \(aValue.show_date))")
        print("Show ID : \(DataManager.instance.showID))")
        print("Movie ID : \(DataManager.instance.movieID))")
        print("Handling Charges  : \(DataManager.instance.handlingCahrges))")
        print("Booking Type  : \(DataManager.instance.bookingType))")
        print("Image Url  : \(DataManager.instance.imgURL))")
        
    }
    
    
    
    // MARK: - Api Call
    
    private func getMovieInfo() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        //      let compelteUrl = Constants.BASE_URL + "api/v1/BookMe/Movies/830" +String(self.movieID!)
        let compelteUrl = "http://59.103.248.78:8070/api/v1/BookMe/Movies/"+String(self.movieID!)
        //      let header = ["Accept":"application/json","Authorization":"Bearer \(DataManager.instance.accessToken!)"]
        
        let header: HTTPHeaders = ["Accept":"application/json","Authorization":"Bearer \(DataManager.instance.tempAccessToken!)"]
        print(header)
        print(compelteUrl)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .get, encoding: URLEncoding.httpBody, headers:header).response { response in
            //            Object { (response: DataResponse<MovieShowInfo>) in
            
            //        Alamofire.request(compelteUrl, headers:header).responseObject { (response: DataResponse<MovieShowInfo>) in
            
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                if response.response?.statusCode == 200 {
                    self.movieShowInfoObj = Mapper<MovieShowInfo>().map(JSONObject: json)
                    if self.movieShowInfoObj?.response == 2 || self.movieShowInfoObj?.response == 1 {
                        self.updateUI()
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
