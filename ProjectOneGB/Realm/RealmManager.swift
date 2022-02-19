//
//  RealmManager.swift
//  GeekBrainsProject
//
//  Created by Василий Метлин on 06.12.2021.
//

import Foundation
import RealmSwift
import Realm

class RealmManager {
    
    private var networkService = NetworkService()
    
    let operationQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.name = "operationQueue"
        queue.qualityOfService = .utility
        return queue
    }()
    
    private let queue = OperationQueue()
    let realm = try! Realm()
    
    func saveFriends(data: [Friend]) {
        do {
            realm.beginWrite()
            realm.add(data, update: .all)
            try realm.commitWrite()
            print("Friends: save successful")
        } catch {
            print(error)
        }
    }
    
    func getFriends() -> [Friend] {
        let listFriends = realm.objects(Friend.self)
        return Array(listFriends)
    }
    
    func saveGroups(data: [Group]) {
        do {
            realm.beginWrite()
            realm.add(data, update: .all)
            try realm.commitWrite()
            print("Groups: save successful")
        } catch {
            print(error)
        }
    }
    
    func getGroups() -> [Group] {
        let listGroup = realm.objects(Group.self)
        return Array(listGroup)
    }
    
    func updateGroups() {
        guard let request = networkService.getURLGroups() else { return }
        let getData = GetDataOperation(urlRequest: request)
        let parseData = ParseDataOperation()
        let saveData = SaveDataOperation()
        
        parseData.addDependency(getData)
        saveData.addDependency(parseData)
        
        operationQueue.addOperation(getData)
        print("GET DATA OK")
        operationQueue.addOperation(parseData)
        print("PARSE DATA OK")
        operationQueue.addOperation(saveData)
        print("SAVE DATA OK")
    }
    
}
