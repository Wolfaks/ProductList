
import UIKit

struct Category: Decodable {

    let id: Int
    let title: String
    let parentID: Int
    
    init?(category: [String: AnyObject]) {
        
        guard let id = category["id"] as? Int,
              let title = category["title"] as? String,
              let parentID = category["parent_id"] as? Int else { return nil }
        
        self.id = id
        self.title = title
        self.parentID = parentID
        
    }
    
}
