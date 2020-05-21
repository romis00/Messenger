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
            
            var cnt: Int = 0
            var temp: String = "-------------------------CHECK-------------------------"
            
            print("OPEN")
            print(Thread.current.name as Any)
            
            /*conn.subscribe("Dima", queueGroup: "Home") { msg in
                msg.reply(payload: Data())
            }.flatMapThrowing{ _ in
                self.app.nats.request("Dima", payload: Data(), timeout: 60).flatMapThrowing { msg in
                    cnt += 1
                    print(temp)
                    print(Data())
                }
                self.app.nats.publish(temp, payload: Data()).flatMapThrowing { msg in
                    cnt += 1
                    print(temp)
                    print(Data())
                }
                self.app.nats.request("Dima", payload: Data(), timeout: 60).flatMapThrowing { msg in
                    cnt += 1
                    print(temp)
                    print(Data())
                }
                
            }*/
            conn.subscribe("Roman",  queueGroup: "Home") { msg in
                msg.reply(payload: Data())
            }
            self.app.nats.publish(temp, payload: Data())
            conn.subscribe("Roman",  queueGroup: "Home") { msg in
                msg.reply(payload: Data())
            }
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
