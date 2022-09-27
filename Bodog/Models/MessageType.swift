//
//  MessageType.swift
//  Bodog
//
//  Created by Anastasia Koldunova on 20.09.2022.
//

import Foundation


enum MessageType: Codable {
    case startGame(StartGameModel)
    case gameOver([RateModel])
    case user(UserInfo)
}


struct StartGameModel: Codable {
    public let stake: Int
    public let world: [String]
}

struct UserInfo: Codable {
    public let userName: String
    public let iconMane:String
}
