//
//  CRC16.swift
//  CRC16
//
//  Created by LimChihi on 11/30/16.
//  Copyright © 2016 linzhiyi. All rights reserved.
//

import Foundation


class CRC16 {
    public var crcTable: [Int] = []
    /// Seed, You should change this seed.
    public let gPloy = 0x0000
    
    static let instance = CRC16()
    
    public init() {
        computeCrcTable()
    }
    
    func getCRCResult(by data: [UInt8]) -> [UInt8] {
        var crc = getCrc(data: data)
        var crcArr  = [data] as! [UInt8]
        for i in (0..<2).reversed() {
            crcArr[i] = UInt8(crc % 256)
            crc >>= 8
        }
        return crcArr
    }
    
    func getCRCResult(by stringData: String, using encoding: String.Encoding = .utf8) -> [UInt8]? {
        guard let data = stringData.data(using: encoding) else {
            return nil
        }
        return getCRCResult(by: [UInt8](data))
    }
    
    /**
     Generate CRC16 Code of 0-255
     */
    public func computeCrcTable() {
        for i in 0..<256 {
            crcTable.append(getCrcOfByte(aByte: i))
        }
    }
    
    public func getCrcOfByte(aByte: Int) -> Int {
        var value = aByte << 8
        for _ in 0 ..< 8 {
            if (value & 0x8000) != 0 {
                value = (value << 1) ^ gPloy
            }else {
                value = value << 1
            }
        }
        
        value = value & 0xFFFF //get low 16 bit value
        
        return value
    }
    
    public func getCrc(data: [UInt8]) -> UInt16 {
        var crc = 0
        let dataInt: [Int] = data.map{Int( $0) }
        
        let length = data.count
        
        for i in 0 ..< length {
            crc = ((crc & 0xFF) << 8) ^ crcTable[(((crc & 0xFF00) >> 8) ^  dataInt[i]) & 0xFF]
        }
        
        crc = crc & 0xFFFF
        return UInt16(crc)
        print("value of crc", crc)
    }
    
}
