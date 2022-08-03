////
////  NetworkRequest.swift
////  MyMovie
////
////  Created by Gia Nguyen on 03/08/2022.
////
//
//import Foundation
//import Alamofire
//
//final class NetworkRequest<GenericType: Decodable> {
//    let sessionManager: Session = {
//        let configuration = URLSessionConfiguration.af.default
//        configuration.timeoutIntervalForRequest = 10
//        
//        return Session(configuration: configuration)
//    }()
//    
//    func request(endpoint: NetworkEndpoint, handlerResponse: ((_ responseObject: GenericType?,_ resultCodeObject: NetworkResponse?) -> Void)?) {
//        guard let _url = endpoint.url else {
//            print("URL is incorrect")
//            return
//        }
//        
//        sessionManager.request(_url, method: endpoint.method, parameters: endpoint.queryParameters, headers: endpoint.headerParamaters).responseData { response in
//            switch response.result {
//            case .success(let _data):
//                let decoder = JSONDecoder()
//                let resultCode = try? decoder.decode(NetworkResponse.self, from: _data)
//                let dataDecode = try? decoder.decode(GenericType.self, from: _data)
//                handlerResponse?(dataDecode, resultCode)
//            case .failure(let err):
//                handlerResponse?(nil, NetworkResponse(code: String(err.responseCode ?? -1), message: err.localizedDescription))
//            }
//        }
//    }
//}
