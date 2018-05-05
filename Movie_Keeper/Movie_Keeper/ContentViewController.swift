//
//  ContentViewController.swift
//  Movie_Keeper
//
//  Created by Stanislav Cherkasov on 05.05.2018.
//  Copyright © 2018 Stanislav Cherkasov. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var pageButton: UIButton!
    
    var image = ""
    var text = ""
    var index = 0
    
    @IBAction func pageButtonPressed(_ sender: UIButton) {
        
        switch index {
        case 0:
            let pageVC = parent as! PageViewController
        pageVC.nextVC(atIndex: index)
        case 1:
            let pageVC = parent as! PageViewController
            pageVC.nextVC(atIndex: index)
        case 2:
            let pageVC = parent as! PageViewController
            pageVC.nextVC(atIndex: index)
        case 3:
            let userDefaults = UserDefaults.standard
            userDefaults.set(true, forKey: "wasWatched")
            userDefaults.synchronize()
            dismiss(animated: true, completion: nil)
        default:
            break
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        switch index {
        case 0: pageButton.setTitle("Skip", for: .normal)
        case 1: pageButton.setTitle("Skip", for: .normal)
        case 2: pageButton.setTitle("Skip", for: .normal)
        case 3: pageButton.setTitle("Start", for: .normal)
        default:
            break
        }
        
        textView.text = text
        imageView.image = UIImage(named: image)
        
        pageControl.numberOfPages = 4
        pageControl.currentPage = index
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
