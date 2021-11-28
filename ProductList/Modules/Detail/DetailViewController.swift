
import UIKit

protocol DetailProductDelegate: class {
    func changeCartCount(index: Int, value: Int, reload: Bool)
}

class DetailViewController: UIViewController {
    
    var productIndex: Int?
    var productID: Int?
    var productTitle: String?
    var productSelectedAmount = 0
    
    var categoryList = [Category]()
    
    @IBOutlet weak var loadIndicator: UIActivityIndicatorView!
    @IBOutlet weak var infoStackView: UIStackView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var producerLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var cartBtnDetailView: CartBtnDetail!
    @IBOutlet weak var cartCountView: CartCount!

    weak var delegate: DetailProductDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingUI()
    }
    
    private func settingUI() {
        
        // Задаем заголовок страницы
        if let productTitle = productTitle {
            title = productTitle
        }
        
        // TableView
        tableView.delegate = self
        tableView.dataSource = self
        
        // Запрос данных
        loadProduct()
        
    }
    
    private func setCartButtons() {
        
        // Вывод корзины и кол-ва добавленых в корзину
        if productSelectedAmount > 0 {
            
            // Выводим переключатель кол-ва продукта в корзине
            cartBtnDetailView.isHidden = true
            cartCountView.isHidden = false
            
            // Задаем текущее значение счетчика
            cartCountView.count = productSelectedAmount
            
            // Подписываемся на делегат
            cartCountView.delegate = self
            
        } else {
            // Выводим кнопку добавления в карзину
            cartBtnDetailView.isHidden = false
            cartBtnDetailView.delegate = self
            cartCountView.isHidden = true
        }
        
    }
    
    private func changeDescription(text: String) {
        
        // Задаем описание
        if text.isEmpty {
            descriptionLabel.isHidden = true
            descriptionLabel.text = ""
        } else {
            descriptionLabel.isHidden = false
            descriptionLabel.text = text
        }
        
    }
    
    private func loadProduct() {
        
        // Отправляем запрос загрузки товара
        guard let productID = productID else { return }
        ProductDetailService.getOneProduct(id: productID) { [weak self] (response) in
  
            // Проверяем что данные были успешно обработаны
            if let product = response.product {
            
                // Скрываем анимацию загрузки
                self?.loadIndicator.stopAnimating()
                
                // Задаем обновленный заголовок страницы
                self?.title = product.title

                // Выводим информацию
                self?.titleLabel.text = product.title
                self?.producerLabel.text = product.producer
                
                // Описание
                self?.changeDescription(text: product.shortDescription)
                
                // Убираем лишние нули после запятой, если они есть и выводим цену
                self?.priceLabel.text = String(format: "%g", product.price) + " ₽"
                
                // Загрузка изображения, если ссылка пуста, то выводится изображение по умолчанию
                self?.image.image = UIImage(named: "nophoto")
                if !product.imageUrl.isEmpty {
                    
                    // Загрузка изображения
                    guard let imageURL = URL(string: product.imageUrl) else { return }
                    ImageNetworking.shared.getImage(link: imageURL) { (img) in
                        DispatchQueue.main.async {
                            self?.image.image = img
                        }
                    }
                    
                }
                
                // Вывод корзины и кол-ва добавленых в корзину
                self?.setCartButtons()
                
                // Устанавливаем загруженные категории и обновляем таблицу
                if let categories = product.categories {
                    self?.categoryList = categories
                    self?.tableView.reloadData()
                }
                
                // Отображаем данные
                self?.infoStackView.isHidden = false
                
            }
            
        }
        
    }
    
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categoryList.count
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! CategoryListTableCell
        cell.set(category: categoryList[indexPath.row])
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.layoutIfNeeded()
    }
    
}

extension DetailViewController: CartCountDelegate {
    func changeCount(value: Int) {
        
        // Изменяем значение количества в структуре
        guard let productIndex = productIndex else { return }
        
        // Обновляем кнопку в отображении
        productSelectedAmount = value
        setCartButtons()
        
        // Обновляем значение в делегированном классе
        delegate?.changeCartCount(index: productIndex, value: productSelectedAmount, reload: true)
        
    }
}

extension DetailViewController: CartBtnDetailDelegate {
    func addCart() {
        
        // Добавляем товар в карзину
        guard let productIndex = productIndex else { return }
        
        // Обновляем кнопку в отображении
        productSelectedAmount = 1
        setCartButtons()
        
        // Обновляем значение в делегированном классе
        delegate?.changeCartCount(index: productIndex, value: productSelectedAmount, reload: true)
        
    }
}
