//
//  NetworkError.swift
//  TestTask
//
//  Created by Аскар on 5/14/19.
//  Copyright © 2019 askar.ulubayev. All rights reserved.
//

enum NetworkError: AppError {
    case dataLoad
    case unknown
    case noConnection
    
    var localizedDescription: String {
        switch self {
        case .dataLoad:
            return "Возникла ошибка при загрузке данных. Приносим свои извинения за доставленные неудобства."
        case .unknown:
            return "Возникла непредвиденная ошибка. Приносим свои извинения за доставленные неудобства."
        case .noConnection:
            return "Отсутствует интернет соединение"
        }
    }
    
    var description: String {
        switch self {
        case .dataLoad:
            return "Возникла ошибка при загрузке данных. Приносим свои извинения за доставленные неудобства."
        case .unknown:
            return "Возникла непредвиденная ошибка. Приносим свои извинения за доставленные неудобства."
        case .noConnection:
            return "Отсутствует интернет соединение"
        }
    }
}
