//
//  Scanning_UplaodingVc.swift
//  First Touch Banking
//
//  Created by Arsalan Amjad on 19/08/2022.
//  Copyright © 2022 irum Zubair. All rights reserved.
//

import UIKit
import Alamofire
import Alamofire
//import AlamofireObjectMapper
import Nuke
import MobileCoreServices
import Photos
import OpalImagePicker
import MapKit

var Is_From_Camera = "False"
var Is_From_Gallery = "False"
class Scanning_UplaodingVc: BaseVC , UINavigationControllerDelegate, UIImagePickerControllerDelegate, OpalImagePickerControllerDelegate{
    var Fetch_img : UIImage?
    var Ftech_String : String?
    var imagePicker = UIImagePickerController()
    var pickImageCallback : ((UIImage) -> ())?;
    var alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
    var getString : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        print("image is" ,Fetch_img)
        print("string is,",Ftech_String)
        imgView.image = Fetch_img
//        btnprocess.isHidden = true
      
        
        Change_Langugae()
       
        
//        imgView.image = UIImage(named: "checkbox_state2.png")
//        Ftech_String = "002020102120202000424PK96FMFB00211224038710120503123071231082022160010049FBB"
//        Is_From_Camera = "true"
    }
    @IBOutlet weak var btn_ReScan: UIButton!
    @IBOutlet weak var Main_Title: UILabel!
    @IBOutlet weak var btnprocess: UIButton!
    @IBOutlet weak var btnUpload: UIButton!
    @IBOutlet weak var imgView: UIImageView!
    @IBAction func Process(_ sender: UIButton) {
        if Is_From_Camera == "true"
          
        {
            let vc = storyboard?.instantiateViewController(withIdentifier: "ScanReader_VC") as! ScanReader_VC
            vc.Fetch_img = Fetch_img
            vc.Ftech_String = Ftech_String!
            Is_From_Camera = "true"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if Is_From_Gallery == "true"{
            let vc = storyboard?.instantiateViewController(withIdentifier: "ReadQRVC") as! ReadQRVC
//            vc.Fetch_img = Fetch_img
            vc.Fetch_img =  imgView.image
            vc.Ftech_String = getString
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
        
    }
    
    @IBAction func Action_REScan(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "Scan_QRVC") as! Scan_QRVC
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    @IBAction func Upload(_ sender: UIButton) {
//        if imgView.image == nil
//        {
//            btnprocess.isHidden = true
//        }
          Is_From_Camera = "False"
            Is_From_Gallery = "true"
            let alert:UIAlertController = UIAlertController(title: "Which Scanner?", message: "Please from where you want to get the qr code info", preferredStyle: .actionSheet)
            let fromImageAction:UIAlertAction = UIAlertAction(title: "From Gallery", style: .default) { [weak self] _ in
                DispatchQueue.main.async {
                   let imagePicker:UIImagePickerController =  UIImagePickerController()
                              imagePicker.delegate = self
                              imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
                              imagePicker.allowsEditing = true
    //                self?.navigationController?.pushViewController(imagePicker, animated: true)
                              self?.present(imagePicker, animated: true, completion: nil)
                }
            }
            alert.addAction(fromImageAction)
            
            self.present(alert,animated: true)
        }

        
        
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
  
    func Change_Langugae()
    {
        Main_Title.text = "SCAN QR".addLocalizableString(languageCode: languageCode)
        btnUpload.setTitle("UPLOAD".addLocalizableString(languageCode: languageCode), for: .normal)
        btn_ReScan.setTitle("RESCAN".addLocalizableString(languageCode: languageCode), for: .normal)
        btnprocess.setTitle("PROCESS".addLocalizableString(languageCode: languageCode), for: .normal)
        
    }
    
}
extension Scanning_UplaodingVc {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        DispatchQueue.main.async { [unowned picker, weak self] in
//            self?.loadingActivity.isHidden = false
            picker.dismiss(animated: true) { [self] in
                if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
                  
                    // imageViewPic.contentMode = .scaleToFill
                    let res:TapQRCodeScannerResult = TapQRCodeScanner().scan(from: pickedImage)
                    print(res.scannedText ?? "")
                    if   res.scannedText == "" &&  res.scannedText! <  "\(54)"

                    {
                        self?.showAlert(title: "", message: "Invalid Image..", completion: nil)
                       
                    }
                    else
                    {
//                        self?.showAlert(with: "Scanned", message: res.scannedText ?? "")
                        self?.getString = res.scannedText
                         self?.imgView.image = pickedImage
                        self?.btnprocess.isHidden = false

                        
                    }
                   
                }
//                self?.loadingActivity.isHidden = true
            }
        }
    }
    
}



