//
//  ConfigKey.swift
//  MyMovie
//
//  Created by Gia Nguyen on 03/08/2022.
//

import Foundation
struct ConfigKey {
    fileprivate static func infoForKey(_ key: String) -> String? {
        return (Bundle.main.infoDictionary?[key] as? String)?.replacingOccurrences(of: "\\", with: "")
    }
    
    static func getBackendBaseUrl() -> String? {
        return infoForKey("Backend Base URL")
    }
}
