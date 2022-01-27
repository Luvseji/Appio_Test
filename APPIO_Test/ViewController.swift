//
//  ViewController.swift
//  APPIO_Test
//
//  Created by Константин Машейченко on 25.01.2022.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private weak var titleImage: UIImageView!
    @IBOutlet private weak var logoImage: UIImageView!
    @IBOutlet private weak var loaderView: LoaderView!
    @IBOutlet private weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTransition()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        titleImage.layer.opacity = 0
        logoImage.layer.opacity = 0
        startButton.layer.opacity = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.loaderView.startAnimating()
        }
        
    }
    
    @IBAction func startButtonAction(_ sender: Any) {
        
    }
    

}

private extension ViewController {
    
    func setupTransition() {
        let seconds = Double.random(in: 2.0 ... 5.0)
        let _ = Timer.scheduledTimer(timeInterval: seconds, target: self, selector: #selector(updateAfterLoading), userInfo: nil, repeats: false)
        
    }
    
    @objc func updateAfterLoading() {
        UIView.animate(withDuration: 1.0, delay: 0.0) {
            self.loaderView.layer.opacity = 0
        } completion: { _ in
            self.loaderView.isHidden = true
            UIView.animate(withDuration: 0.4, delay: 0.0) {
                self.titleImage.layer.opacity = 1
            } completion: { _ in
                UIView.animate(withDuration: 0.4, delay: 0.0) {
                    self.logoImage.layer.opacity = 1
                } completion: { _ in
                    UIView.animate(withDuration: 0.4, delay: 0.0) {
                        self.startButton.layer.opacity = 1
                    }
                }
            }
        }


    }
}

