//
//  NetworkManager.swift
//  First Touch Banking
//
//  Created by Syed Uzair Ahmed on 23/11/2017.
//  Copyright © 2017 Syed Uzair Ahmed. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

//import AlamofireObjectMapper
class NetworkManager {
    
    static let sharedInstance = NetworkManager()
    var sessionManager: Session?
    
    func enableCertificatePinning() {

//         For certificates
//                let trustPolicy = ServerTrustPolicy.pinCertificates(
//                    certificates: ServerTrustPolicy.certificates(),
//                    validateCertificateChain: true,
//                    validateHost: true)

        // For PublicKey pining
//        let serverTrustPolicy = ServerTrustPolicy.pinPublicKeys(
//            publicKeys: ServerTrustPolicy.publicKeys(),
//            validateCertificateChain: true,
//            validateHost: true)
//
//        let trustPolicies = [ "https://bb.fmfb.pk": serverTrustPolicy ]
//        let policyManager =  ServerTrustManager(policies: trustPolicies)
//        sessionManager = Session(
//            configuration: .default,
//            serverTrustManager: policyManager)
        
        let evaluators: [String: ServerTrustEvaluating] = [
            "https://app.fmfb.com.pk": PublicKeysTrustEvaluator(
                performDefaultValidation: false,
                validateHost: true
            )
            
        ]
//        let evaluators: [String: ServerTrustEvaluating] = [
//            "https://bb.fmfb.pk": PublicKeysTrustEvaluator()
//        ]
        
//        let evaluators: [String: ServerTrustEvaluating] = [
//            "https://bb.fmfb.com": PublicKeysTrustEvaluator.publicKeys(),
//          ]
//        let evaluators: [String: ServerTrustEvaluating] = [
//            "https://bb.fmfb.com": PinnedCertificatesTrustEvaluator(certificates: certificate()),
//          ]
        let serverTrustManager = ServerTrustManager(
            allHostsMustBeEvaluated: false,
            evaluators: evaluators
        )
        sessionManager = Session(serverTrustManager: serverTrustManager)
        
    }
    
    func certificate() -> [SecCertificate] {
        let filePath = Bundle.main.path(forResource: "app.fmfb.com.pk", ofType: "cer")!
//        let data = try! Data(contentsOf: URL(fileURLWithPath: filePath))
        var data : NSData = NSData(contentsOfFile: filePath)!

        
        var certificates: [SecCertificate] = []

        do {
            let pinnedCertificateData: CFData = try Data(contentsOf: URL(fileURLWithPath: filePath)) as CFData
            let certificate = SecCertificateCreateWithData(nil, data as CFData)!
            certificates.append(certificate)
           
        } catch {
            //...
            print("caught: \(error)")
        }
        
        return certificates
    }
    
    func pinnedCertificates() -> [SecCertificate] {
        
        var certificates: [SecCertificate] = []
        let filePath = Bundle.main.path(forResource: "app.fmfb.com.pk.cer", ofType: nil)!
        
        
        let directoryContents: [URL] = [URL(fileURLWithPath: filePath)]
        
        let certificateName: String = "app.fmfb.com.pk.cer" // Replaced for the demo
        
        let pinnedCertificateURL: URL? = directoryContents.first { (url: URL) in url.lastPathComponent == certificateName }
        
        if let pinnedCertificateURL: URL = pinnedCertificateURL {
            do {
                let pinnedCertificateData: CFData = try Data(contentsOf: pinnedCertificateURL) as CFData
                if let pinnedCertificate: SecCertificate = SecCertificateCreateWithData(nil, pinnedCertificateData) {
                    certificates.append(pinnedCertificate)
                }
                else {
                    
                }
            } catch {
                //...
                print("caught: \(error)")
            }
        }
        return certificates
    }
}

//class NetworkManager {
//
//    static let sharedInstance = NetworkManager()
//
//
//     var sessionManager: SessionManager?
//
//
//     func enableCertificatePinning() {
//
//        // For certificates
//                let trustPolicy = ServerTrustPolicy.pinCertificates(
//                    certificates: ServerTrustPolicy.certificates(),
//                    validateCertificateChain: true,
//                    validateHost: true)
//
//        // For PublicKey pining
//        let serverTrustPolicy = ServerTrustPolicy.pinPublicKeys(
//            publicKeys: ServerTrustPolicy.publicKeys(),
//            validateCertificateChain: true,
//            validateHost: true)
//
//
//
//        let trustPolicies = [ "https://app.fmfb.com.pk": serverTrustPolicy ]
//        let policyManager =  ServerTrustPolicyManager(policies: trustPolicies)
//        sessionManager = SessionManager(
//            configuration: .default,
//            serverTrustPolicyManager: policyManager)
//    }
//
//
//    func serverRequest() -> SessionManager {
//          return NetworkManager.sharedInstance.sessionManager!
//       }
//
//}
