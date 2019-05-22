//
//  Token.swift
//  PendelParkering
//
//  Created by Larsson, Henrik (94777) on 2019-05-22.
//  Copyright © 2019 Larsson, Henrik (94777). All rights reserved.
//

import Foundation

struct Token: Codable {
    let scope, tokenType: String
    let expiresIn: Int
    let accessToken: String
    
    enum CodingKeys: String, CodingKey {
        case scope
        case tokenType = "token_type"
        case expiresIn = "expires_in"
        case accessToken = "access_token"
    }
}
