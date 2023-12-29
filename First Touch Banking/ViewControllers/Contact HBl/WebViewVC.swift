//
//  WebViewVC.swift
//  First Touch Banking
//
//  Created by Syed Uzair Ahmed on 28/12/2017.
//  Copyright © 2017 Syed Uzair Ahmed. All rights reserved.
//

import UIKit

class WebViewVC: BaseVC, UIWebViewDelegate {
   
    @IBOutlet var webViewOutlet: UIWebView!
    public var fileURL:String?
    var forHTML : Bool = false
    var forTerms : Bool = false
    var forTouchIDTerms : Bool = false
    var forFaqs : Bool = false
    var forAwaaz : Bool = false
    @IBOutlet weak var lblMainTitle: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        lblMainTitle.text = "Access  Banking".addLocalizableString(languageCode: languageCode)
        webViewOutlet.delegate = self
        
        self.showActivityIndicator()
        
        if forHTML == false {
            self.webViewMethod()
        }
        else{
            self.webViewHtmlMethod()
        }
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - WebViewDelegate
    
    func webViewMethod(){
        if forAwaaz {
            self.hideActivityIndicator()
        }
           webViewOutlet.loadRequest(URLRequest(url: URL(string: fileURL!)!))
    }
    
    func webViewHtmlMethod(){
        if forFaqs{
            if LanguageCheck == "en" || LanguageCheck == ""
            {
                self.lblMainTitle.text = "FAQs"
                let localfilePath = Bundle.main.url(forResource: "Access Banking FAQs updateddocx", withExtension: "pdf")
                let myRequest = URLRequest(url:localfilePath!)
                webViewOutlet.loadRequest(myRequest);
            }
            else{
                
                self.lblMainTitle.text = "FAQs"
                let localfilePath = Bundle.main.url(forResource: "Access Banking FAQs Urdu", withExtension: "html")
                let myRequest = URLRequest(url:localfilePath!)
                webViewOutlet.loadRequest(myRequest);
            }
             
        }
        else if forTerms {
            self.lblMainTitle.text = "Terms And Conditions"
            let localfilePath = Bundle.main.url(forResource: "Access Banking Terms and Conditions", withExtension: "pdf")
            let myRequest = URLRequest(url:localfilePath!)
            webViewOutlet.loadRequest(myRequest);
        }
        else if forTouchIDTerms {
            self.lblMainTitle.text = "Terms And  Conditions"
            let localfilePath = Bundle.main.url(forResource: "Terms", withExtension: "pdf")
            let myRequest = URLRequest(url:localfilePath!)
            webViewOutlet.loadRequest(myRequest);
        }
    }
    
//    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
//        if self.coverage {
//            if request.url?.absoluteString.range(of: "coveragechecker") == nil &&
//                request.url?.absoluteString.range(of: "recaptcha") == nil {
//                UIApplication.shared.openURL(request.url!)
//                return false
//            }
//        }
//        return true
//    }
    
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.hideActivityIndicator()
    }

}
