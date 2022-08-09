//
//  NetworkRequest.swift
//  MyMovie
//
//  Created by Gia Nguyen on 03/08/2022.
//

import Foundation
import Alamofire
protocol NetworkRequestProtocol {
    func request<T: Decodable>(
        _ t: T.Type,
        endpoint: NetworkEndpoint,
        handlerResponse: ((Result<T, Error>) -> Void)?
    )
}
class NetworkRequest: NetworkRequestProtocol {
    let sessionManager: Session = {
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = 10
        
        return Session(configuration: configuration)
    }()
    
    func request<T: Decodable>(
        _ t: T.Type,
        endpoint: NetworkEndpoint,
        handlerResponse: ((Result<T, Error>) -> Void)?
    ) {
        guard let _url = endpoint.url else {
            print("URL is incorrect")
            return
        }
        
        sessionManager.request(_url, method: endpoint.method, parameters: endpoint.queryParameters, headers: endpoint.headerParamaters).responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let _data):
                handlerResponse?(.success(_data))
            case .failure(let err):
                handlerResponse?(.failure(err))
            }
        }
    }
}
