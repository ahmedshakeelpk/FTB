//
//  SocialServicesVC.swift
//  First Touch Banking
//
//  Created by Syed Uzair Ahmed on 15/03/2018.
//  Copyright © 2018 Syed Uzair Ahmed. All rights reserved.
//

import UIKit
import SafariServices

class SocialServicesVC: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        lblMain.text = "Social Services".addLocalizableString(languageCode: languageCode)
        btnyou.setTitle("Youtube".addLocalizableString(languageCode: languageCode), for: .normal)
        btnFacebook.setTitle("Facebook".addLocalizableString(languageCode: languageCode), for: .normal)
        btninsta.setTitle("Instagram".addLocalizableString(languageCode: languageCode), for: .normal)
            btntwitter.setTitle("Twitter".addLocalizableString(languageCode: languageCode), for: .normal)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    
    @IBOutlet weak var btnFacebook: UIButton!
    
    @IBOutlet weak var lblMain: UILabel!
    @IBOutlet weak var btnyou: UIButton!
    @IBOutlet weak var btninsta: UIButton!
    @IBOutlet weak var btntwitter: UIButton!
    // MARK: - Action Methods

    
    @IBAction func facebookPressed(_ sender: Any) {
        let url = URL(string: "https://www.facebook.com/hblmicrofinancebank")
        let vc = SFSafariViewController(url: url!)
        present(vc, animated: true, completion: nil)
    }
    @IBAction func twitterPressed(_ sender: Any) {
        let url = URL(string: "https://twitter.com/HBLMFB")
        let vc = SFSafariViewController(url: url!)
        present(vc, animated: true, completion: nil)
    }
    @IBAction func instagramPressed(_ sender: Any) {
        let url = URL(string: "https://www.instagram.com/hblmicrofinancebank/")
        let vc = SFSafariViewController(url: url!)
        present(vc, animated: true, completion: nil)
    }
    @IBAction func youtubePressed(_ sender: Any) {
        let url = URL(string: "https://www.youtube.com/channel/UCJkC27U6lfKL-qodojHbXZQ")
        let vc = SFSafariViewController(url: url!)
        present(vc, animated: true, completion: nil)
    }

}
