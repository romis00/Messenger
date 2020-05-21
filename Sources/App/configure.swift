import Fluent
import FluentPostgresDriver
import Vapor
import Nats
import NatsUtilities
import Foundation
import NatsKit


// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
    app.nats.configuration = .init(host: "0.0.0.0", disBehavior: .fatalCrash, clusterName: nil, streaming: false, auth_token: "mytoken", onOpen: app.router.onOpen, onStreamingOpen: app.router.onStreamingOpen, onClose: app.router.onClose, onError: app.router.onError)
    
     app.completion = CompletionHandlers(app, constantsName: "Messenger", constantsID: UUID())
    
    
    /*var counter: Int = 0
    
    app.nats.configuration = NatsConfiguration(host: "0.0.0.0", disBehavior: .fatalCrash,  clusterName: nil, user: "grandCentral", pass: "a", onOpen: { conn in
    print("OPEN")
        print(Thread.current.name as Any)
        
    conn.subscribe("test2", queueGroup: "test23") { msg in
            msg.reply(payload: Data())
        }.flatMapThrowing { _  in
            app.nats.request("test2", payload: Data(), timeout: 60).flatMapThrowing { msg in
                counter += 1
                print(counter)
            }
            app.nats.request("test2", payload: Data(), timeout: 60).flatMapThrowing { msg in
                counter += 1
                print(counter)
            }
            app.nats.request("test2", payload: Data(), timeout: 60).flatMapThrowing { msg in
                counter += 1
                print(counter)
            }
            app.nats.request("test2", payload: Data(), timeout: 60).flatMapThrowing { msg in
                counter += 1
                print(counter)
            }
        }
    }, onStreamingOpen: { (conn) in
        print("STREAMING")
    }, onClose: { conn in
        print("ONCLOSE")
    }, onError: { (conn, error) in
        debugPrint(error)
        print("on ERROR")
    })
    */
    
    
    
    
    app.databases.use(.postgres(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        username: Environment.get("DATABASE_USERNAME") ?? "roman",
        password: Environment.get("DATABASE_PASSWORD") ?? "",
        database: Environment.get("DATABASE_NAME") ?? "data"
    ), as: .psql)

    app.migrations.add(CreateTodo())

    // register routes
    try routes(app)
}
