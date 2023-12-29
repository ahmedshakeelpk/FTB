//
//  URLSessionMethodVc.swift
//  First Touch Banking
//
//  Created by Arsalan Amjad on 18/05/2022.
//  Copyright © 2022 irum Zubair. All rights reserved.
//


import Foundation
import UIKit
public struct URLSessionMethodVc {
//    testinf url
//    let baseURL = URL(string: "http://192.168.233.36:8070/")!
    
//    live url
    let baseURL = URL(string: "https://app.fmfb.com.pk/")!
    public static let shared = URLSessionMethodVc()
    let decoder = JSONDecoder()

    public enum APIError: Error {
        case noResponse
        case jsonDecodingError(error: Error)
        case networkError(error: Error)
    }

    public enum Endpoint {
      
//        case  delete(id: String)
        case whtCalculations
       
        func path() -> String {
            switch self {
            
//            case let .delete(id):
//                return "playlists/deletePlaylist/\(id)"
            case .whtCalculations:
                return "/api/v1/Customers/Accounts/whtCalculations"
          
            }
        }
    }

    public enum Method {
        case get
        case post
        case delete
        case put

        func path() -> String {
            switch self {
            case .get:
                return "GET"
            case .post:
                return "POST"
            case .delete:
                return "DELETE"
            case .put:
                return "PUT"
            }

        }
    }

    public func REQUEST<T: Codable>(endpoint: Endpoint,
                                    method: Method,
                                    params: [String: Any]?,
                                    completionHandler: @escaping (Result<T, APIError>) -> Void) {
        let queryURL = baseURL.appendingPathComponent(endpoint.path())
        //        var components = URLComponents(url: queryURL, resolvingAgainstBaseURL: true)!
        //        components.queryItems = [
        //           URLQueryItem(name: "api_key", value: apiKey),
        //           URLQueryItem(name: "language", value: Locale.preferredLanguages[0])
        //        ]
        //        if let params = params {
        //            for (_, value
        let paramsData = try! JSONSerialization.data(withJSONObject: params ?? [], options: [])
        guard let token = UserDefaults.standard.string(forKey: "token") else { return }
            
          let  TOKEN = token ?? ""
        

        var request = URLRequest(url: queryURL)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer " + TOKEN, forHTTPHeaderField: "Authorization")
        request.setValue("BgUWEvVcpa+cFuB9tCDgzA==", forHTTPHeaderField: "clientSecret")
        request.setValue("143", forHTTPHeaderField: "clientID")
        request.setValue("1", forHTTPHeaderField: "channelID")

        request.httpMethod = method.path()

        if method == .post {
            request.httpBody = paramsData
        }

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completionHandler(.failure(.noResponse))
                }
                return
            }
            guard error == nil else {
                DispatchQueue.main.async {
                    completionHandler(.failure(.networkError(error: error!)))
                }
                return
            }
            do {
                let object = try self.decoder.decode(T.self, from: data)
                DispatchQueue.main.async {
                    completionHandler(.success(object))
                }
            } catch let error {
                DispatchQueue.main.async {
                    #if DEBUG
                    print("JSON Decoding Error: \(error)")
                    #endif
                    completionHandler(.failure(.jsonDecodingError(error: error)))
                }
            }
            
        }
        task.resume()
    }

}

