//
//  ViewController.swift
//  RoundedButton
//
//  Created by Piyush Sharma on 1/25/18.
//  Copyright © 2018 Piyush Sharma. All rights reserved.
//

import UIKit

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

