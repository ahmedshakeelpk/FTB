//
//  KeyChainUtils.swift
//  Udeo Globe
//
//  Created by Hammad Hassan on 18/05/2020.
//  Copyright © 2020 Yasir Iqbal. All rights reserved.
//

import Foundation
import Security
import UIKit


class KeyChainUtils {
    
    let bundleID = Bundle.main.bundleIdentifier
    
    //MARK: - Add Data in Keychain:
    func addKeychainData(itemKey: String, itemValue: String) throws {
        
        guard let valueData = itemValue.data(using: .utf8) else {
            
            print("Keychain: Unable to store data, invalid input - key: \(itemKey), value: \(itemValue)")
            return
        }
        
        //delete old value if stored first
        do {
            
            try deleteKeychainData(itemKey: itemKey)
            
        } catch {
            
            print("Keychain: nothing to delete...")
        }
        
        let addQuery: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: itemKey as AnyObject,
            kSecValueData as String: valueData as AnyObject,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked
        ]
        
        let addResultCode: OSStatus = SecItemAdd(addQuery as CFDictionary, nil)
        
        if addResultCode != 0 {
            
            print("Keychain: value not added - Error: \(addResultCode)")
            
        } else {
            
            print("Keychain: value added successfully")
        }
    }
      
    //MARK: - Delete KeyChain Data:
      func deleteKeychainData(itemKey: String) throws {
        
          let deleteQuery: [String: AnyObject] = [
              kSecClass as String: kSecClassGenericPassword,
              kSecAttrAccount as String: itemKey as AnyObject
          ]
          
          let deleteResultCode = SecItemDelete(deleteQuery as CFDictionary)
          
          if deleteResultCode != 0 {
            
              print("Keychain: unable to delete from keychain: \(deleteResultCode)")
            
          } else {
            
              print("Keychain: successfully deleted item")
            
          }
        
      }
      
    
    
    //MARK: - Query KeyChain Data:
    
      func queryKeychainData (itemKey: String) throws -> String? {
        
          let loadQuery: [String: AnyObject] = [
              kSecClass as String: kSecClassGenericPassword,
              kSecAttrAccount as String: itemKey as AnyObject,
              kSecReturnData as String: kCFBooleanTrue,
              kSecMatchLimit as String: kSecMatchLimitOne
          ]
        
          var result: AnyObject?
        
          let loadResultCode = withUnsafeMutablePointer(to: &result) {
            
              SecItemCopyMatching(loadQuery as CFDictionary, UnsafeMutablePointer($0))
          }
          
          if loadResultCode != 0 {
              print("Keychain: unable to load data - \(loadResultCode)")
              return nil
          }
          
          guard let resultValue = result as? NSData, let keyValue = NSString(data: resultValue as Data, encoding: String.Encoding.utf8.rawValue) as String? else {
            
              print("Keychain: error parsing keychain result - \(loadResultCode)")
              return nil
          }
        
          return keyValue
      }
      
      
      /// Creates a new unique user identifier or retrieves the last one created
     static func getUUID() -> String? {

          /// create a keychain helper instance
          let keychain = KeyChainUtils()

          /// this is the key we'll use to store the uuid in the keychain
        /// let uuidKey = "com.myorg.myappid.unique_uuid"
        let uuidKey = (Bundle.main.bundleIdentifier ?? "") + ".unique_uuid"

          /// check if we already have a uuid stored, if so return it
          if let uuid = try? keychain.queryKeychainData(itemKey: uuidKey), uuid != nil {
            
              return uuid
          }

          /// generate a new id
          guard let newId = UIDevice.current.identifierForVendor?.uuidString else {
            
              return nil
          }

          /// store new identifier in keychain
          try? keychain.addKeychainData(itemKey: uuidKey, itemValue: newId)

          /// return new id
          return newId
      }
    
}
