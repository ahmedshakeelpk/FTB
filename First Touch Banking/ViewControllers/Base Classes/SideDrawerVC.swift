//
//  SideDrawerVC.swift
//  First Touch Banking
//
//  Created by Syed Uzair Ahmed on 23/11/2017.
//  Copyright © 2017 Syed Uzair Ahmed. All rights reserved.
//

import UIKit
import KYDrawerController
import SwiftKeychainWrapper
var LanguageCheck = ""
class SideDrawerVC: BaseVC ,UITableViewDelegate,UITableViewDataSource {
    var flag = ""
    var urduarr  : [String] = ["گھر","میری پروفائل","میرا قرض","اے ٹی ایم لوکیٹر","برانچ لوکیٹر","ایجنٹ لوکیٹر","سماجی خدمات","عطیات","اطلاعات","اکاؤنٹ کا پیش نظارہ","ٹچ/فیس آئی ڈی کو فعال کریں","پاس ورڈ تبدیل کریں","ہم سے رابطہ ","اکثر پوچھے گئے سوالات","شرائط و ضوابط","چیک بک","لاگ آوٹ"]
    var sideItemsArr : [String] = ["Home","My Profile","My Loans","ATM Locator", "Branch Locator","Agent Locator", "Social Services", /*"Theme Sclection", "Orders",*/ "Donations","Notifications", "Account Preview","Enable Touch/Face ID","Change Password","Contact Us", "FAQs" ,"Terms & Conditions","Services","Notifications Settings", "Logout"]
    
    
    
//    var sideItemsArr : [String] = ["Home","My Profile","My Loans","ATM Locator", "Branch Locator","Agent Locator", "Social Services", /*"Theme Sclection", "Orders",*/ "Donations","Notifications", "Account Preview","Enable Touch/Face ID","Change Password","Contact Us", "FAQs" ,"Terms & Conditions", "Logout"]
//
    var sideBarImgsArr: [String] = ["ic_home","ic_profile","ic_loan","ic_atm_locator","ic_branch_locator","ic_agent","ic_social",/*"ic_themes","ic_orders",*/"ic_acc_preview","ic_notifications_active","ic_acc_preview","ic_acc_preview","ic_change_password","ic_contacts-1","ic_orders","ic_notifications_active","ic_orders","ic_notifications_active","logout"]
    
//    var sideBarImgsArr: [String] = ["ic_home","ic_profile","ic_loan","ic_atm_locator","ic_branch_locator","ic_agent","ic_social",/*"ic_themes","ic_orders",*/"donations","ic_notifications_active","ic_acc_preview","ic_acc_preview","ic_change_password","ic_contacts-1","ic_orders","ic_notifications_active","logout"]
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var segmentbar: UISegmentedControl!
    //MARK: - ViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func SegmentControl(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0
        {
            LanguageCheck = "en"
            flag = "true"
            sender.tintColor = UIColor.blueColor
            UserDefaults.standard.setValue("en", forKey: "language-Code")
            self.tableView.reloadData()

        }
        else if sender.selectedSegmentIndex == 1
        {
            LanguageCheck = "ur-Arab-PK"
            flag = "false"
            sender.tintColor = UIColor.blueColor
            UserDefaults.standard.setValue("ur-Arab-PK", forKey: "language-Code")
            self.tableView.reloadData()

           
        }
//        UserDefaults.standard.setValue(nil, forKey: "language-Code")
     NotificationCenter.default.post(name: Notification.Name("LanguageChangeThroughObserver"), object: nil)
        
    }
    
    
    
    

    //MARK: - Table View Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        if flag == "true"
//        {
//            return sideItemsArr.count
//        }
//        if flag == "false"{
//            return urduarr.count
//        }
        
        return sideItemsArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideBarCell", for: indexPath) as! SideBarCell
        let languageCode = UserDefaults.standard.string(forKey: "language-Code") ?? "en"
        cell.sideBarLbl.text = String(sideItemsArr[indexPath.row]).addLocalizableString(languageCode: languageCode);
        cell.sideBarImgView.image = UIImage(named: sideBarImgsArr[indexPath.row])
//        if flag == "false"
////
//        {
          
              
       
//        }
//        else{
//            cell.sideBarLbl.text = sideItemsArr[indexPath.row];
//            cell.sideBarImgView.image = UIImage(named: sideBarImgsArr[indexPath.row])

//        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let drawer = self.parent as! KYDrawerController
        let navCtrl = drawer.mainViewController as! UINavigationController
        
        switch indexPath.row {
        case 0:
            let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
            languageCode = UserDefaults.standard.string(forKey: "language-Code") ?? ""
            NotificationCenter.default.post(name: Notification.Name("LanguageChangeThroughObserver"), object: nil)
            //          self.navigationController?.pushViewController(homeVC.viewControllers.first!, animated: true)
            navCtrl.pushViewController(homeVC, animated: true)
            break
            //        case 1:
            //            tabBarCtr.selectedIndex = 3
            //            navCtr!.popToRootViewController(animated: true)
            //            break
            //
        //
        case 1:
            let profileVC = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileVC") as! MyProfileVC
            navCtrl.pushViewController(profileVC, animated: true)
            break
        case 2:
//            showDefaultAlert(title: "", message: "Coming Soon")
            let loanVC = self.storyboard?.instantiateViewController(withIdentifier: "MyLoanVC") as! MyLoanVC
            navCtrl.pushViewController(loanVC, animated: true)
            break
        case 3:
            let atmVC = self.storyboard?.instantiateViewController(withIdentifier: "AtmLocatorVC") as! AtmLocatorVC
            navCtrl.pushViewController(atmVC, animated: true)
            break
        case 4:
            let branchVC = self.storyboard?.instantiateViewController(withIdentifier: "BranchLocatorVC") as! BranchLocatorVC
            navCtrl.pushViewController(branchVC, animated: true)
            break
        case 5:
            let agentVC = self.storyboard?.instantiateViewController(withIdentifier: "AgentLocatorVC") as! AgentLocatorVC
            navCtrl.pushViewController(agentVC, animated: true)
            break
        case 6:
            let socailVC = self.storyboard?.instantiateViewController(withIdentifier: "SocialServicesVC") as! SocialServicesVC
            navCtrl.pushViewController(socailVC, animated: true)
            break
//        case 7:
////            showDefaultAlert(title: "", message: "Coming Soon")
//                   let donationsVC = self.storyboard?.instantiateViewController(withIdentifier: "StaticQRVC") as! StaticQRVC
//                   navCtrl.pushViewController(donationsVC, animated: true)
//                   break
        case 7:
            let notificationsVC = self.storyboard?.instantiateViewController(withIdentifier: "DonationsMainVC") as! DonationsMainVC
            navCtrl.pushViewController(notificationsVC, animated: true)
            break
        case 8:
            let notificationsVC = self.storyboard?.instantiateViewController(withIdentifier: "NotificationsVC") as! NotificationsVC
            navCtrl.pushViewController(notificationsVC, animated: true)
            break
        case 9:
            let accountVC = self.storyboard?.instantiateViewController(withIdentifier: "AccountPreviewVC") as! AccountPreviewVC
            navCtrl.pushViewController(accountVC, animated: true)
            break
        case 10:
            let touchIDVC = self.storyboard?.instantiateViewController(withIdentifier: "TouchIDFaceIDEnableVC") as! TouchIDFaceIDEnableVC
            navCtrl.pushViewController(touchIDVC, animated: true)
            break
        case 11:
            let changePassVC = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
            navCtrl.pushViewController(changePassVC, animated: true)
            break
        case 12:
            let contactVC = self.storyboard?.instantiateViewController(withIdentifier: "ContactUsVC") as! ContactUsVC
            navCtrl.pushViewController(contactVC, animated: true)
            break
        case 13:
            let webVC = self.storyboard?.instantiateViewController(withIdentifier:"WebViewVC") as! WebViewVC
            webVC.forHTML = true
            webVC.forFaqs = true
            self.navigationController?.pushViewController(webVC, animated: true)
            break
        case 14:
            let webVC = self.storyboard?.instantiateViewController(withIdentifier:"WebViewVC") as! WebViewVC
            webVC.forHTML = true
            webVC.forTerms = true
            self.navigationController?.pushViewController(webVC, animated: true)
            break
        case 15:
//            showDefaultAlert(title: "", message: "Coming Soon")
            let changePassVC = self.storyboard?.instantiateViewController(withIdentifier: "ChequeBookMainVC") as! ChequeBookMainVC
            navCtrl.pushViewController(changePassVC, animated: true)
            break
        case 16:
            let storyboard = UIStoryboard(name: "Notification Setting", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "NotificationSettingVC")
            
            navCtrl.pushViewController(vc, animated: true)
            break
        case 17:
            self.popUpLogout()
            
            break
            
            
            //
            //
            //        case 5:
            //            let buyVC = self.storyboard?.instantiateViewController(withIdentifier: "BuyMainVC") as! BuyMainVC
            //            navCtr?.pushViewController(buyVC, animated: true)
            //            break
            //
            //
            //        case 4:
            //            tabBarCtr.selectedIndex = 2
            //            navCtr!.popToRootViewController(animated: true)
            //            break
            //
            //
            //
            //        case 6:
            //            let casesVC = self.storyboard?.instantiateViewController(withIdentifier: "CasesMainVC") as! CasesMainVC
            //            navCtr?.pushViewController(casesVC, animated: true)
            //            break
            //
            //            //        case 8:
            //            //            let faqVC = self.storyboard?.instantiateViewController(withIdentifier: "FaqsVC") as! FaqsVC
            //            //            navCtr?.pushViewController(faqVC, animated: true)
            //            //            break
            //
            //
            //            //case 10:
            //
            //        case 7:
            //            let liveChatVC = self.storyboard?.instantiateViewController(withIdentifier: "LiveChatVC") as! LiveChatVC
            //            liveChatVC.isFromSideMenu = true
            //            navCtr?.pushViewController(liveChatVC, animated: true)
            //            break
            //
            //        case 8:
            //            let contUsVC = self.storyboard?.instantiateViewController(withIdentifier: "ContactUsVC") as! ContactUsVC
            //            navCtr?.pushViewController(contUsVC, animated: true)
            //            break
            //
            //        case 9:
            //            let helpMainVC = self.storyboard?.instantiateViewController(withIdentifier: "HelpMainvC") as! HelpMainvC
            //            navCtr?.pushViewController(helpMainVC, animated: true)
            //            break
            //
            //
            //            //            let helpVC = self.storyboard?.instantiateViewController(withIdentifier: "PageContentVC") as! PageContentVC
            //            //            helpVC.isFromSideMenu = true
            //            //            self.navigationController!.pushViewController(helpVC, animated: true)
            //
            //        case 10:
            //            let accountVC = self.storyboard?.instantiateViewController(withIdentifier: "AccountManageMainVC") as! AccountManageMainVC
            //            navCtr?.pushViewController(accountVC, animated: true)
            //            break
            //
            //        case 11:
            //            self.logoutUser()
            //            break
            
        default:
            drawer.setDrawerState(.closed, animated: true)
            
        }
        
        drawer.setDrawerState(.closed, animated: true)
        
    }
    
    
}

