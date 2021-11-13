
import UIKit

class CategoryListTableCell: UITableViewCell {
    
    @IBOutlet weak var categoryTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func set(category: Category) {
        
        // Устанавливаем название
        categoryTitle.text = category.title
        
    }
    
}
