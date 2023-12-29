//
//  TabQRSccaner.swift
//  scanQRcode
//
//  Created by Irum Butt on 20/07/2022.
//

import Foundation
import UIKit
import class MasterpassQRCoreSDK.PushPaymentData
import class MasterpassQRCoreSDK.MPQRParser

@objcMembers public class TapQRCodeScannerResult:NSObject {
    
    /// The raw string scanned from the scanner
    public var scannedText:String?
    public var SccanedImage : UIImage?
    /// The representation of the standardized emvco push data if a valid scanned one is provided
    public var scannedEmvcoPushData:PushPaymentData?
    
    
    init(scannedText:String) {
        super.init()
        self.scannedText = scannedText
        
        do {
            scannedEmvcoPushData = try MPQRParser.parse(string: scannedText)
        }catch{
            scannedEmvcoPushData = nil
            print("Scanned text is not a valid emvco code")
        }
        
        
        
    }
    
    
//
//    init(SccanedImage:UIImage)
//    {
//        self.SccanedImage = SccanedImage
//        do{
//            print("scannd image is ", SccanedImage)
//            scannedEmvcoPushData = try MPQRParser.parse(SccanedImage)
//        }
//    }
}
