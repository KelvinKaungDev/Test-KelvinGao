import Foundation

struct DecodeModel : Codable {
    var message : String
    var responseObject : Responses
}

struct Responses : Codable {
    var contentShelfs : [Contents]
}

struct Contents : Codable {
    var items : [Items]
    var subTitle : String
}

struct Items : Codable {
    var coverUrl : String
}
