
import UIKit

class DataProvider: NSObject {
    
    private var downloadTask : URLSessionDownloadTask!
    var filelocation: ((URL)->())?
    var onProgress: ((Double) -> ())?
    
    private lazy var backgroundSession: URLSession = {
        let config = URLSessionConfiguration.background(withIdentifier: "home.GetRequest")
        config.isDiscretionary = true
        config.timeoutIntervalForRequest = 300
        config.waitsForConnectivity = true
        config.sessionSendsLaunchEvents = true
        return URLSession(configuration: config, delegate: self, delegateQueue: nil)
    }()
    
    func stratDownload() {
        
        if let url = URL(string: "https://speed.hetzner.de/100MB.bin") {
            downloadTask  = backgroundSession.downloadTask(with: url)
            downloadTask.earliestBeginDate = Date().addingTimeInterval(3)
            downloadTask.countOfBytesClientExpectsToSend = 512
            downloadTask.countOfBytesClientExpectsToReceive = 100 * 1024 * 1024
            downloadTask.resume()
        }
    }
    
    func stopDownload() {
        
        downloadTask.cancel()
    }

}

extension DataProvider: URLSessionDelegate {
    
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        DispatchQueue.main.async {
            guard
                let appDelegate = UIApplication.shared.delegate as? AppDelegate,
                let complitionHandler = appDelegate.bgSessionComplitionHandler
                else {return}
            
            appDelegate.bgSessionComplitionHandler = nil
            complitionHandler()
            
        }
    }
}

extension DataProvider: URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("Did finish downloading: \(location.absoluteString)")
        
        DispatchQueue.main.async {
            self.filelocation?(location)
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        guard totalBytesExpectedToWrite != NSURLSessionTransferSizeUnknown else {return}
        
        let progress = Double(Double(totalBytesWritten) / Double(totalBytesExpectedToWrite))
        print("Download task \(progress)")
        
        DispatchQueue.main.async {
            self.onProgress?(progress)
        }
    }
    
}
