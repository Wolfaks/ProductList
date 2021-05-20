
import Foundation

struct CategoryResponse {
    
    var categories = [Category]()

    init(json: Any) {
        
        // Обрабатываем полученные данные
        guard let categoriesArray = json as? [[String: AnyObject]] else { return }
        
        // Перебор всех элементов и запись в модель
        var categories = [Category]()
        for categoryDict in categoriesArray {

            // Добавляем в массив
            guard let category = Category(category: categoryDict) else { continue }
            categories.append(category)
            
        }
        
        self.categories = categories
        // END Перебор всех элементов и запись в модель
        
    }
    
}
