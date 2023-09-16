import Foundation

struct TestData : Codable {
    var message : String
    var responseObject : Responses
}

struct Responses : Codable {
    var contentShelfs : [Contents]
}

struct Contents : Codable {
    var items : [Items]?
    var title : String
    var coverUrl : String?
}

struct Items : Codable {
    var coverUrl : String
}
