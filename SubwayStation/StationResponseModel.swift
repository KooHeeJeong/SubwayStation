//
//  StationResponseModel.swift
//  SubwayStation
//
//  Created by 구희정 on 2022/08/01.
//

import Foundation

struct StationResponseModel: Decodable {
    //해당 StationResponseModel을 호출을 보다 쉽게 하기 위해서 아래와 같이
    //return 을 row 로 호출해서 보여준다.
    var stations: [Station] { searchInfo.row }
    
    private let searchInfo: SearchInfoBySubwayNameServiceModel
    
    enum CodingKeys: String, CodingKey {
        case searchInfo = "SearchInfoBySubwayNameService"
    }
    struct SearchInfoBySubwayNameServiceModel: Decodable {
        var row: [Station] = []
    }
}

struct Station: Decodable {
    let stationName: String
    let lineNumber: String
    
    enum CodingKeys: String, CodingKey {
        case stationName = "STATION_NM"
        case lineNumber = "LINE_NUM"
    }
}
