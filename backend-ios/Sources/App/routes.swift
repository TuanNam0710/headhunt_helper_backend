import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return req.view.render("index", ["title": "Hello Vapor!"])
    }

    app.get("hello") { req -> String in
        return "Hello, world!"
    }
    
    app.get("all") { req async throws in
        try await CV.query(on: req.db).all()
    }

    try app.register(collection: CVController())
}
