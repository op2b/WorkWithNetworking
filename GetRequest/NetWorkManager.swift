
import UIKit

class NetWorkManager {
    
    
    static  func getRequest(url: String) {
        
        guard let url = URL(string: url) else { return }
        
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            
            guard response != nil else { return }
            guard let data = data else { return }
            
            do {
                
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
                
            } catch {
                print(error)
            }
        }.resume()
    }
    
    static func postRequest(url: String) {
        
        guard let url = URL(string: url) else { return }
        
        let userData = ["Course":"NetWorking", "Lesson": "Get post request"]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: userData, options: []) else
        { return }
        request.httpBody = httpBody
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            guard let response = response, let data = data else { return }
            print(response)
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
            } catch {
                print(error)
            }
        }.resume()
        
    }
    
    static func downloadImage(url: String, complition: @escaping (_ image: UIImage)->()) {
        
         guard let url = URL(string: url) else { return }
        
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                   complition(image)
                }
            }
        }.resume()
    }
    
    static func fecthData(url: String, complition: @escaping (_ courses: [Course]) -> ()) {
        
        guard let url = URL(string: url) else {return}
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data else {return}
            
            do{
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let courses = try  decoder.decode([Course].self, from: data)
                complition(courses)
                
            } catch let error {
                print(error)
            }
            
            }.resume()
    }
    
    static func uploadImage(url: String) {
        
        let image = UIImage(named: "catMoon")!
        let httpHeaders = ["Authorization": "Client-ID aca5b5402d9e78a"]
        guard  let imageProperties = ImageModel(withImage: image, forKey: "image") else { return }
        guard let url = URL(string: url) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = httpHeaders
        request.httpBody = imageProperties.data
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                } catch {
                    print(error)
                }
            }
        }.resume()
        
    }
    
}
