//
//  ResModel.swift
//  Widgets
//
//  Created by zhang shijie on 2023/6/15.
//

import Foundation

// MARK: - Welcome
struct Welcome: Codable {
    let code, updateTime: String
    let fxLink: String
    let daily: [Daily]
    let refer: Refer
}

// MARK: - Daily
struct Daily: Codable,Hashable {
    let fxDate, sunrise, sunset, moonrise: String
    let moonset, moonPhase, moonPhaseIcon, tempMax: String
    let tempMin, iconDay, textDay, iconNight: String
    let textNight, wind360Day, windDirDay, windScaleDay: String
    let windSpeedDay, wind360Night, windDirNight, windScaleNight: String
    let windSpeedNight, humidity, precip, pressure: String
    let vis, cloud, uvIndex: String
}

// MARK: - Refer
struct Refer: Codable {
    let sources, license: [String]
}
