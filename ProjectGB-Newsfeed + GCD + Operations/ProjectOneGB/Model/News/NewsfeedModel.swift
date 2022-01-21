//
//  NewsfeedModel.swift
//  GeekBrainsProject
//
//  Created by Василий Метлин on 14.01.2022.
//

import Foundation

//struct NewsModel: Codable {
//    let postID: Int
//    let text: String
//    let date: Double
//    let attachments: [Attachment]?
//    let likes: LikeModel
//    let comments: CommentModel
//    let sourceID: Int
//    var avatarURL: String?
//    var creatorName: String?
//    var photosURL: [String]? {
//        get {
//            let photosURL = attachments?.compactMap{ $0.photo?.sizes?.last?.url }
//            return photosURL
//        }
//    }
//    enum CodingKeys: String, CodingKey {
//        case postID = "post_id"
//        case text
//        case date
//        case likes
//        case comments
//        case attachments
//        case sourceID = "source_id"
//        case avatarURL
//        case creatorName
//    }
//
//    func getStringDate() -> String {
//        let dateFormatter = DateFormatterVK()
//        return dateFormatter.convertDate(timeIntervalSince1970: date)
//    }
//
//}
//
//struct Attachment: Codable {
//    let type: String?
//    let photo: PhotoNews?
//}
//
//struct LikeModel: Codable {
//    let count: Int
//}
//
//struct CommentModel: Codable {
//    let count: Int
//}
//
//struct PhotoNews: Codable {
//    let id: Int?
//    let ownerID: Int?
//    let sizes: [SizeNews]?
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case ownerID = "owner_id"
//        case sizes
//    }
//}
//
//struct SizeNews: Codable {
//    let type: String?
//    let url: String?
//}
//
//class DateFormatterVK {
//    let dateFormatter = DateFormatter()
//
//    func convertDate(timeIntervalSince1970: Double) -> String{
//        dateFormatter.dateFormat = "MM-dd-yyyy HH.mm"
//        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
//        let date = Date(timeIntervalSince1970: timeIntervalSince1970)
//        return dateFormatter.string(from: date)
//    }
//}
//
//struct ResponseNews: Codable {
//    let response: ItemsNews
//}
//
//struct ItemsNews: Codable {
//    let items: [NewsModel]
//    let profiles: [ProfileNews]
//    let groups: [GroupNews]
//    let nextFrom: String
//
//    enum CodingKeys: String, CodingKey {
//        case items
//        case profiles
//        case groups
//        case nextFrom = "next_from"
//    }
//}
//
//struct ProfileNews: Codable {
//    let id: Int
//    let firstName: String
//    let lastName: String
//    let avatarURL: String
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case firstName = "first_name"
//        case lastName = "last_name"
//        case avatarURL = "photo_100"
//    }
//}
//
//struct GroupNews: Codable {
//    let id: Int
//    let name: String
//    let avatarURL: String
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case name
//        case avatarURL = "photo_100"
//    }
//}


// MARK: - NewsfeedResponse
struct NewsfeedResponse: Codable {
    let response: Response
}

// MARK: - Response
struct Response: Codable {
    let items: [Item]?
    let profiles: [Profile]?
    let groups: [Groups]?
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
        //        let screenName: String?
        //    let isClosed: Int?
        //    let type: String?
        //    let isAdmin, isMember, isAdvertiser: Int?
        //    let photo50: String?
        let photo100: String?
    
    //        let photo200: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name
        //        case screenName = "screen_name"
        //        case isClosed = "is_closed"
        //        case type
        //        case isAdmin = "is_admin"
        //        case isMember = "is_member"
        //        case isAdvertiser = "is_advertiser"
        //        case photo50 = "photo_50"
        case photo100 = "photo_100"
        //        case photo200 = "photo_200"
    }
}

// MARK: - Item
struct Item: Codable {
    let sourceID: Int?
    let date: Double
    //    let canDoubtCategory, canSetCategory: Bool?
    //    let postType,
    let text: String?
    //    let markedAsAds: Int?
    let attachments: [Attachment]?
    //    let postSource: PostSource?
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
    //    let isFavorite: Bool?
    //    let donut: Donut?
    //    let shortTextRate: Double?
    //    let postID: Int?
    //    let type: String?
    
    enum CodingKeys: String, CodingKey {
        case sourceID = "source_id"
        case date
        //        case canDoubtCategory = "can_doubt_category"
        //        case canSetCategory = "can_set_category"
        //        case postType = "post_type"
        case text
        //        case markedAsAds = "marked_as_ads"
        case attachments
        //        case postSource = "post_source"
        case comments, likes, reposts, views
        //        case isFavorite = "is_favorite"
        //        case donut
        //        case shortTextRate = "short_text_rate"
        //        case postID = "post_id"
        //        case type
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
    //    let albumID: Int?
    //    let date: Int?
    let id: Int?
    let ownerID: Int?
    //    let accessKey: String?
    let sizes: [Size]?
    
    //    let text: String?
    //    let userID: Int?
    //    let hasTags: Bool?
    
    enum CodingKeys: String, CodingKey {
        //        case albumID = "album_id"
        //        case date
        case id
        case ownerID = "owner_id"
        //        case accessKey = "access_key"
        case sizes
        //             case text
        //        case userID = "user_id"
        //        case hasTags = "has_tags"
    }
}

// MARK: - Size
struct Size: Codable {
    //    let height: Int?
    let url: String? 
    //    let type: String?
    //    let width: Int?
}

// MARK: - Comments
struct Comments: Codable {
    //    let canPost: Int?
    let count: Int?
    //    let groupsCanPost: Bool?
    
    enum CodingKeys: String, CodingKey {
        //        case canPost = "can_post"
        case count
        //        case groupsCanPost = "groups_can_post"
    }
}

//// MARK: - Donut
//struct Donut: Codable {
//    let isDonut: Bool?
//
//    enum CodingKeys: String, CodingKey {
//        case isDonut = "is_donut"
//    }
//}

// MARK: - Likes
struct Likes: Codable {
    //    let canLike: Int?
    let count: Int?
    //    let userLikes: Int?
    //        let canPublish: Int?
    
    enum CodingKeys: String, CodingKey {
        //        case canLike = "can_like"
        case count
        //        case userLikes = "user_likes"
        //        case canPublish = "can_publish"
    }
}

//// MARK: - PostSource
//struct PostSource: Codable {
//    let platform, type: String?
//}

// MARK: - Reposts
struct Reposts: Codable {
    let count, userReposted: Int?

    enum CodingKeys: String, CodingKey {
        case count
        case userReposted = "user_reposted"
    }
}

// MARK: - Views
struct Views: Codable {
    let count: Int?
}

// MARK: - Profile
struct Profile: Codable {
    let id: Int?
    let firstName, lastName: String?
    //    let canAccessClosed, isClosed: Bool?
//    let sex: Int?
//    let screenName: String?
    //    let photo50: String?
    let photo100: String?
    //    let onlineInfo: OnlineInfo?
    //    let online: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
//        case canAccessClosed = "can_access_closed"
//        case isClosed = "is_closed"
//        case sex
//        case screenName = "screen_name"
//        case photo50 = "photo_50"
        case photo100 = "photo_100"
        //        case onlineInfo = "online_info"
        //        case online
    }
}

class DateFormatterVK {
    let dateFormatter = DateFormatter()

    func convertDate(timeIntervalSince1970: Double) -> String{
        dateFormatter.dateFormat = "MM-dd-yyyy HH.mm"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let date = Date(timeIntervalSince1970: timeIntervalSince1970)
        return dateFormatter.string(from: date)
    }
}

//// MARK: - OnlineInfo
//struct OnlineInfo: Codable {
//    let visible, isOnline, isMobile: Bool?
//
//    enum CodingKeys: String, CodingKey {
//        case visible
//        case isOnline = "is_online"
//        case isMobile = "is_mobile"
//    }
//}
