
import Foundation

struct ProductResponse {
    
    var products = [Product]()

    init(json: Any) {
        
        // Обрабатываем полученные данные
        guard let arrayJson = json as? [String: AnyObject], let productsArray = arrayJson["data"] as? [[String: AnyObject]] else { return }
        
        // Перебор всех элементов и запись в модель
        var products = [Product]()
        
        for productDict in productsArray {

            var product = productDict

            // Получаем первую категорию (по ТЗ)
            product["category"] = "Нет категории" as AnyObject

            do {

                let categoriesResponse = try CategoryResponse(json: product["categories"])
                if let categories = categoriesResponse.categories as? [Category], !categories.isEmpty {

                    if let firstCategory = categories.first {
                        product["category"] = firstCategory.title as AnyObject
                    }

                }

            } catch {
                print(error)
            }
            // END Получаем первую категорию (по ТЗ)

            // Очищаем ключ от ненужного значения с массивом категорий
            product["categories"] = nil // не removeValue так как нам не нужно удаляемое значение
            // END Получаем первую категорию (по ТЗ)

            // Добавляем в массив
            guard let product = Product(product: product) else {
                continue
            }
            products.append(product)

        }
        
        self.products = products
        // END Перебор всех элементов и запись в модель
        
    }
    
}
