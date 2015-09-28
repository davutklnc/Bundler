//
//  ViewController.swift
//  Bundler
//
//  Created by davut on 28/09/15.
//  Copyright © 2015 davut. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var lbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lbl.text = "ELLO".localized
        
    }
    @IBAction func changeLanguage(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex
        {
        case 0:
            Bundler.sharedLocalSystem?.setLanguageWithBlock(.EN, completion: { (settedLanguage) -> () in
                self.lbl.text = "ELLO".localized
            })
        case 1:
            Bundler.sharedLocalSystem?.setLanguageWithBlock(.TR, completion: { (settedLanguage) -> () in
                self.lbl.text = "ELLO".localized
            })
        case 2:
            Bundler.sharedLocalSystem?.setLanguageWithBlock(.DE, completion: { (settedLanguage) -> () in
                self.lbl.text = "ELLO".localized
            })
        default : break;
        }
    }
}

