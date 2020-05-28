//
//  File.swift
//  
//
//  Created by Roman Tuzhilkin on 5/19/20.
//

import Vapor
import Nats
import NatsUtilities
import Foundation
import NIO

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
            
            //let req = try msg.decode(type: Struct.self)
            /*
            var cnt: Int = 0
            
            var temp: String = "Home publish #1"
            var pubData = temp.data(using: .utf8) ?? Data()
            
            print("OPEN")
            print(Thread.current.name as Any)
            
            conn.subscribe("Dima", queueGroup: "Home") { msg in
                msg.reply(payload: Data())
                
            }.flatMapThrowing{ _ in
                self.app.nats.request("Home", payload: pubData, timeout: 60).flatMapThrowing { msg in
                    cnt += 1
                    print(temp)
                }
            }
            
            //Another subriber--------------------------------------------------------------------------------
            
            var temp_3: String = "Home publish #2"
            var pubData_3 = temp_3.data(using: .utf8) ?? Data()
            
            conn.subscribe("Kolya", queueGroup: "Home") { msg in
                msg.reply(payload: pubData_3)
                print(msg)
            }.flatMapThrowing{ _ in
                self.app.nats.request("Home", payload: pubData_3, timeout: 60).flatMapThrowing { msg in
                    cnt += 1
                    print(temp)
                }
            }
            
            //Try to publish
            
            var temp_5: String = "Home publish #final"
            var pubData_5 = temp_5.data(using: .utf8) ?? Data()
            
            conn.publish("Home", payload: pubData_5)
 */
           func test(msg: NatsMessage) throws -> EventLoopFuture<Void> {
                let request = try msg.decode(type: HelloRequest.self)
                print(request.foo)
                let reply = HelloReply(baz: request.bar + 10)
                return msg.reply(response: reply)
            }
            
            struct HelloRequest: Codable {
                let foo: String
                let bar: Int
            }
            
            struct HelloReply: Codable {
                let baz: Int
            }
            
            let helloRequest =
            """
            {
                "foo": "Hello World!",
                "bar": 5
            }
            """
            let pubData = Data(helloRequest.utf8)
            /*Another option to get JSON string:
             let helloRequest = HelloRequest(foo: ***, bar: ***)

             do {
                 let jsonEncoder = JSONEncoder()
                 let jsonData = try jsonEncoder.encode(helloRequest)
                 let pubData= String(data: jsonData, encoding: .utf8)
                 print(jsonString) // result : "{"email":"bob@sponge.com","id":13,"lastname":"Sponge","firstname":"Bob"}"
             } catch {
                 print("Unexpected error: \(error).")
             }*/
            
            
            conn.subscribe("mysubject.test", queueGroup: "test_group") { msg in
                do {
                    try test(msg: msg).whenComplete({ result in
                        switch result {
                        case .success(_):
                            print("Success")
                        case .failure(let error):
                            print(error)
                        }
                    })

                }
                catch {
                    print(error)
                }
            }.whenSuccess{_ in
            print("[NATS] [\(Date())] Subscribed to: mysubject.test")}
            conn.request("mysubject.test", payload: pubData, timeout: 60)
            
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
