//
//  File.swift
//  
//
//  Created by Roman Tuzhilkin on 5/19/20.
//

import Vapor
import Nats
import NatsUtilities

extension Application {
    var router: RouterController {
        if let existing = self.storage[RouterControllerKey.self] {
            return existing
        } else {
            let new = RouterController(self)
            self.storage[RouterControllerKey.self] = new
            return new
        }
    }
    
    struct RouterControllerKey: StorageKey {
        typealias Value = RouterController
    }
    
    class RouterController {
        let app: Application

        init(_ app: Application) {
            self.app = app
        }
        
        func onOpen(conn: NatsConnection) {
            print("OPEN")
            
            
            
        }
        
        func onStreamingOpen(conn: NatsConnection) {
            
        }
        func onClose(conn: NatsConnection) {
            print("CLOSED")
        }
        func onError(conn: NatsConnection, error: Error) {
            print("ERROR")
            debugPrint(error)

        }
        
    }
}
