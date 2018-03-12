
import UIKit

class JsonParsingViewController: BaseViewController {
    
    //MARK:- Variables
    var jsonParsingViewModel: JsonParsingViewModel?
    
    //MARK:- Outlets
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var idLabel: UILabel?
    @IBOutlet weak var userIdLabel: UILabel?
    @IBOutlet weak var completedLabel: UILabel?
    
    //MARK:- Controller life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        processingOnDidLoad()
        todoApiRequest()
    }
    
    //MARK:- Api Request
    func todoApiRequest() {
        jsonParsingViewModel?.gernalGetApiRequest(queryType: "todos", queryParams: nil, completion: { (requestStatus, message) in
            self.updateViews(requestStatus: requestStatus)
        })
    }
    
    //MARK:- Utility methods
    func processingOnDidLoad() {
        jsonParsingViewModel = JsonParsingViewModel()
    }
    
    func updateViews(requestStatus: Bool) {
        if requestStatus {
            //update views as per user action
            let parsedObjectsList = jsonParsingViewModel!.todoObjectList
            
            guard parsedObjectsList != nil else {
                return
            }
            
            let titleString = parsedObjectsList![0].title
            let userIdInteger = parsedObjectsList![0].userId
            let idInteger = parsedObjectsList![0].id
            let processCompleted = parsedObjectsList![0].completed
            
            titleLabel?.text = titleString
            userIdLabel?.text = String(userIdInteger)
            idLabel?.text = String(idInteger)
            completedLabel?.text = String(processCompleted)
            
        }
    }
}
