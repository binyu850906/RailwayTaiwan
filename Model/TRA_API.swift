//
//  TRA_API.swift
//  RailwayTaiwan
//
//  Created by binyu on 2021/7/3.
//

import Foundation
import CryptoKit

struct Station: Codable {
    var StationID: String
    var StationName: NameType
    var StationPosition: StationPositionType
    var StationClass: String
    
    static func saveFile(station:[Station]) -> Void {
        let saveStations = try? JSONEncoder().encode(station)
        UserDefaults.standard.set(saveStations, forKey: "Stations")
    }
    
    static func readFile() -> [Station]? {
        guard let data = UserDefaults.standard.data(forKey: "Stations") else {return nil}
        return try? JSONDecoder().decode([Station].self, from: data)
    }
}

struct NameType:Codable {
    var Zh_tw: String
    var En: String
}

struct StationPositionType:Codable {
    var PositionLat: Float
    var PositionLon: Float
}

struct StationDetail:Codable {
    var StationID: String
    var StationName: NameType
    var Direction: Int
    var TrainTypeName: NameType
    var EndingStationName: NameType
    var ScheduledDepartureTime: String
    var DelayTime: Int
}



let APP_ID = "ce1241e923ee45a49d603b9afefa364b"
let APP_KEY = "VjmmGU8xqJOiAYNVAi2An601CBI"


let xdate = getTimeString()
let signDate = "x-date: " + xdate
let key = SymmetricKey(data: Data(APP_KEY.utf8))

let hmac = HMAC<SHA256>.authenticationCode(for: Data(signDate.utf8), using: key)
let base64HmacString = Data(hmac).base64EncodedString()
let authorization = """
    hmac username="\(APP_ID)", algorithm="hmac-sha256", headers="x-date", signature="\(base64HmacString)"
    """

func getTimeString() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ww zzz"
    dateFormatter.locale = Locale(identifier: "en_US")
    dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
    return dateFormatter.string(from: Date())
}
