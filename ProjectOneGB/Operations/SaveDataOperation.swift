//
//  SaveDataOperation.swift
//  GeekBrainsProject
//
//  Created by Василий Метлин on 21.01.2022.
//

import UIKit
import RealmSwift

class SaveDataOperation: Operation {
    
    override func main() {
        guard let parseDataOperation = dependencies.first as? ParseDataOperation,
              let outputData = parseDataOperation.outputData else { return }
        
        do {
            let realm = try! Realm()
            let data = [Group]()
            realm.beginWrite()
            realm.add(data, update: .all)
            try realm.commitWrite()
            print("Groups: save successful")
        } catch {
            print(error)
        }
    }
}

