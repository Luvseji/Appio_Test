//
//  ViewController.swift
//  APPIO_Test
//
//  Created by Константин Машейченко on 25.01.2022.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    @IBOutlet private weak var titleImage: UIImageView!
    @IBOutlet private weak var logoImage: UIImageView!
    @IBOutlet private weak var loaderView: LoaderView!
    @IBOutlet private weak var startButton: UIButton!
    
    private let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLocalization()
        checkLaunchStatus()
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
        startTransition()
    }
    

}

private extension WelcomeViewController {
    
    func startTransition() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        guard let booksListVC = storyBoard.instantiateViewController(withIdentifier: "booksList")
                as? BooksListViewController else { return }
        let transition = CATransition()

        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.fade
        self.navigationController?.view.layer.add(transition, forKey: nil)
        self.navigationController?.pushViewController(booksListVC, animated: false)
    }
    
    func checkLaunchStatus() {
        if !launchedBefore {
            UserDefaults.standard.set(true, forKey: "launchedBefore")
        }
        let _ = Timer.scheduledTimer(timeInterval: Double.random(in: 2.0 ... 5.0),
                                     target: self,
                                     selector: #selector(updateAfterLoading),
                                     userInfo: nil,
                                     repeats: false)
    }
    
    @objc
    func updateAfterLoading() {
        UIView.animate(withDuration: 1.0, delay: 0.0) {
            self.loaderView.layer.opacity = 0
        } completion: { _ in
            
            guard !self.launchedBefore else {
                self.startTransition()
                return
            }
            
            self.loaderView.isHidden = true
            UIView.animate(withDuration: 0.3, delay: 0.0) {
                self.titleImage.layer.opacity = 1
            } completion: { _ in
                UIView.animate(withDuration: 0.3, delay: 0.0) {
                    self.logoImage.layer.opacity = 1
                } completion: { _ in
                    UIView.animate(withDuration: 0.3, delay: 0.0) {
                        self.startButton.layer.opacity = 1
                    }
                }
            }
        }
    }
    
    func setupLocalization() {
        startButton.setTitle("welcomeButton".localized, for: .normal)
    }
}

