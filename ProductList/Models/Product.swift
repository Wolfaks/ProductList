
import UIKit

struct Product {

    let id: Int
    let category: String
    let title: String
    let shortDescription: String
    let imageUrl: String
    let amount: Int
    let price: Double
    let producer: String
    
    var selectedAmount = 0
    var categories: [Category]
    
    init?(product: [String: AnyObject]) {
        
        guard let id = product["id"] as? Int,
              let title = product["title"] as? String,
              let shortDescription = product["short_description"] as? String,
              let imageUrl = product["image_url"] as? String,
              let amount = product["amount"] as? Int,
              let price = product["price"] as? Double,
              let producer = product["producer"] as? String else { return nil }
        
        let category = product["category"] as? String
        let categories = product["categories"] as? [Category]
        
        self.id = id
        self.title = title
        self.shortDescription = shortDescription
        self.imageUrl = imageUrl
        self.amount = amount
        self.price = price
        self.producer = producer
        self.category = category ?? "Нет категории"
        self.categories = categories ?? [Category]()
        
    }
    
}
