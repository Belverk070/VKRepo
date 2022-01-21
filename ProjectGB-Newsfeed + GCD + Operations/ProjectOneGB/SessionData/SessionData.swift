//
//  SessionData.swift
//  GeekBrainsProject
//
//  Created by Василий Метлин on 18.11.2021.
//

import UIKit

class SessionData {
   
    static let instance = SessionData()
    
    var token: String?
    var userId: Int?
    
    private init () {}
    
}
