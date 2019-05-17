//
//  NetworkContext.swift
//  TestTask
//
//  Created by Аскар on 5/14/19.
//  Copyright © 2019 askar.ulubayev. All rights reserved.
//

import Alamofire

protocol NetworkContext: class {
    var route: TmdbEndPoint { get }
    var method: NetworkMethod { get }
    var parameters: [String: String] { get set }
}

extension NetworkContext {
    
    var url: URL? {
        if method == .get {
            let routeUrlString = route.getRouteWithBaseURL()
            let urlString = routeUrlString + getParametersAsString()
            if let percentageEncodedUrl = urlString.addingPercentEncoding(
                withAllowedCharacters: NSCharacterSet.urlQueryAllowed
            ) {
                return URL(string: percentageEncodedUrl)
            }
            return nil
        }
        return route.url()
    }
    
    var parameters: [String: Any] { return [:] }
    
    func httpMethod() -> HTTPMethod {
        switch method {
        case .get:
            return HTTPMethod.get
        case .post:
            return HTTPMethod.post
        }
    }
    
    func getParameters() -> [String: String]? {
        switch method {
        case .get:
            return nil
        default:
            return parameters
        }
    }
    
    func setApiKey() {
        parameters["api_key"] = TmdbAPI.apiKey
    }
    
    func setLanguage() {
        parameters["language"] = TmdbAPI.language
    }
    
    private func getParametersAsString() -> String {
        var parametersString = "?"
        for (key, value) in parameters {
            parametersString += key + "=" + value + "&"
        }
        if parametersString.last == "&" { parametersString.removeLast() }
        return parametersString
    }
}

enum NetworkMethod { case get, post }
