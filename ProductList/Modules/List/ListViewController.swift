
import UIKit

class ListViewController: UIViewController {

    @IBOutlet weak var searchForm: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadIndicator: UIActivityIndicatorView!
    
    var productList = [Product]()

    // Поиск
    var searchText = ""
    private let searchOperationQueue = OperationQueue()

    // Страницы
    var page = 1
    var haveNextPage = false
    
    // Переход в детальную информацию
    private var productIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingUI()
    }
    
    private func settingUI() {
        
        // searchForm
        searchForm.delegate = self
        searchForm.addTarget(self, action: #selector(changeSearchText), for: .editingChanged) // добавляем отслеживание изменения текста
        
        // TableView
        tableView.delegate = self
        tableView.dataSource = self
        
        // Запрос данных
        loadProducts()
        
    }
    
    @IBAction func removeSearch(_ sender: Any) {
        
        // Очищаем форму поиска
        searchForm.text = ""
        
        // Скрываем клавиатуру
        hideKeyboard()
        
        // Вызываем метод поиска
        changeSearchText(textField: searchForm)
        
    }
    
    private func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc func changeSearchText(textField: UITextField) {

        // Проверяем измененный в форме текст
        guard let newSearchText = textField.text else { return }
        
        // Выполняем поиск когда форма была изменена
        if newSearchText.hash == searchText.hash {
            return
        }

        // Получаем искомую строку
        searchText = newSearchText

        // Очищаем старые данные и обновляем таблицу
        removeOldProducts()

        // Поиск с задержкой (по ТЗ)
        let operationSearch = BlockOperation()
        operationSearch.addExecutionBlock { [weak operationSearch] in

            // Задержка (по ТЗ)
            sleep(2)

            if !(operationSearch?.isCancelled ?? false) {

                // Выполняем поиск
                // Задаем первую страницу
                self.page = 1

                // Запрос данных
                self.loadProducts()

            }

        }
        searchOperationQueue.cancelAllOperations()
        searchOperationQueue.addOperation(operationSearch)
        
    }
    
    private func removeOldProducts() {
        
        // Очищаем старые данные и обновляем таблицу
        productList.removeAll()
        tableView.reloadData()
        
        // Отображаем анимацию загрузки
        loadIndicator.startAnimating()
        
    }
    
    private func loadProducts() {
        
        // Отправляем запрос загрузки товаров
        ProductListService.getProducts(page: page, searchText: searchText) { [weak self] (response) in
            
            // Скрываем анимацию загрузки
            if self?.page == 1 {
                self?.loadIndicator.stopAnimating()
            }

            // Обрабатываем полученные товары
            var products = response.products

            // Так как API не позвращает отдельный ключ, который говорит о том, что есть следующая страница, определяем это вручную
            if !products.isEmpty && products.count == Constants.Settings.maxProductsOnPage {

                // Задаем наличие следующей страницы
                self?.haveNextPage = true

                // Удаляем последний элемент, который используется только для проверки на наличие следующей страницы
                products.remove(at: products.count - 1)

            }

            // Устанавливаем загруженные товары и обновляем таблицу
            // append contentsOf так как у нас метод грузит как первую страницу, так и последующие
            self?.productList.append(contentsOf: products)
            self?.tableView.reloadData()
            
        }
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "detail" {
            
            if let index = productIndex, !productList.isEmpty && productList.indices.contains(index) {
            
                // Переход в детальную информацию
                guard let detailController = segue.destination as? DetailViewController else { return }
                detailController.productIndex = index
                detailController.productID = productList[index].id
                detailController.productTitle = productList[index].title
                detailController.productSelectedAmount = productList[index].selectedAmount
                detailController.delegate = self

            }
            
        }
        
    }
    
    func nextPage() {
        // Загружаем следующую страницу, если она есть
        if haveNextPage {

            // Задаем новую страницу
            haveNextPage = false
            page += 1

            // Запрос данных
            loadProducts()

        }
    }
     
     func showDetail(index: Int) {
         // Выполняем переход в детальную информацию
         productIndex = index
         performSegue(withIdentifier: "detail", sender: self)
     }
    
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        productList.count
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath) as! ProductListTableCell
        cell.productIndex = indexPath.row
        cell.set(product: productList[indexPath.row])
        cell.delegate = self
        return cell
        
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.layoutIfNeeded()
        
        // Проверяем что оторазили последний элемент и если есть, отображаем следующую страницу
        if !productList.isEmpty && indexPath.row == (productList.count - 1) {
            nextPage()
        }
    }

}

extension ListViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == searchForm {
            // Скрываем клавиатуру при нажатии на клавишу Done / Готово
            hideKeyboard()
        }
        
        return true
        
    }
}

extension ListViewController: ProductListCellDelegate, DetailProductDelegate {
    
    func changeCartCount(index: Int, value: Int, reload: Bool) {
        
        // Изменяем кол-во товара в корзине
        if !productList.isEmpty && productList.indices.contains(index) {
            
            // Записываем новое значение
            productList[index].selectedAmount = value
            
            // Обновляем tableView
            if reload {
                tableView.reloadData()
            }
            
        }
        
    }
    
    func redirectToDetail(index: Int) {
        
        // Выполняем переход в детальную информацию
        if !productList.indices.contains(index) {
            return
        }
        showDetail(index: index)
        
    }
    
}
