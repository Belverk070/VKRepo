//
//  ServerError.swift
//  GeekBrainsProject
//
//  Created by Василий Метлин on 21.01.2022.
//

import UIKit

enum ServerError: Error {
    case noDataProvided
    case failedToDecode
    case errorTask
    case notCorrectUrl
}
