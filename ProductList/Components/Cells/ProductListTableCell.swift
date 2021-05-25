
import UIKit

class ProductListTableCell: UITableViewCell {
    
    @IBOutlet weak var borderView: UIView!
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productCategory: UILabel!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productProducer: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var stackFooterCell: UIStackView!
    
    @IBOutlet weak var cartButtListView: CartButtList!
    @IBOutlet weak var cartCountView: CartCount!
    
    var productIndex: Int?

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setBorder() {
        
        // Устанавливаем обводку
        borderView.layer.cornerRadius = 10.0
        borderView.layer.borderWidth = 1.0
        borderView.layer.borderColor = UIColor.lightGray.cgColor
        
    }
    
    func setCartButtons(product: Product) {
        
        // Вывод корзины и кол-ва добавленых в корзину
        if product.selectedAmount > 0 {
            
            // Выводим переключатель кол-ва продукта в корзине
            cartButtListView.isHidden = true
            cartCountView.isHidden = false
            
            // Задаем текущее значение счетчика
            cartCountView.count = product.selectedAmount
            
            // Подписываемся на делегат
            cartCountView.delegate = self
            
        } else {
            // Выводим кнопку добавления в карзину
            cartButtListView.isHidden = false
            cartButtListView.delegate = self
            cartCountView.isHidden = true
        }
        
    }
    
    @objc func detailTapped() {
        
        // Выполняем переход в детальную информацию
        guard let productIndex = productIndex else { return }

        // Уведомляем наблюдатель о переходе в детальную информацию
        NotificationCenter.default.post(name: Notification.Name(rawValue: "notificationRedirectToDetail"), object: nil, userInfo: ["index": productIndex])
        
    }
    
    func setClicable() {
        
        // Клик на изображение для перехода в детальную информацию
        let tapImageGesture = UITapGestureRecognizer(target: self, action: #selector(detailTapped))
        productImage.isUserInteractionEnabled = true
        productImage.addGestureRecognizer(tapImageGesture)
        
        // Клик на название для перехода в детальную информацию
        let tapTitleGesture = UITapGestureRecognizer(target: self, action: #selector(detailTapped))
        productTitle.isUserInteractionEnabled = true
        productTitle.addGestureRecognizer(tapTitleGesture)
        
    }
    
    func set(product: Product) {
        
        // Устанавливаем обводку
        setBorder()
        
        // Заполняем данные
        productCategory.text = product.category
        productTitle.text = product.title
        productProducer.text = product.producer
        
        // Убираем лишние нули после запятой, если они есть и выводим цену
        productPrice.text = String(format: "%g", product.price) + " ₽"

        // Загрузка изображения, если ссылка пуста, то выводится изображение по умолчанию
        productImage.image = UIImage(named: "nophoto")
        if !product.imageUrl.isEmpty {
            
            // Загрузка изображения
            guard let imageURL = URL(string: product.imageUrl) else { return }
            ImageNetworking.networking.getImage(link: imageURL) { (img) in
                DispatchQueue.main.async {
                    self.productImage.image = img
                }
            }
            
        }
        
        // Вывод корзины и кол-ва добавленых в корзину
        setCartButtons(product: product)
        
        // Действия при клике
        setClicable()
        
    }
    
}

extension ProductListTableCell: CartCountDelegate {
    
    func changeCount(value: Int) {
        // Изменяем значение количества в структуре
        guard let productIndex = productIndex else { return }

        // Обновляем значение в корзине в списке через наблюдатель
        NotificationCenter.default.post(name: Notification.Name(rawValue: "notificationUpdateCartCount"), object: nil, userInfo: ["index": productIndex, "count": value])

    }
    
}

extension ProductListTableCell: CartButtListDelegate {
    
    func addCart() {

        // Добавляем товар в карзину
        guard let productIndex = productIndex else { return }

        // Обновляем значение в корзине в списке через наблюдатель
        NotificationCenter.default.post(name: Notification.Name(rawValue: "notificationUpdateCartCount"), object: nil, userInfo: ["index": productIndex, "count": 1])

    }
    
}
