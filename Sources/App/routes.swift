import Fluent
import Vapor
import NatsUtilities
import Nats
import NatsKit

func routes(_ app: Application) throws {
    
    app.get { req in
        return "It works!"
    }

    app.get("hello") { req -> String in
        return "Hello, world!"
    }
    
    app.get("send", ":futureFOO", ":futureBAR") { req -> Int in
        
        guard let futureFoo = req.parameters.get("futureFOO", as: String.self) else {
            throw Abort(.badRequest)
        }
        guard let futureBar = req.parameters.get("futureBAR", as: Int.self) else {
            throw Abort(.badRequest)
        }

        someHelloRequest.foo = futureFoo
        someHelloRequest.bar = futureBar

        func test_2(msg: NatsMessage) throws -> EventLoopFuture<Void> {
            
            let request = try msg.decode(type: HelloRequest.self)
            print(request.foo)
                
            let reply = HelloReply(baz: request.bar + 10)
            someHelloReply.baz = reply.baz
            
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

        app.nats.subscribe("mysubject.test", queueGroup: "some_2_group") { msg in
            do {
                try test_2(msg: msg).whenComplete({ result in
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
        print("[NATS] [\(Date())] Subscribed to: mysubject.test")}
        app.nats.request("mysubject.test", payload: pubData, timeout: 60)

        let fin = someHelloReply.baz
        print(fin)
        
        return fin
    }

    
    let todoController = TodoController()
    app.get("todos", use: todoController.index)
    app.post("todos", use: todoController.create)
    app.delete("todos", ":todoID", use: todoController.delete)
    
    
}
