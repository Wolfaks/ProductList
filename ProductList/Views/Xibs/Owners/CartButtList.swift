
import UIKit

protocol CartButtListDelegate: class {
    func addCart()
}

@IBDesignable class CartButtList: UIView {
    
    @IBOutlet weak var radiusView: UIView!
    weak var delegate: CartButtListDelegate?
    
    var view: UIView!
    var nibName: String = "CartButtList"
    
    // Размеры view
    enum sizeView: CGFloat {
        case width = 92.0
        case height = 28.0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func loadFromNib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
        
    }
    
    func setupView() {
        
        let view = loadFromNib()
        view.frame = bounds
        view.autoresizingMask = [
            UIView.AutoresizingMask.flexibleWidth,
            UIView.AutoresizingMask.flexibleHeight
        ]
        addSubview(view)
        
        // Закругляем углы кнопки
        radiusView.layer.cornerRadius = 5.0
        
    }
    
    @IBAction func addCartButt(_ sender: UIButton) {
        // Добавляем товар в карзину
        delegate?.addCart()
    }
    
}
