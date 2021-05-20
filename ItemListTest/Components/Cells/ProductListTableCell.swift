
import UIKit

class ProductListTableCell: UITableViewCell {
    
    @IBOutlet weak var borderView: UIView!
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productCategory: UILabel!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productProducer: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productSelectedAmount: UILabel!
    
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
        productSelectedAmount.text = "\(product.selectedAmount) шт"
        
        // Убираем лишние нули после запятой, если они есть и выводим цену
        productPrice.text = String(format: "%g", product.price) + " ₽"
        
        // Загрузка изображения, если ссылка пуста, то выводится изображение по умолчанию
        if !product.imageUrl.isEmpty {
            productImage.loadFromURL(url: product.imageUrl)
        }
        
    }
    
}
