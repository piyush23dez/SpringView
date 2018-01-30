//
//  ViewController.swift
//  RoundedButton
//
//  Created by Piyush Sharma on 1/25/18.
//  Copyright © 2018 Piyush Sharma. All rights reserved.
//

import UIKit

//https://stackoverflow.com/questions/40320727/fill-uiimageview-with-other-color-animated

class ViewController: UIViewController {
   
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

@IBDesignable
 public class RoundedView: UIView {
    
    let shapeLayer = CAShapeLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    //choose backgrounf color for takeing this in effect
    /*public override func draw(_ frame: CGRect) {

        let maskPAth1 = UIBezierPath(roundedRect: self.bounds,
                                     byRoundingCorners: [.topRight , .bottomRight],
                                     cornerRadii:CGSize(width: self.frame.size.width/2, height: self.frame.size.height/2))

        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = self.bounds
        maskLayer1.path = maskPAth1.cgPath
        self.layer.mask = maskLayer1
    }*/

    
    // MARK: Public interface
    // Corner radius of the background rectangle
    public var roundRectCornerRadius: CGFloat = 20 {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    // Color of the background rectangle
    public var roundRectColor: UIColor = UIColor(red: 128/255, green: 0, blue: 255/255, alpha: 1) {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        layoutRoundRectLayer()
    }
    
    // MARK: Private
    
    private func layoutRoundRectLayer() {

        let maskPAth1 = UIBezierPath(roundedRect: self.bounds,
                                                    byRoundingCorners: [.topRight , .bottomRight],
                                                 cornerRadii:CGSize(width: self.frame.size.width/2, height: self.frame.size.height/2))


        shapeLayer.path = maskPAth1.cgPath
        shapeLayer.fillColor = roundRectColor.cgColor
        self.layer.insertSublayer(shapeLayer, at: 0)
    }
}

@IBDesignable
class SpringView: UIView {
    
    let liquidView = RoundedView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Overrides
    override public func didMoveToSuperview() {
        super.didMoveToSuperview()
        animate()
    }
    
    func setup() {
        self.backgroundColor = UIColor.clear
        self.liquidView.backgroundColor = UIColor.clear
        self.addSubview(liquidView)
        reset()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        liquidView.frame = self.bounds //CGRect(x: 0, y: 0, width: 200, height: 60)
    }
    
    func reset() {
        liquidView.frame.origin.x = 0
    }
    
    func animate() {
        reset()
        UIView.animate(withDuration: 0.75, animations: {
            self.liquidView.frame.origin.x = self.frame.size.width
        }) { (finish) in
            
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.liquidView.frame.origin.x -= 20
            }, completion: { (f) in })
        }
    }
}

@IBDesignable
class CurtainView: UIView {
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code

        let path = UIBezierPath()

        let p0 = CGPoint(x: 0, y: 0)
        let p1 = CGPoint(x: bounds.size.width, y: 0)
        let p2 = CGPoint(x: bounds.size.width, y: bounds.size.height-35)
        let p3 = CGPoint(x: 0, y: bounds.size.height-35)
        let controlPoint = CGPoint(x: bounds.size.width/2, y: bounds.size.height+10)

        path.move(to: p0)
        path.addLine(to: p1)
        path.addLine(to: p2)
        path.addQuadCurve(to: p3, controlPoint: controlPoint)
        path.close()

        let shape = CAShapeLayer()
        shape.path = path.cgPath
        shape.fillColor = UIColor.orange.withAlphaComponent(0.7).cgColor
        layer.insertSublayer(shape, at: 0)
    }
}


/*  When we implement -drawRect:, the background color of our view is then drawn into the associated CALayer, rather than just being set on the CALayer as a style property... thus prevents it from getting a contents animated, The solution is to add another view above, behind, or wherever, and animate that. This animates just fine.
 
    we can apply layer effects to our mask object and it will work just fine. Just don't forget to set to mask a
    color, any color, as long as you have alpha value greater than 0.0.
    http://arsenkin.com/ios-mask-view-with-view.html
*/

@IBDesignable
class CurtainSpring: UIView {
    
    let curtain = CurtainView() //is going to be animated from top to bottom
    let shape = UIView() //is going to mask everything with alpha mask
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        self.backgroundColor = UIColor.yellow
        self.shape.backgroundColor = UIColor.orange
        self.curtain.backgroundColor = .clear
        
        //added our curtain view to animate
        self.addSubview(curtain)
        self.mask = shape
        reset()
    }
    
    override func didMoveToSuperview() {
        animate()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        curtain.frame = self.bounds
        shape.frame = self.bounds
    }
    
    func reset() {
        curtain.frame.origin.y = 0
    }
    
    func animate() {
        reset()
        
        UIView.animate(withDuration: 1, animations: {
            self.curtain.frame.origin.y = self.frame.size.height
        }) { (finish) in
            
            UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
                self.curtain.frame.origin.y -= 15
            }, completion: { (f) in })
        }
    }
}
