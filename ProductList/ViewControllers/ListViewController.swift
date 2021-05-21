
import UIKit

class ListViewController: UIViewController {

    @IBOutlet weak var searchForm: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadIndicator: UIActivityIndicatorView!
    
    private var dataProvider: ListDataProvider!

    // Поиск
    var searchText = ""
    var searchTimer = Timer()

    // Страницы
    var page = 1
    var haveNextPage = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingUI()
    }
    
    private func settingUI() {
        
        // dataProvider
        dataProvider = ListDataProvider()
        dataProvider.delegate = self
        
        // searchForm
        searchForm.delegate = self
        searchForm.addTarget(self, action: #selector(changeSearchText), for: .editingChanged) // добавляем отслеживание изменения текста
        
        // TableView
        tableView.delegate = dataProvider
        tableView.dataSource = dataProvider
        tableView.rowHeight = 160.0
        
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
    
    func hideKeyboard() {
        view.endEditing(true);
    }
    
    @objc func delayedSearch() {

        // Выполняем поиск

        // Задаем первую страницу
        page = 1

        // Запрос данных
        loadProducts()

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

        // Отменяем предыдущий таймер поиска
        searchTimer.invalidate()

        // Таймер задержки поиска (по ТЗ)
        searchTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(delayedSearch), userInfo: nil, repeats: false)
        
    }
    
    func removeOldProducts() {
        
        // Очищаем старые данные и обновляем таблицу
        dataProvider.productList.removeAll()
        tableView.reloadData()
        
        // Отображаем анимацию загрузки
        loadIndicator.startAnimating()
        
    }
    
    func loadProducts() {
        
        // Отправляем запрос загрузки товаров
        ProductNetworking.getProducts(page: page, searchText: searchText) { (response) in
            
            // Скрываем анимацию загрузки
            if self.page == 1 {
                self.loadIndicator.stopAnimating()
            }

            // Обрабатываем полученные товары
            var products = response.products

            // Так как API не позвращает отдельный ключ, который говорит о том, что есть следующая страница, определяем это вручную
            if !products.isEmpty && products.count == ProductNetworking.maxProductsOnPage {

                // Задаем наличие следующей страницы
                self.haveNextPage = true

                // Удаляем последний элемент, который используется только для проверки на наличие следующей страницы
                products.remove(at: products.count - 1)

            }

            // Устанавливаем загруженные товары и обновляем таблицу
            // append contentsOf так как у нас метод грузит как первую страницу, так и последующие
            self.dataProvider.productList.append(contentsOf: products)
            self.tableView.reloadData()
            
        }
        
    }

}

extension ListViewController: ListDataProviderProtocol {
   
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
    
    func updateTableView() {
        // Обновляем tableView по запросу из ListDataProvider
        tableView.reloadData()
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
