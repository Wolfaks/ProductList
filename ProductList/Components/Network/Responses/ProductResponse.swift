
import Foundation

struct ProductResponse {
    
    var products = [ProductData]()
    var product: Product?

    init(products: String) {
        
        // Обрабатываем полученные данные списка
        guard !products.isEmpty else { return }
        
        let jsonData = Data(products.utf8)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        do {
            let product = try decoder.decode(Products.self, from: jsonData)
            if let productList = product.data {
                self.products = productList
            }
        } catch {
            //print(error.localizedDescription)
        }
        
    }
    
    init(product: String) {
        
        // Обрабатываем полученные данные детальной информации
        guard !product.isEmpty else { return }
        
        let jsonData = Data(product.utf8)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        do {
            self.product = try decoder.decode(Product.self, from: jsonData)
        } catch {
            //print(error.localizedDescription)
        }
        
    }
    
}
