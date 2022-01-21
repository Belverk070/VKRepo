//
//  NetworkService.swift
//  GeekBrainsProject
//
//  Created by Василий Метлин on 21.01.2022.
//

import Foundation

class NetworkService {
    
    private var urlConstructor = URLComponents()
    private let constants = NetworkConstants()
    private let configuration: URLSessionConfiguration!
    private let session: URLSession!
    
    init(){
        urlConstructor.scheme = "https"
        urlConstructor.host = "api.vk.com"
        configuration = URLSessionConfiguration.default
        session = URLSession(configuration: configuration)
    }
    
    func getURLGroups() -> URL? {
        urlConstructor.path = "/method/groups.get"

        urlConstructor.queryItems = [
            URLQueryItem(name: "extended", value: "1"),
            URLQueryItem(name: "fields", value: "description"),
            URLQueryItem(name: "access_token", value: SessionData.instance.token),
            URLQueryItem(name: "v", value: constants.versionAPI),
        ]
        return urlConstructor.url
    }
    
}
