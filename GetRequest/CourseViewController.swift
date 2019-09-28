
import UIKit

class CourseViewController: UIViewController {
    
    private var courses = [Course]()
    private var courseName: String?
    private var courseUrl: String?
    
    private let putRequestUrl = "https://jsonplaceholder.typicode.com/posts/1"
    private let postRequestUrl = "https://jsonplaceholder.typicode.com/posts"
    private let url = "https://swiftbook.ru/wp-content/uploads/api/api_courses"
    
    @IBOutlet weak var tableView: UITableView!
    
    func fetchData() {
        
        NetWorkManager.fecthData(url: url) { (courses) in
            self.courses = courses
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func fetchDataWithAlamofire() {
        
        AlamoFireNetworkRequest.sendRequest(url: url) { (courses) in
            self.courses = courses
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
    }
    
    private func configureCell(cell: CustomTableViewCell, for indexPath: IndexPath) {
        
        let course = courses[indexPath.row]
        cell.courseName.text = course.name
        
        if let numberOfLessons = course.numberOfLessons {
            cell.numberOfLessons.text = "Number of lessons: \(numberOfLessons)"
        }
        
        if let numberOfTests = course.numberOfTests {
            cell.numbersOfTest.text = "Number of tests: \(numberOfTests)"
        }
        DispatchQueue.global().async {
            guard let imageURL = URL(string: course.imageUrl!) else {return}
            guard let imageData = try? Data(contentsOf: imageURL) else {return}
            
            DispatchQueue.main.async {
                cell.courseImage.image = UIImage(data: imageData)
            }
        }
      
      
        
        
    }
    
}

extension CourseViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! CustomTableViewCell
        
        configureCell(cell: cell, for: indexPath)
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let webViewController = segue.destination as! WebViewController
        webViewController.selectedCourse = courseName
        
        if let url = courseUrl {
            webViewController.courseUrl = url
        }
    }
    
    func postRequest() {
        
        AlamoFireNetworkRequest.postRequest(url: postRequestUrl) { (courses) in
            self.courses = courses
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func putRequest() {
    
        AlamoFireNetworkRequest.putRequest(url: putRequestUrl) { (courses) in
            self.courses = courses
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
    }
}

extension CourseViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let course = courses[indexPath.row]
        courseUrl = course.link
        courseName = course.name
        
        performSegue(withIdentifier: "Description", sender: self)
    }
}
