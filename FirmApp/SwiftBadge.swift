import UIKit

/**
 
 Badge view control for iOS.
 Project home: https://github.com/marketplacer/swift-badge
 
 */
@IBDesignable class SwiftBadge: UILabel {
    
    /// Background color of the badge
    @IBInspectable  var badgeColor: UIColor = UIColor.red {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// Width of the badge border
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    /// Color of the bardge border
    @IBInspectable var borderColor: UIColor = UIColor.white {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    /// Badge insets that describe the margin between text and the edge of the badge.
    @IBInspectable var insets: CGSize = CGSize(width: 5, height: 2) {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    // MARK: Badge shadow
    // --------------------------
    
    /// Opacity of the badge shadow
    @IBInspectable var shadowOpacityBadge: CGFloat = 0.5 {
        didSet {
            layer.shadowOpacity = Float(shadowOpacityBadge)
            setNeedsDisplay()
        }
    }
    
    /// Size of the badge shadow
    @IBInspectable var shadowRadiusBadge: CGFloat = 0.5 {
        didSet {
            layer.shadowRadius = shadowRadiusBadge
            setNeedsDisplay()
        }
    }
    
    /// Color of the badge shadow
    @IBInspectable var shadowColorBadge: UIColor = UIColor.black {
        didSet {
            layer.shadowColor = shadowColorBadge.cgColor
            setNeedsDisplay()
        }
    }
    
    /// Offset of the badge shadow
    @IBInspectable var shadowOffsetBadge: CGSize = CGSize(width: 0, height: 0) {
        didSet {
            layer.shadowOffset = shadowOffsetBadge
            setNeedsDisplay()
        }
    }
    
    convenience init() {
        self.init(frame: CGRect())
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    /// Add custom insets around the text
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let rect = super.textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines)
        
        var insetsWithBorder = actualInsetsWithBorder()
        let rectWithDefaultInsets = rect.insetBy(dx: -insetsWithBorder.width, dy: -insetsWithBorder.height)
        
        // If width is less than height
        // Adjust the width insets to make it look round
        if rectWithDefaultInsets.width < rectWithDefaultInsets.height {
            insetsWithBorder.width = (rectWithDefaultInsets.height - rect.width) / 2
        }
        let result = rect.insetBy(dx: -insetsWithBorder.width, dy: -insetsWithBorder.height)
        
        return result
    }
    
    override func drawText(in rect: CGRect) {
        layer.cornerRadius = rect.height / 2
        
        let insetsWithBorder = actualInsetsWithBorder()
        let insets = UIEdgeInsets(
            top: insetsWithBorder.height,
            left: insetsWithBorder.width,
            bottom: insetsWithBorder.height,
            right: insetsWithBorder.width)
        
        let rectWithoutInsets = UIEdgeInsetsInsetRect(rect, insets)
        
        super.drawText(in: rectWithoutInsets)
    }
    
    /// Draw the background of the badge
    override func draw(_ rect: CGRect) {
        let rectInset = rect.insetBy(dx: borderWidth/2, dy: borderWidth/2)
        let path = UIBezierPath(roundedRect: rectInset, cornerRadius: rect.height/2)
        
        badgeColor.setFill()
        path.fill()
        
        if borderWidth > 0 {
            borderColor.setStroke()
            path.lineWidth = borderWidth
            path.stroke()
        }
        
        super.draw(rect)
    }
    
    fileprivate func setup() {
        textAlignment = NSTextAlignment.center
        clipsToBounds = false // Allows shadow to spread beyond the bounds of the badge
    }
    
    /// Size of the insets plus the border
    fileprivate func actualInsetsWithBorder() -> CGSize {
        return CGSize(
            width: insets.width + borderWidth,
            height: insets.height + borderWidth
        )
    }
    
    /// Draw the stars in interface builder
    @available(iOS 8.0, *)
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        setup()
        setNeedsDisplay()
    }
}
