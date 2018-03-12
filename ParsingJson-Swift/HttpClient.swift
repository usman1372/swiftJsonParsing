
import UIKit

class HttpClient: NSObject {
    
    //MARK:- Api Request actions
    private func dataTask(request: NSMutableURLRequest, method: String, completion: @escaping (_ success: Bool, _ object: AnyObject?) -> ()) {
        request.httpMethod = method
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            if let data = data {
                
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                
                if let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode {
                    //completion(true, json as AnyObject)
                    completion(true, data as AnyObject)
                } else {
                    completion(false, json as AnyObject)
                }
            }
            }.resume()
    }
    
    
    //MARK:- Api request by verb
    public func post(request: NSMutableURLRequest, completion: @escaping (_ success: Bool, _ object: AnyObject?) -> ()) {
        dataTask(request: request, method: "POST", completion: completion)
    }
    
    public func put(request: NSMutableURLRequest, completion: @escaping (_ success: Bool, _ object: AnyObject?) -> ()) {
        dataTask(request: request, method: "PUT", completion: completion)
    }
    
    public func get(request: NSMutableURLRequest, completion: @escaping (_ success: Bool, _ object: AnyObject?) -> ()) {
        dataTask(request: request, method: "GET", completion: completion)
    }
    
    //MARK:- Request params
    public func clientURLRequest(path: String, params: Dictionary<String, AnyObject>? = nil) -> NSMutableURLRequest {
        
        //build url
        let request = NSMutableURLRequest(url: NSURL(string: "https://jsonplaceholder.typicode.com/"+path)! as URL)
        
        //make params
        if let params = params {
            var paramString = ""
            
            for (key, value) in params {
                
                let escapedKey =
                    key.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
                let escapedValue = value.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
                
                paramString += "\(String(describing: escapedKey))=\(String(describing: escapedValue))&"
            }
            
            //type
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.httpBody = paramString.data(using: String.Encoding.utf8)
        }
        
        //FIXME: Use if token required in request open it
        /*
         //token if required
         if let token = token {
         request.addValue("Bearer "+token, forHTTPHeaderField: "Authorization")
         }
         */
        
        return request
    }
}
