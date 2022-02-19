//
//  NewsfeedModel.swift
//  GeekBrainsProject
//
//  Created by Василий Метлин on 14.01.2022.
//

import UIKit

struct NewsModel: Codable {
    let postID: Int
    let text: String
    let date: Double
    let attachments: [Attachment]?
    let likes: Likes
    let comments: Comments
    let reposts: Reposts
    let views: Views
    let sizes: [Sizes]?
    let sourceID: Int
    var avatarURL: String?
    var creatorName: String?
    var photosURL: [String]? {
        get {
            let photosURL = attachments?.compactMap{ $0.photo?.sizes?.last?.url }
            return photosURL
        }
    }

    var aspectRatio: CGFloat {
        get {
            let aspectRatio = attachments?.compactMap{ $0.photo?.sizes?.last?.aspectRatio}.last
            return aspectRatio ?? 1
        }
    }
  
    enum CodingKeys: String, CodingKey {
        case postID = "post_id"
        case text
        case date
        case likes
        case comments
        case reposts
        case views
        case sizes
        case attachments
        case sourceID = "source_id"
        case avatarURL
        case creatorName
    }
    
    func getStringDate() -> String {
        let dateFormatter = DateFormatterVK()
        return dateFormatter.convertDate(timeIntervalSince1970: date)
    }
    
}

// MARK: - NewsfeedResponse
struct NewsfeedResponse: Codable {
    let response: Response
}

// MARK: - Response
struct Response: Codable {
    let items: [NewsModel]
    let profiles: [Profile]
    let groups: [Groups]
    let nextFrom: String?
    
    enum CodingKeys: String, CodingKey {
        case items, groups
        case profiles
        case nextFrom = "next_from"
    }
}

// MARK: - Group
struct Groups: Codable {
    let id: Int?
    let name: String?
    let photo100: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case photo100 = "photo_100"
    }
}

// MARK: - Item
struct Item: Codable {
    let sourceID: Int?
    let date: Double
    let text: String?
    let attachments: [Attachment]?
    let comments: Comments?
    let likes: Likes?
    let reposts: Reposts?
    let views: Views?
    var photosURL: [String]? {
        get {
            let photosURL = attachments?.compactMap{ $0.photo?.sizes?.last?.url }
            return photosURL
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case sourceID = "source_id"
        case date
        case text
        case attachments
        case comments, likes, reposts, views
    }
    
    func getStringDate() -> String {
        let dateFormatter = DateFormatterVK()
        return dateFormatter.convertDate(timeIntervalSince1970: date)
    }
    
}

// MARK: - Attachment
struct Attachment: Codable {
    let type: String?
    let photo: Photo?
}

// MARK: - Photo
struct Photo: Codable {
    let id: Int?
    let ownerID: Int?
    let sizes: [Size]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case ownerID = "owner_id"
        case sizes
    }
}

// MARK: - Size
struct Size: Codable {
    let height: Int?
    let url: String?
    let width: Int?
    
    var aspectRatio: CGFloat { return CGFloat(height ?? 1) / CGFloat(width ?? 1)}
}

// MARK: - Comments
struct Comments: Codable {
    let count: Int
    
    enum CodingKeys: String, CodingKey {
        case count
    }
}


// MARK: - Likes
struct Likes: Codable {
    let count: Int
 
    enum CodingKeys: String, CodingKey {
        case count
    }
}

// MARK: - Reposts
struct Reposts: Codable {
    let count, userReposted: Int
    
    enum CodingKeys: String, CodingKey {
        case count
        case userReposted = "user_reposted"
    }
}

// MARK: - Views
struct Views: Codable {
    let count: Int
}

// MARK: - Profile
struct Profile: Codable {
    let id: Int?
    let firstName, lastName: String?
    let photo100: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case photo100 = "photo_100"
    }
}

class DateFormatterVK {
    let dateFormatter = DateFormatter()
    
    func convertDate(timeIntervalSince1970: Double) -> String{
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let date = Date(timeIntervalSince1970: timeIntervalSince1970)
        return dateFormatter.string(from: date)
    }
}

