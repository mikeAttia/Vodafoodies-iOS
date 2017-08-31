//
//  LoadingViewController.swift
//  VodaFoodies
//
//  Created by Michael Attia on 8/26/17.
//  Copyright © 2017 Michael Attia. All rights reserved.
//

import UIKit
import Gifu

class LoadingViewController: UIViewController {

    @IBOutlet weak var loadingImage: GIFImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.view.isOpaque = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadingImage.animate(withGIFNamed: "loading")
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        loadingImage.stopAnimatingGIF()
    }
   

}
