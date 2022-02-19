//
//  VKGroupsModel.swift
//  GeekBrainsProject
//
//  Created by Василий Метлин on 07.12.2021.
//

import UIKit
import RealmSwift

@objcMembers
class VKGroupsResponse: Object, Codable {
    dynamic var response: VKGroupsResponseData? = nil
}

@objcMembers
class VKGroupsResponseData: Object, Codable {
    dynamic var count: Int = 0
    dynamic var items = List<Group>()
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        count = try container.decode(Int.self, forKey: .count)
        let itemsList = try container.decode([Group].self, forKey: .items)
        items.append(objectsIn: itemsList)
        super.init()
    }
    required override init() {
        super.init()
    }
}

@objcMembers
class Group: Object, Codable {
    dynamic var id: Int
    dynamic var name: String
    dynamic var screenName: String
    dynamic var isClosed: Int
    dynamic var type: String
    dynamic var isAdmin: Int
    dynamic var isMember: Int
    dynamic var isAdvertiser: Int
    dynamic var photo50: String
    dynamic var photo100: String
    dynamic var photo200: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case screenName = "screen_name"
        case isClosed = "is_closed"
        case type
        case isAdmin = "is_admin"
        case isMember = "is_member"
        case isAdvertiser = "is_advertiser"
        case photo50 = "photo_50"
        case photo100 = "photo_100"
        case photo200 = "photo_200"
        
    }
    
    override class func primaryKey() -> String? {
        "id"
    }
    
}
