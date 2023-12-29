//
//  NetworkConnectivity.swift
//  OJO Selfcare
//
//  Created by Syed Uzair Ahmed on 16/08/2017.
//  Copyright © 2017 evampsaanga. All rights reserved.
//

import Foundation
import Alamofire

class NetworkConnectivity {
    
    
    class func isConnectedToInternet() -> Bool{
        return (NetworkReachabilityManager()?.isReachable)!
    }
    
}
