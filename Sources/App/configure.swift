import Fluent
import FluentPostgresDriver
import Vapor
import Nats
import NatsUtilities
import Foundation


// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    app.nats.configuration = .init(host: "roman", disBehavior: .fatalCrash, clusterName: nil, streaming: false, auth_token: "10.7.7.137", onOpen: app.router.onOpen, onStreamingOpen: app.router.onStreamingOpen, onClose: app.router.onClose, onError: app.router.onError)
    
    app.completion = CompletionHandlers(app, constantsName: "Messenger", constantsID: UUID())
    
    
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
