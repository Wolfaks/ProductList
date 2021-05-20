
import UIKit

protocol ListDataProviderProtocol: AnyObject {
    func nextPage()
    func updateTableView()
}

class ListDataProvider: NSObject {

    var productList = [Product]()
    weak var delegate: ListDataProviderProtocol?

}

extension ListDataProvider: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        productList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath) as! ProductListTableCell
        cell.productIndex = indexPath.row
        cell.set(product: productList[indexPath.row])
        cell.delegate = self
        return cell
        
    }
    
}

extension ListDataProvider: UITableViewDelegate {

    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Проверяем что оторазили последний элемент и если есть, отображаем следующую страницу
        if !productList.isEmpty && indexPath.row == (productList.count - 1) {
            delegate?.nextPage()
        }
    }

}

extension ListDataProvider: ProductListCellDelegate {
    
    func changeCartCount(index: Int, value: Int) {
        // Изменяем кол-во товара в корзине
        if !productList.indices.contains(index) {
            return
        }
        
        // Записываем новое значение
        productList[index].selectedAmount = value
        
        // Обновляем tableView
        delegate?.updateTableView()
        
    }
    
}
