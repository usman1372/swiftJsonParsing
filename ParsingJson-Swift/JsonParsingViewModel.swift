
import UIKit

class JsonParsingViewModel: NSObject {
    
    //MARK:- Variable declerations
    let httpClient:HttpClient?
    var todoObjectList: [JsonParsingModel]?
    
    override init() {
        httpClient = HttpClient()
    }
    
    //MARK:- Api Request
    func gernalGetApiRequest(queryType: String, queryParams: Dictionary<String, AnyObject>?, completion: @escaping (_ success: Bool, _ message: String?) -> ()) {
        
        let mutableRequest: NSMutableURLRequest = httpClient!.clientURLRequest(path: getQueryPostParams(apiRequestType: queryType), params: queryParams)
        
        httpClient!.get(request: mutableRequest) { (success, object) in
            DispatchQueue.main.async(execute: {
                
                if success {
                    self.parseAndAssignValues(queryType: "todos", responseObjectData: object!)
                    completion(true, nil)
                } else {
                    var message = "an error occured"
                    if let object = object, let passedMessage = object["message"] as? String {
                        message = passedMessage
                    }
                    completion(false, message)
                }
            })
        }
    }
    
    func getQueryPostParams(apiRequestType: String) -> String {
        
        var postQueryParams = ""
        switch apiRequestType {
        case "todos":
            postQueryParams = "todos"
        default:
            postQueryParams = ""
        }
        
        return postQueryParams
    }
    
    func parseAndAssignValues(queryType: String, responseObjectData: AnyObject) {
        
        if queryType == "todos" {
            
            do{
                let modalObjectsList = try JSONDecoder().decode([JsonParsingModel].self, from: responseObjectData as! Data)
                
                    self.todoObjectList = modalObjectsList
        
            }catch{
                fatalError("todos contract mismatch")
            }
        }
    }
}
