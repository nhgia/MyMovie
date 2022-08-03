////
////  NetworkResponse.swift
////  MyMovie
////
////  Created by Gia Nguyen on 03/08/2022.
////
//
//import Foundation
//struct NetworkResponse: Decodable {
//    var responseCode: String
//    var message: String
//    
//    enum CodingKeys: String, CodingKey {
//        case responseCode = "cod"
//        case message = "message"
//    }
//    
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: NetworkResponse.CodingKeys.self)
//        self.responseCode = (try? values.decode(String.self, forKey: .responseCode)) ?? "404"
//        self.message = (try? values.decode(String.self, forKey: .message)) ?? ""
//    }
//    
//    init(code: String, message: String) {
//        self.responseCode = code
//        self.message = message
//    }
//}
//
