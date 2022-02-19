//
//  VKUsersModelPhoto.swift
//  GeekBrainsProject
//
//  Created by Василий Метлин on 11.12.2021.
//


import Foundation

struct VKFriendsPhotoResponse: Codable {
    var response: VKFriendsPhotoResponseData
}

struct VKFriendsPhotoResponseData: Codable {
    var count: Int
    var items: [FriendPhotos]
}

struct FriendPhotos: Codable {
    //    var albumId: Int
    //    var date: Int
    //    var id: Int
    var ownerId: Int
    //    var postId: Int?
    var sizes: [Sizes] 
    var text: String
    
    
    enum CodingKeys: String, CodingKey {
        //        case albumId = "album_id"
        //        case date
        //        case id
        case ownerId = "owner_id"
        //        case postId = "post_id"
        case sizes
        case text
    }
}

struct Sizes: Codable {
    
    var url: String
    var width: Int
    var height: Int
}

