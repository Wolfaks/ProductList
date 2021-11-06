
import Foundation

class ProductsService {

    // Задаем максимальное количество элементов на странице статической константой, чтобы обращаться из других класов
    static let maxProductsOnPage = 21
    
    private init() {}
    
    static func getProducts(page: Int, searchText: String, complition: @escaping(ProductResponse) -> ()) {
        
        // Подготовка параметров для запроса, задаем макс количество элементов = 21
        var params = ["maxItems": "\(maxProductsOnPage)"]

        // Страница
        var startFrom = 0
        if page > 0 {
            startFrom = ((page - 1) * (maxProductsOnPage - 1));
        }
        params["startFrom"] = "\(startFrom)"

        // Поиск
        if !searchText.isEmpty {
            params["filter[title]"] = searchText
        }
        
        // Получаем список
        Networking.shared.getData(link: Constants.Urls.productsList, params: params) { (result) in
            
            do {
                let response = try ProductResponse(products: result)
                complition(response)
            } catch {
                print(error)
            }
            
        }
        
    }
}
