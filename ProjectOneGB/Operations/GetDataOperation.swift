//
//  GetDataOperation.swift
//  GeekBrainsProject
//
//  Created by Василий Метлин on 21.01.2022.
//

import UIKit
import Alamofire


class GetDataOperation: AsyncOperations {
    
    private var urlConstructor = URLComponents()
    private let configuration: URLSessionConfiguration!
    private let session: URLSession!
    private let constants = NetworkConstants()
    private var urlRequest: URL
    private var task: URLSessionTask?
    
    var data: Data?

    override func cancel() {
        task?.cancel()
        super.cancel()
    }
    
    override func main() {
        task = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            guard error == nil else {
                print(ServerError.errorTask)
                return
            }
            guard let data = data else {
                print(ServerError.noDataProvided)
                return
            }
            self.data = data
            self.state = .finished
        })
        task?.resume()
    }
    
    init(urlRequest: URL) {
        urlConstructor.scheme = constants.scheme
        urlConstructor.host = constants.host
        configuration = URLSessionConfiguration.default
        session = URLSession(configuration: configuration)
        
        self.urlRequest = urlRequest
    }
}
