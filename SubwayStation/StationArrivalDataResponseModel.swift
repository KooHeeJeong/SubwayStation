//
//  StationArrivalDataResponseModel.swift
//  SubwayStation
//
//  Created by 구희정 on 2022/08/02.
//

import Foundation
//
//struct StationArrivalDataResponseModel: Decodable {
//    var realtimeArrivalList: [RealTimeArrival] = []
//
//    struct RealTimeArrival: Decodable {
//        let line: String /// ~행
//        let remainTime: String /// 도착까지 남은 시간 or 전역 출발
//        let currentStation: String /// 현재 위치
//
//        enum CodingKeys: String, CodingKey {
//            case line = "trainLineNm"
//            case remainTime = "arvlMsg2"
//            case currentStation = "arvlMsg3"
//        }
//    }
//}

struct StationArrivalDataResponseModel: Decodable {

    var realTimeStation: [RealTimeArrival] { realTimeStationInfo.row }

    private let realTimeStationInfo: realtimeStationArrivalModel

    enum CodingKeys: String, CodingKey {
        case realTimeStationInfo = "realtimeArrivalList"
    }

    struct realtimeStationArrivalModel: Decodable {
        var row: [RealTimeArrival] = []
    }

}
struct RealTimeArrival: Decodable {
    let line: String // ~행
    let remainTime: String // 도착까지 남은 시간 or 전역 출발
    let currentStation: String // 현재위치

    enum CodingKeys: String, CodingKey {
        case line = "trainLineNm"
        case remainTime = "arvlMsg2"
        case currentStation = "arvlMsg3"
    }
}

