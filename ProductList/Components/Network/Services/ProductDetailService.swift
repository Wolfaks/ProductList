
import Foundation

class ProductDetailService {
    
    private init() {}
    
    static func getOneProduct(id: Int, complition: @escaping(ProductResponse) -> ()) {
        
        // Подготовка параметров для запроса, задаем выбранный id
        let link = Constants.Urls.product + "\(id)"
        
        // Получаем список
        Networking.shared.getData(link: link, params: [:]) { (result) in
            
            do {
                let response = try ProductResponse(product: result)
                complition(response)
            } catch {
                print(error)
            }
            
        }
        
    }
}
