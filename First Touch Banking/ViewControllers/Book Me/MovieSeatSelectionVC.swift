//
//  MovieSeatSelectionVC.swift
//  First Touch Banking
//
//  Created by Syed Uzair Ahmed on 23/10/2018.
//  Copyright © 2018 Syed Uzair Ahmed. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
//import AlamofireObjectMapper

class MovieSeatSelectionVC: BaseVC, UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    var showID : String?
    var movieSeatBookingObj : MovieSeatsBooking?
    var filteredRowsAndColumns = [Seats]()
    @IBOutlet var moviesCollectionView : UICollectionView!
    
    @IBOutlet weak var lblMian: UILabel!
    var seatsSelected = [String]()
    
    @IBOutlet weak var btnProcced: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        lblMian.text = "Seat Selection".addLocalizableString(languageCode: languageCode)
        btnProcced.setTitle("Proceed To Payment".addLocalizableString(languageCode: languageCode), for: .normal)
        self.getMovieSeats()
        self.moviesCollectionView.allowsMultipleSelection = true
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: - CollectionView Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // Columns
        return (self.movieSeatBookingObj?.data?.seat_plan![section].seats?.count)!
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        // Rows
        if let count = self.movieSeatBookingObj?.data?.seat_plan?.count{
            return count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let aCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SeatBookingPlanCollectionViewCell", for: indexPath) as! SeatBookingPlanCollectionViewCell
        
        let aSeat = self.movieSeatBookingObj?.data?.seat_plan![indexPath.section]
        
        aCell.title.text = aSeat?.seats![indexPath.row].seat_id
        
        return aCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        NSLog ("You selected row: %@ \(indexPath)")
        
        if let aCell = collectionView.cellForItem(at: indexPath) as? SeatBookingPlanCollectionViewCell{
            //   aCell.backgroundColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
            aCell.imageView.image = #imageLiteral(resourceName: "seatSelected")
        }
        
        let aSeatPlan = self.movieSeatBookingObj?.data?.seat_plan![indexPath.section]
        
        let aSeat:Seats = (aSeatPlan?.seats![indexPath.row])!
        
        
        print("Seat ID : \(aSeat.seat_id))")
        print("Seat Row Name : \(aSeat.seat_row_name))")
        print("Seat Number : \(aSeat.seat_number))")
        print("Seat Type : \(aSeat.seat_type))")
        print("Status : \(aSeat.status))")
        
        self.seatsSelected.append(aSeat.seat_id!)
        print(self.seatsSelected)
        
        //        movieConfirmObj.seatsSelectedObj = self.seatsSelected
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        NSLog ("You selected row: %@ \(indexPath)")
        
        if let aCell = collectionView.cellForItem(at: indexPath) as? SeatBookingPlanCollectionViewCell{
            //      aCell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            aCell.imageView.image = #imageLiteral(resourceName: "seatAvailable")
        }
        
        let aSeatPlan = self.movieSeatBookingObj?.data?.seat_plan![indexPath.section]
        
        let aSeat:Seats = (aSeatPlan?.seats![indexPath.row])!
        
        
        print("DeSelect Seat ID : \(aSeat.seat_id))")
        print("DeSelect Seat Row Name : \(aSeat.seat_row_name))")
        print("DeSelect Seat Number : \(aSeat.seat_number))")
        print("DeSelect Seat Type : \(aSeat.seat_type))")
        print("DeSelect Status : \(aSeat.status))")
        
        //     self.seatsSelected.removeAll(where: { $0 == aSeat.seat_id })
        print(self.seatsSelected)
        
        //  self.seatsSelected.remove(at: indexPath)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeaderCollectionReusableView", for: indexPath) as? SectionHeaderCollectionReusableView{
            sectionHeader.lblRowHeader.text = "Row \(self.movieSeatBookingObj?.data?.seat_plan![indexPath.section].row! ?? "Row")"
            //  sectionHeader.sectionHeaderlabel.text = "Section \(indexPath.section)"
            return sectionHeader
        }
        return UICollectionReusableView()
    }
    
    // MARK: - Action Methods
    
    @IBAction func btnProceedToPayPressed(_ sender: Any) {
        
        
        if self.seatsSelected.isEmpty{
            self.showToast(title: "Please select at least 1 seat")
            return
        }
        
        let moviesTicketConfirmVC = self.storyboard!.instantiateViewController(withIdentifier: "MovieTicketConfirmationVC") as! MovieTicketConfirmationVC
        moviesTicketConfirmVC.seatsConfirmSelected = self.seatsSelected
        self.navigationController!.pushViewController(moviesTicketConfirmVC, animated: true)
        
    }
    
    // MARK: - Api Call
    
    private func getMovieSeats() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        //      let compelteUrl = Constants.BASE_URL + "api/v1/BookMe/Movies/Setplan/" +String(self.movieID!)
        let compelteUrl = "http://59.103.248.78:8070/api/v1/BookMe/Movies/Setplan/"+String(self.showID!)
        //      let header = ["Accept":"application/json","Authorization":"Bearer \(DataManager.instance.accessToken!)"]
        
        let header: HTTPHeaders = ["Accept":"application/json","Authorization":"Bearer \(DataManager.instance.tempAccessToken!)"]
        
        
        print(header)
        print(compelteUrl)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .get, encoding: URLEncoding.httpBody, headers:header).response { response in
            //            Object { (response: DataResponse<MovieSeatsBooking>) in
            
            //        Alamofire.request(compelteUrl, headers:header).responseObject { (response: DataResponse<MovieSeatsBooking>) in
            
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                if response.response?.statusCode == 200 {
                    self.movieSeatBookingObj = Mapper<MovieSeatsBooking>().map(JSONObject: json)
                    if self.movieSeatBookingObj?.response == 2 || self.movieSeatBookingObj?.response == 1 {
                        
                        self.moviesCollectionView.reloadData()
                    }
                    else {
                        // self.showAlert(title: "", message: (self.shopInfo?.resultDesc)!, completion: nil)
                    }
                }
                else {
                    //                print(response.result.value)
                    print(response.response?.statusCode)
                }
            }
        }
    }
}
