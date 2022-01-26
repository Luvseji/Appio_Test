//
//  ViewController.swift
//  APPIO_Test
//
//  Created by Константин Машейченко on 25.01.2022.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var loaderView: LoaderView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.loaderView.startAnimating()
        }
        
    }

}

