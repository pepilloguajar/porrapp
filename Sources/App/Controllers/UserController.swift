import Vapor

final class UserController {
    
    // GET
    func list(_ req: Request) throws -> Future<[User]> {
        return User.query(on: req).all()
    }
  
    // POST
    func create(_ req: Request) throws -> Future<User> {
        return try req.content.decode(User.self).flatMap { user in
            return user.save(on: req)
        }
    }
  
    // PATCH
    func update(_ req: Request) throws -> Future<User> {
        return try req.parameters.next(User.self).flatMap { user in
            return try req.content.decode(User.self).flatMap { newUser in
                user.username = newUser.username
                return user.save(on: req)
            }
        }
    }
  
    // DELETE
    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(User.self).flatMap { user in
            return user.delete(on: req)
        }.transform(to: .ok)
    }
}
