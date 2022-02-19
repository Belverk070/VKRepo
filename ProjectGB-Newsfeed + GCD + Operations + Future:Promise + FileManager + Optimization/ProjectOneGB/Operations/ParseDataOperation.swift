//
//  ParseDataOperation.swift
//  GeekBrainsProject
//
//  Created by Василий Метлин on 21.01.2022.
//

import Foundation
import RealmSwift

class ParseDataOperation: Operation {
    
    var outputData: List<Group>?
    
    override func main() {
        guard let getDataOperation = dependencies.first as? GetDataOperation,
              let data = getDataOperation.data else { return }
        
        guard let fetchedResponse = try? JSONDecoder().decode(VKGroupsResponse.self, from: data).response?.items else {
            print(ServerError.failedToDecode)
            return
        }
        outputData = fetchedResponse
        print(outputData)
    }
}
