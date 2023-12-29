//
//  BookMeVC.swift
//  First Touch Banking
//
//  Created by Syed Uzair Ahmed on 20/11/2018.
//  Copyright © 2018 Syed Uzair Ahmed. All rights reserved.
//

import UIKit

class BookMeVC: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        lblmain.text = "Book Me".addLocalizableString(languageCode: languageCode)
        btnmovie.setTitle("Movies".addLocalizableString(languageCode: languageCode), for: .normal)
        btnTransport.setTitle("Transport".addLocalizableString(languageCode: languageCode), for: .normal)
           DataManager.instance.tempAccessToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjVkNjA0OTcwMGU0YzBkMWYyYmQ4NTdiY2NhODIzNTNkZmM2ZWYxZTdkMTU0NDNkNTk4ZGNjMjczNmJkZmJmOGQ5NWQyMGVmODdmNzQ3YzY4In0.eyJhdWQiOiIyIiwianRpIjoiNWQ2MDQ5NzAwZTRjMGQxZjJiZDg1N2JjY2E4MjM1M2RmYzZlZjFlN2QxNTQ0M2Q1OThkY2MyNzM2YmRmYmY4ZDk1ZDIwZWY4N2Y3NDdjNjgiLCJpYXQiOjE1NDc3MDMzMjUsIm5iZiI6MTU0NzcwMzMyNSwiZXhwIjoxNTQ3NzYzMzI1LCJzdWIiOiI4Iiwic2NvcGVzIjpbXX0.jaPHG_yAuDkfuvdtXurfMmkyD-e5RIRGH53OH-G_jjVIKhHXkb3wnu04sIXLXLG-k4A-q6rS0nrpd-0nkfU7LR2-noolksxd6m4bem_sJ3p1LxYkPS4KsiMwKOggMqZe8sjYH7ZZMDJQA5cHmW4uFVP8T9dFyftqvJpGDR6gLN5OsrxZYjjvqFUIWJwzdIcLvZNF8s7eCC_RTMKv4JFDGn4qEDeXauZ68E_VDpKtyAQHkP-7rZz-pnZ46XGwkfA-sKBgz1Y9dMZJtrMjSKvwoA4IiCHfO1MTtcaHrc6SqU4sIvCCQihIqYF-A4go3MhxdJ7oNVP5WLR2smtxwGQ4_zg26K9m804r2ArEhwfw50HV-ofDxnY91so4cjrbX0OHySnYYqSd0fTcDOWujaGSnV9J3gqVJnqIPkqlEtX_2Lm2FUlC92qrSnvX71n8Pb5E_pt5ucmUR1cNXM1045gJokPdM6NQRvRUvjwRHFB40z9D9qsxIwAgivZB6NF6LjL5q1LFh5mVEhseZfH8pUS7kmjKs8u71jFj8NiU8uhc8ua0RHlApfTEHGahuoUy5amCfNRdnXSZPDDQ73ykXG6vjCAkp7AWNJd2jl0q2uxfkFnopQ89sY2EWSsId2ByjwSROWbjQ1gV9R7YOL40kpB2DwVRDuUZdZ-QxM2KC5Xy1a4"

        // Do any additional setup after loading the view.
    }
    

    @IBOutlet weak var btnTransport: UIButton!
    @IBOutlet weak var btnmovie: UIButton!
    @IBOutlet weak var lblmain: UILabel!
    @IBAction func moviesBookPressed(_ sender: Any) {
        let bookMeVC = self.storyboard!.instantiateViewController(withIdentifier: "MoviesListVC") as! MoviesListVC
        self.navigationController!.pushViewController(bookMeVC, animated: true)
    }
    @IBAction func transportBookPressed(_ sender: Any) {
        let transportVC = self.storyboard!.instantiateViewController(withIdentifier: "TransportListVC") as! TransportListVC
        self.navigationController!.pushViewController(transportVC, animated: true)
    }

}
