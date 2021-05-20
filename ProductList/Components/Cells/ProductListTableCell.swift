
import UIKit

protocol ProductListCellDelegate: class {
    func changeCartCount(index: Int, value: Int)
}

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
    weak var delegate: ProductListCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setBorder() {
        
        // Устанавливаем обводку
        borderView.layer.cornerRadius = 10.0
        borderView.layer.borderWidth = 1.0
        borderView.layer.borderColor = UIColor.lightGray.cgColor
        
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
    
}

extension ProductListTableCell: CartCountDelegate {
    
    func changeCount(value: Int) {
        // Изменяем значение количества в структуре
        guard let productIndex = productIndex else { return }
        delegate?.changeCartCount(index: productIndex, value: value)
    }
    
}

extension ProductListTableCell: CartButtListDelegate {
    
    func addCart() {
        // Добавляем товар в карзину
        guard let productIndex = productIndex else { return }
        delegate?.changeCartCount(index: productIndex, value: 1)
    }
    
}
