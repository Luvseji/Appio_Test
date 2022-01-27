//
//  LoaderView.swift
//  APPIO_Test
//
//  Created by Константин Машейченко on 26.01.2022.
//

import UIKit

class LoaderView: UIView {
    
    let outterSize = 100.0
    let outterBackground = CAGradientLayer()
    private lazy var outterView: UIView = {
        let color = #colorLiteral(red: 0.3882352941, green: 0.5843137255, blue: 1, alpha: 1)
        return createLoaderSubview(backgroundColor: color,
                                   borderWidth: 1)
    }()
    
    let innerSize = 70.0
    let innerBorder = CAGradientLayer()
    private lazy var innerView: UIView = {
        return createLoaderSubview(backgroundColor: UIColor.white,
                                   borderWidth: 1)
    }()
    
    let pointSize = 13.5
    private lazy var pointView: UIView = {
        return createLoaderSubview(backgroundColor: UIColor.black,
                                   borderWidth: 0.5)
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setGradientBackground(for: outterView)
        setGradientBorder(for: innerView)
        
        outterView.layer.cornerRadius = outterView.frame.width / 2.0
        innerView.layer.cornerRadius = innerView.frame.width / 2.0
        pointView.layer.cornerRadius = pointView.frame.width / 2.0

        pointView.center = getPoint(for: -90)
    }
    
    func startAnimating() {
        animatePointPosition()
        animateBackgroundColorFirst {
            self.outterBackground.colors = [
                #colorLiteral(red: 1, green: 0.001965026837, blue: 0.002425886225, alpha: 1).cgColor,
                #colorLiteral(red: 0.5440160632, green: 0.06818716228, blue: 0.9537369609, alpha: 1).cgColor
            ]
            self.animateBackgroundColorContinue()
        }
        animateSize()
        animateBorderOpacity()
        animateBorderWidth()
    }
    
}

private extension LoaderView {
    
    func animateBorderWidth() {
        UIView.animate(withDuration: 2.0, delay: 0.0, options: [.repeat, .autoreverse]) {
            self.outterView.layer.borderWidth = 0
            self.innerView.layer.borderWidth = 0
        }
    }
    
    func animateBorderOpacity() {
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.duration = 2.0
        opacityAnimation.fromValue = 0
        opacityAnimation.toValue = 1
        opacityAnimation.repeatCount = .infinity
        opacityAnimation.autoreverses = true
        innerBorder.add(opacityAnimation, forKey: "opacityAnimation")
    }
    
    func animateSize() {
        UIView.animate(withDuration: 2.0, delay: 0.0, options: [.repeat, .autoreverse]) {
            self.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }

    }
    
    func animateBackgroundColorFirst(completion: @escaping (() -> Void)) {
        CATransaction.begin()
        let gradientChangeAnimation = CABasicAnimation(keyPath: "colors")
        gradientChangeAnimation.duration = 2.0
        gradientChangeAnimation.toValue = [
            #colorLiteral(red: 1, green: 0.001965026837, blue: 0.002425886225, alpha: 1).cgColor,
            #colorLiteral(red: 0.5440160632, green: 0.06818716228, blue: 0.9537369609, alpha: 1).cgColor
        ]
        gradientChangeAnimation.fillMode = CAMediaTimingFillMode.forwards
        gradientChangeAnimation.isRemovedOnCompletion = false
        CATransaction.setCompletionBlock(completion)
        outterBackground.add(gradientChangeAnimation, forKey: "backgroundAnimation")
        CATransaction.commit()
    }
    
    func animateBackgroundColorContinue() {
        let gradientChangeAnimation = CABasicAnimation(keyPath: "colors")
        gradientChangeAnimation.duration = 2.0
        gradientChangeAnimation.toValue = [
            #colorLiteral(red: 0.5895209908, green: 0.5640896559, blue: 0.9912117124, alpha: 1).cgColor,
            #colorLiteral(red: 0.9885050654, green: 0.4543109536, blue: 0.4580554962, alpha: 1).cgColor
        ]
        gradientChangeAnimation.repeatCount = .infinity
        gradientChangeAnimation.autoreverses = true
        gradientChangeAnimation.fillMode = CAMediaTimingFillMode.forwards
        gradientChangeAnimation.isRemovedOnCompletion = false
        outterBackground.add(gradientChangeAnimation, forKey: "backgroundAnimation")
    }
    
    func animatePointPosition() {
        let path = UIBezierPath()
        let initialPoint = self.getPoint(for: -90)
        path.move(to: initialPoint)
        for angle in -89...0 { path.addLine(to: self.getPoint(for: angle)) }
        for angle in 1...270 { path.addLine(to: self.getPoint(for: angle)) }
        path.close()
        
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.path = path.cgPath
        animation.repeatCount = .infinity
        animation.duration = 1
        pointView.layer.add(animation, forKey: "circleAnimation")
    }
    
    func setGradientBorder(for view: UIView) {
        innerBorder.frame =  CGRect(origin: CGPoint.zero, size: view.frame.size)
        innerBorder.colors = [
            #colorLiteral(red: 1, green: 0.7607843137, blue: 0, alpha: 1).cgColor,
            #colorLiteral(red: 1, green: 0.9490196078, blue: 0.8078431373, alpha: 1).cgColor,
            #colorLiteral(red: 1, green: 0.6470588235, blue: 0.1176470588, alpha: 1).cgColor,
            #colorLiteral(red: 0.9725490196, green: 0.8705882353, blue: 0.6666666667, alpha: 1).cgColor,
            #colorLiteral(red: 0.9960784314, green: 0.8588235294, blue: 0.3294117647, alpha: 1).cgColor
        ]
        innerBorder.startPoint = .zero
        innerBorder.endPoint = CGPoint(x: 1, y: 1)
        innerBorder.cornerRadius = view.frame.width / 2

        let shape = CAShapeLayer()
        shape.lineWidth = 15
        shape.path = UIBezierPath(roundedRect: view.bounds,
                                             cornerRadius: view.frame.width / 2).cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        innerBorder.mask = shape
        innerBorder.opacity = 0
        view.layer.addSublayer(innerBorder)
    }
    
    func setGradientBackground(for view: UIView) {
        outterBackground.frame = view.bounds
        outterBackground.colors = [
            #colorLiteral(red: 0.3882352941, green: 0.5843137255, blue: 1, alpha: 1).cgColor,
            #colorLiteral(red: 0.3882352941, green: 0.5843137255, blue: 1, alpha: 1).cgColor
        ]
        outterBackground.startPoint = CGPoint(x:0, y:0)
        outterBackground.endPoint = CGPoint(x:1, y:1)
        outterBackground.cornerRadius = view.frame.width / 2
        view.layer.addSublayer(outterBackground)
    }
    
    func getPoint(for angle: Int) -> CGPoint {
        let radius = Double(outterView.frame.width / 2)
        let radian = Double(angle) * Double.pi / Double(180)
        let pointCoeff = radius - pointView.frame.width / 2.0 - outterView.layer.borderWidth
        let newCenterX = radius + pointCoeff * cos(radian)
        let newCenterY = radius + pointCoeff * sin(radian)

        return CGPoint(x: newCenterX, y: newCenterY)
    }
    
    func setup() {
        self.clipsToBounds = false
        
        self.addSubview(self.outterView)
        NSLayoutConstraint.activate([
            self.outterView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.outterView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.outterView.widthAnchor.constraint(equalToConstant: outterSize),
            self.outterView.heightAnchor.constraint(equalToConstant: outterSize)
        ])
        
        self.addSubview(self.innerView)
        NSLayoutConstraint.activate([
            self.innerView.centerXAnchor.constraint(equalTo: outterView.centerXAnchor),
            self.innerView.centerYAnchor.constraint(equalTo: outterView.centerYAnchor),
            self.innerView.widthAnchor.constraint(equalToConstant: innerSize),
            self.innerView.heightAnchor.constraint(equalToConstant: innerSize)
        ])
        
        self.addSubview(self.pointView)
        NSLayoutConstraint.activate([
            self.pointView.widthAnchor.constraint(equalToConstant: pointSize),
            self.pointView.heightAnchor.constraint(equalToConstant: pointSize)
        ])
    }
    
    func createLoaderSubview(backgroundColor: UIColor,
                             borderWidth: Double) -> UIView {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.backgroundColor = backgroundColor.cgColor
        view.layer.borderColor = #colorLiteral(red: 0.1643927395, green: 0.1996709406, blue: 1, alpha: 1).cgColor
        view.layer.borderWidth = borderWidth
        
        return view
    }
}
