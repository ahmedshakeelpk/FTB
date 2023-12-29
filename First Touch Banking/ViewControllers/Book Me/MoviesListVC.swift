//
//  MoviesListVC.swift
//  First Touch Banking
//
//  Created by Syed Uzair Ahmed on 18/10/2018.
//  Copyright © 2018 Syed Uzair Ahmed. All rights reserved.
//

import UIKit
import Alamofire
//import AlamofireObjectMapper
import Nuke
import ObjectMapper

class MoviesListVC: BaseVC , UITableViewDelegate , UITableViewDataSource{
    
    @IBOutlet var moviesTableView: UITableView!
    var movieListObj : MovieList?
    
    @IBOutlet weak var lblmain: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblmain.text = "Movies List".addLocalizableString(languageCode: languageCode)
        // Do any additional setup after loading the view.
        
        self.getMoviesList()
    }
    
    // MARK: - Table View Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let count = self.movieListObj?.movies?.count {
            return count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let aCell = tableView.dequeueReusableCell(withIdentifier: "MoviesListTableViewCell") as! MoviesListTableViewCell
        aCell.selectionStyle = .none
        
        let aMovie = self.movieListObj?.movies![indexPath.row]
        
        aCell.lblMovieTitle.text = aMovie?.title
        aCell.lblMovieGenre.text = aMovie?.genre
        aCell.lblLength.text = "\((aMovie?.length!) ?? "min") min"
        
        let url = URL(string: (aMovie?.thumbnail)!)
        if let imgUrl = url{
            Nuke.loadImage(with: imgUrl, into: aCell.imgMovieThumbnail)
        }
        
        return aCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let aMovie:SingleMovie = (self.movieListObj?.movies![indexPath.row])!
        
        NSLog ("You selected row: %@ \(indexPath)")
        
        let moviesShowVC = self.storyboard!.instantiateViewController(withIdentifier: "MoviesShowVC") as! MoviesShowVC
        moviesShowVC.movieID = aMovie.movie_id
       
        self.navigationController!.pushViewController(moviesShowVC, animated: true)
        
        
        print("Name : \(aMovie.title))")
        print("Name : \(aMovie.genre))")
        print("Name : \(aMovie.thumbnail))")
        print("Name : \(aMovie.movie_id))")
        print("Name : \(aMovie.imdb_id))")
        print("Name : \(aMovie.language))")
        print("Name : \(aMovie.director))")
        print("Name : \(aMovie.producer))")
        print("Name : \(aMovie.release_date))")
        print("Name : \(aMovie.cast))")
        print("Name : \(aMovie.ranking))")
        print("Name : \(aMovie.length))")
        print("Name : \(aMovie.thumbnail))")

    }
    
    
    
    // MARK: - API Call
    
    private func getMoviesList() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        //      let compelteUrl = Constants.BASE_URL + "api/v1/BookMe/Movies"
        let compelteUrl = "http://59.103.248.78:8070/api/v1/BookMe/Movies"
        //      let header = ["Accept":"application/json","Authorization":"Bearer \(DataManager.instance.accessToken!)"]
        
        let header: HTTPHeaders = ["Accept":"application/json","Authorization":"Bearer \(DataManager.instance.tempAccessToken!)"]
        
        
        print(header)
        print(compelteUrl)
        //
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .get, encoding: URLEncoding.httpBody, headers:header).response { response in
            //        Object { (response: DataResponse<MovieList>) in
            //        Alamofire.request(compelteUrl, headers:header).responseObject { (response: DataResponse<MovieList>) in
            
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                if response.response?.statusCode == 200 {
                    self.movieListObj = Mapper<MovieList>().map(JSONObject: json)
                    
                    //                self.movieListObj = response.result.value
                    if self.movieListObj?.response == 2 || self.movieListObj?.response == 1 {
                        self.moviesTableView.reloadData()
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
