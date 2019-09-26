
import Foundation

/*
struct Course: Codable {
    
    let id: Int?
    let name: String?
    let link: String?
    let imageUrl: String?
    let numberOfLessons: Int?
    let numberOfTests: Int?
    
} */

struct Course: Codable {
    
    let id: Int?
    let name: String?
    let link: String?
    let imageUrl: String?
    let numberOfLessons: Int?
    let numberOfTests: Int?
    
    init?(json: [String: Any]) {
    
        let id = json["id"] as? Int
        let name = json["name"] as? String
        let link = json["link"] as? String
        let imageUrl = json["imageUrl"] as? String
        let numberOfLessons = json["number_of_lesson"] as? Int
        let numberOfTests = json["number_of_test"] as? Int
        
        self.id = id
        self.name = name
        self.link = link
        self.imageUrl = imageUrl
        self.numberOfLessons = numberOfLessons
        self.numberOfTests = numberOfTests
        
    }
    
    static func getArray(from jsonArray: Any) -> [Course]? {
        
        guard let jsonArray = jsonArray as? Array<[String: Any]> else {return nil}
        
        var courses:[Course] = []
        
        for jsonObject in jsonArray {
            
            if let course = Course(json: jsonObject) {
                courses.append(course)
        }
    }
    return courses
 }

}

