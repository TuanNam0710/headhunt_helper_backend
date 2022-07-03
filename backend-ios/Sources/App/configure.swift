import Fluent
import FluentMySQLDriver
import Leaf
import Vapor

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    var tls = TLSConfiguration.makeClientConfiguration()
    tls.certificateVerification = .none

    app.databases.use(.mysql(
        hostname: "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? MySQLConfiguration.ianaPortNumber,
        username: "root",
        password: "",
        database: "Candidate_CV",
        tlsConfiguration: tls
    ), as: .mysql)

    app.migrations.add(CreateCV())

    app.views.use(.leaf)

    

    // register routes
    try routes(app)
}
