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
        
        func sendIt(conn: NatsConnection) throws {
            
            
        }
        
        func onOpen(conn: NatsConnection) {
        
           func test(msg: NatsMessage) throws -> EventLoopFuture<Void> {
            
                let request = try msg.decode(type: HelloRequest.self)
                print(request.foo)
            
                let reply = HelloReply(baz: request.bar + 100)
                someHelloReply.baz = reply.baz
            
                return msg.reply(response: reply)
            }
            
            //Encoding to JSON
            
            let helloRequest =
            """
            {
                "foo": "Hello World!",
                "bar": 5
            }
            """
            let pubData = Data(helloRequest.utf8)
            
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

/*app.get("send", ":futureFOO", ":futureBAR") { req -> Int in

guard let futureFoo = req.parameters.get("futureFOO", as: String.self) else {
    throw Abort(.badRequest)
}
guard let futureBar = req.parameters.get("futureBAR", as: Int.self) else {
    throw Abort(.badRequest)
}

someHelloRequest.foo = futureFoo
someHelloRequest.bar = futureBar

func test(msg: NatsMessage) throws -> EventLoopFuture<Void> {
let request = try msg.decode(type: HelloRequest.self)
    print(request.foo)
    let reply = HelloReply(baz: request.bar + 10)
    return msg.reply(response: reply)
}

//Encoding to JSON

let helloRequest =
"""
{
"foo": "\(someHelloRequest.foo)",
"bar": \(someHelloRequest.bar)
}
"""
let pubData = Data(helloRequest.utf8)

conn.subscribe("some.test", queueGroup: "some_group") { msg in
    do {
        try test(msg: msg).whenComplete({ result in
            switch result {
            case .success(_):
                print("Success #2")
            case .failure(let error):
                print(error)
            }
        })

    }
    catch {
        print(error)
    }
}.whenSuccess{_ in
print("[NATS] [\(Date())] Subscribed to: some.test")}
conn.request("some.test", payload: pubData, timeout: 60)

let fin = someHelloReply.baz
return fin*/
