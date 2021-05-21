
import UIKit

protocol ProductListCellDelegate: class {
    func changeCartCount(index: Int, value: Int)
    func redirectToDetail(index: Int)
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
        delegate?.redirectToDetail(index: productIndex)
        
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
