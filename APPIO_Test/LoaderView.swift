//
//  LoaderView.swift
//  APPIO_Test
//
//  Created by Константин Машейченко on 26.01.2022.
//

import UIKit

class LoaderView: UIView {
    
    private lazy var outterView: UIView = {
        let color = #colorLiteral(red: 0.3882352941, green: 0.5843137255, blue: 1, alpha: 1)
        return createLoaderSubview(backgroundColor: color,
                                   borderWidth: 1)
    }()
    
    private lazy var innerView: UIView = {
        return createLoaderSubview(backgroundColor: UIColor.white,
                                   borderWidth: 1)
    }()
    
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
        self.outterView.layer.cornerRadius = self.outterView.frame.width / 2.0
        self.innerView.layer.cornerRadius = self.innerView.frame.width / 2.0
        self.pointView.layer.cornerRadius = self.pointView.frame.width / 2.0

        self.pointView.center = self.getPoint(for: -90)
    }
    
    func startAnimating() {
        let path = UIBezierPath()
        let initialPoint = self.getPoint(for: -90)
        path.move(to: initialPoint)
        for angle in -89...0 { path.addLine(to: self.getPoint(for: angle)) }
        for angle in 1...270 { path.addLine(to: self.getPoint(for: angle)) }
        path.close()
        self.animate(view: self.pointView, path: path)
    }
    
}

private extension LoaderView {
    
    private func animate(view: UIView, path: UIBezierPath) {
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.path = path.cgPath
        animation.repeatCount = .infinity
        animation.duration = 5
        view.layer.add(animation, forKey: "circleAnimation")
      }
    
    private func getPoint(for angle: Int) -> CGPoint {
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
            self.outterView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.outterView.topAnchor.constraint(equalTo: self.topAnchor),
            self.outterView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.outterView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        self.addSubview(self.innerView)
        NSLayoutConstraint.activate([
            self.innerView.centerXAnchor.constraint(equalTo: outterView.centerXAnchor),
            self.innerView.centerYAnchor.constraint(equalTo: outterView.centerYAnchor),
            self.innerView.widthAnchor.constraint(equalToConstant: 70),
            self.innerView.heightAnchor.constraint(equalToConstant: 70)
        ])
        
        self.addSubview(self.pointView)
        NSLayoutConstraint.activate([
            self.pointView.widthAnchor.constraint(equalToConstant: 13.5),
            self.pointView.heightAnchor.constraint(equalToConstant: 13.5)
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
