//
//  Extensions.swift
//  Spacemy
//
//  Created by Giovanni Prisco on 19/02/2020.
//  Copyright © 2020 Giovanni Prisco. All rights reserved.
//

import Foundation

extension ISO8601DateFormatter {
    convenience init(_ formatOptions: Options, timeZone: TimeZone = TimeZone(secondsFromGMT: 0)!) {
        self.init()
        self.formatOptions = formatOptions
        self.timeZone = timeZone
    }
}

extension Formatter {
    static let iso8601 = ISO8601DateFormatter([.withInternetDateTime, .withFractionalSeconds])
}

extension Date {
    var iso8601String: String {
        return Formatter.iso8601.string(from: self)
    }
    
    var dateToText: String {
        let df = DateFormatter()
        df.dateFormat = "dd-MM-yyyy"
        
        return df.string(from: self)
    }
    
    var isoToTimeString: String {
        let df = DateFormatter()
        df.dateFormat = "hh:mm"
        
        return df.string(from: self)
    }
    
    var dayMonth: String {
        let df = DateFormatter()
        df.dateFormat = "dd/MM"
        
        return df.string(from: self)
    }
}

extension String {
    var iso8601Date: Date? {
        return Formatter.iso8601.date(from: self)
    }
    
    var dayMonth: String {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        
        let date = df.date(from: self)
        
        df.dateFormat = "dd/MM"
        
        return df.string(from: date!)
    }
}

func decode(jwtToken jwt: String) -> [String: Any] {
    let segments = jwt.components(separatedBy: ".")
    return decodeJWTPart(segments[1]) ?? [:]
}

func base64UrlDecode(_ value: String) -> Data? {
    var base64 = value
        .replacingOccurrences(of: "-", with: "+")
        .replacingOccurrences(of: "_", with: "/")
    
    let length = Double(base64.lengthOfBytes(using: String.Encoding.utf8))
    let requiredLength = 4 * ceil(length / 4.0)
    let paddingLength = requiredLength - length
    if paddingLength > 0 {
        let padding = "".padding(toLength: Int(paddingLength), withPad: "=", startingAt: 0)
        base64 = base64 + padding
    }
    return Data(base64Encoded: base64, options: .ignoreUnknownCharacters)
}

func decodeJWTPart(_ value: String) -> [String: Any]? {
    guard let bodyData = base64UrlDecode(value),
        let json = try? JSONSerialization.jsonObject(with: bodyData, options: []), let payload = json as? [String: Any] else {
            return nil
    }
    
    return payload
}
