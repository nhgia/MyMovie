//
//  CoreDataNotification.swift
//  MyMovie
//
//  Created by Gia Nguyen on 10/08/2022.
//

import Foundation
@objc protocol CoreDataNotification {
    func registerNotification()
    @objc func localDataDidChange(_ notification: Notification)
    var notifyViewDataDidChange: ((_ atIndex: IndexPath?) -> Void)? { get set }
}

enum CoreDataNotificationKeys: String {
    case coreDataDidChange
}
