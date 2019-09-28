
import Foundation
import Alamofire
import UIKit

class AlamoFireNetworkRequest {
    
    static var  onProgress: ((Double) -> ())?
    static var complited: ((String) -> ())?
    
    
    static func sendRequest(url: String, complition: @escaping (_ courses: [Course]) -> ()) {
        
        guard let url = URL (string: url) else { return }
        
        request(url, method: .get).validate().responseJSON { (response) in
           
            switch response.result {
                
            case .success(let value):
  
                var courses = [Course]()
                courses = Course.getArray(from: value)!
                complition(courses)
                
            case .failure(let error):
                print(error)
                
            }
            
        }
        
    }
    
    static func responseData(url: String) {
        
        request(url).responseData { (responseData) in
            switch responseData.result {
            case .success(let data):
                guard let string = String(data: data, encoding: .utf8) else {return}
                print(string)
            case .failure(let error):
                print(error)
                
            }
        }
    }
    
    static func responseString(url: String) {
        request(url).responseString { (responseString) in
            
            switch responseString.result{
            case .success(let string):
                print(string)
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    static func response(url: String) {
        
        request(url).response { (response) in
            
            guard let data = response.data, let string = String(bytes: data, encoding: .utf8)
                else {return}
            print(string)
            
        }
        
    }
    
    static func downloadImage(url: String, complition: @escaping (_ image: UIImage)->()) {
        
        guard let url = URL(string: url) else {return}
        
        request(url).responseData { (responseData) in
            switch responseData.result {
                
            case .success(let data):
                guard let image = UIImage(data: data) else {return}
                complition(image)
            case .failure(let error):
                print(error)
                
            }
            
        }
        
    }
    
    
    static func downloadImageProgress(url: String, complition: @escaping (_ image: UIImage)->()) {
        
        guard  let url = URL(string: url) else {return}
        request(url).validate().downloadProgress { (progress) in
            print("totalUinitCount:\n", progress.totalUnitCount)
            print("compitedUnitCount:\n", progress.completedUnitCount)
            print("fractionComplited:\n", progress.fractionCompleted)
            print("localizaedDescription:\n", progress.localizedDescription!)
            print("------------------------------------------------------------")
            
            self.onProgress?(progress.fractionCompleted)
            self.complited?(progress.localizedDescription)
            
            }.response{ (response) in
                

                
                guard let data = response.data, let image = UIImage(data: data) else {return}
                
                DispatchQueue.main.async {
                    complition(image)
                }
        }
        
    }
    
    static func  postRequest(url: String, complition: @escaping (_ courses: [Course]) -> ()) {
        
        guard let url = URL(string: url) else {return}
        
        let userData: [String: Any] = ["name": "Network Requests",
                                       "link": "https://swiftbook.ru/contents/our-first-applications/",
                                       "imageUrl": "https://swiftbook.ru/wp-content/uploads/sites/2/2018/08/notifications-course-with-background.png",
                                       "numberOfLessons": 18,
                                       "numberOfTests": 10 ]
        request(url, method: .post, parameters: userData).responseJSON { (responseJson) in
            
            guard let statusCOde = responseJson.response?.statusCode else { return }
            print("statusCode", statusCOde)
            
            switch responseJson.result {
                
            case .success(let value):
                print(value)
                
                guard let jsonObject  = value as? [String:Any],
                    let course = Course(json: jsonObject)
                    else {return}
                
                var courses = [Course]()
                courses.append(course)
                
                complition(courses)
                
            case .failure(let error):
                print(error)
            }
            
        }
    }
    
    static func  putRequest(url: String, complition: @escaping (_ courses: [Course]) -> ()) {
        
        guard let url = URL(string: url) else {return}
        
        let userData: [String: Any] = ["name": "Network with Alamofire",
                                       "link": "https://swiftbook.ru/contents/our-first-applications/",
                                       "imageUrl": "https://swiftbook.ru/wp-content/uploads/sites/2/2018/08/notifications-course-with-background.png",
                                       "numberOfLessons": "18",
                                       "numberOfTests": "10" ]
        request(url, method: .put, parameters: userData).responseJSON { (responseJson) in
            
            guard let statusCOde = responseJson.response?.statusCode else { return }
            print("statusCode", statusCOde)
            
            switch responseJson.result {
                
            case .success(let value):
                print(value)
                
                guard let jsonObject  = value as? [String:Any],
                    let course = Course(json: jsonObject)
                    else {return}
                
                var courses = [Course]()
                courses.append(course)
                
                complition(courses)
                
            case .failure(let error):
                print(error)
            }
            
        }
    }
    
    static func uploadImage(url: String) {
        
        guard let url = URL(string: url) else {return}
        
        let image = UIImage(named: "loco")!
        let data = image.pngData()!
        let httpHeaders = ["Authorization": "Client-ID aca5b5402d9e78a"]
        
        upload(multipartFormData: { (multiplatformData) in
            multiplatformData.append(data, withName: "image")
        }, to: url, headers: httpHeaders) { (encodingComplition) in
            
            switch encodingComplition {
                case .success(request: let uploadRequrst
                    , streamingFromDisk: let streamingDisk,
                      streamFileURL: let streamUrl):
                
                print(uploadRequrst)
                print(streamingDisk)
                print(streamUrl ?? "streaminigFileURL is Nil")
                
                uploadRequrst.validate().responseJSON(completionHandler: { (responseJson) in
                    
                    switch responseJson.result {
                        
                    case .success(let value):
                        print(value)
                    case .failure(let error):
                        print(error)
                        
                    }
                    
                })
                
            case .failure(let someError):
                print(someError)
                
            }
            
        }
        
        
        
    }
    
}
