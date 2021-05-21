
import Foundation

struct ProductResponse {
    
    var products = [Product]()
    var product: Product?

    init(productsJson: Any) {
        
        // Обрабатываем полученные данные списка
        guard let arrayJson = productsJson as? [String: AnyObject], let productsArray = arrayJson["data"] as? [[String: AnyObject]] else { return }
        
        // Перебор всех элементов и запись в модель
        var products = [Product]()
        
        for productDict in productsArray {

            var product = productDict

            // Получаем первую категорию (по ТЗ)
            do {

                let categoriesResponse = try CategoryResponse(json: product["categories"])
                if !categoriesResponse.categories.isEmpty {

                    if let firstCategory = categoriesResponse.categories.first {
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
    
    init(oneProductJson: Any) {
        
        // Обрабатываем полученные данные детальной информации
        guard let arrayJson = oneProductJson as? [String: AnyObject], let productDisc = arrayJson["data"] as? [String: AnyObject], let product = Product(product: productDisc) else { return }
        
        // Задаем данные товара
        self.product = product
        
        // Получаем категории
        if let categoryArr = productDisc["categories"] as? [[String: AnyObject]], !categoryArr.isEmpty {
            
            var categories = [Category]()
            for categoryDisc in categoryArr {
                guard let category = Category(category: categoryDisc) else {
                    continue
                }
                categories.append(category)
            }
            
            self.product?.categories = categories
            
        }
        // END Получаем категории
        
    }
    
}
