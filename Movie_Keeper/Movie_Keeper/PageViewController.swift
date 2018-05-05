//
//  PageViewController.swift
//  Movie_Keeper
//
//  Created by Stanislav Cherkasov on 05.05.2018.
//  Copyright © 2018 Stanislav Cherkasov. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController {

    
    var textArray = ["Tab the add button to create the new movie in your collection", "fill in all the fields following steps 1-5 and then click the save button (spep 6). Also, if you change your mind - click the cancel button (step 7)", "if you suddenly want to delete a movie - just make a swipe to the left in the row and click the delete button", "when your movie collection becomes very huge, you can just use the search field. The search works by the name of the movie, genre, year or simply by any word from the description"]
    
    var imageArray = ["pic1", "pic2", "pic3", "pic4"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self

        if let firstVC = displayViewController(atIndex: 0) {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayViewController(atIndex index: Int) -> ContentViewController? {
        guard index >= 0 else { return nil }
        guard index < textArray.count else { return nil }
        guard let contentVC = storyboard?.instantiateViewController(withIdentifier: "contentViewController") as? ContentViewController else { return nil }
        
        contentVC.image = imageArray[index]
        contentVC.text = textArray[index]
        contentVC.index = index
        
        return contentVC
    }
    
    func nextVC(atIndex index: Int) {
        if let contentVC = displayViewController(atIndex: index + 1) {
            setViewControllers([contentVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
}

extension PageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! ContentViewController).index
        index -= 1
        
        return displayViewController(atIndex: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! ContentViewController).index
        index += 1
        
        return displayViewController(atIndex: index)
    }
    
//    func presentationCount(for pageViewController: UIPageViewController) -> Int {
//        return textArray.count
//    }
//    
//    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
//        let contentVC = storyboard?.instantiateViewController(withIdentifier: "contentViewController") as? ContentViewController
//        
//        return contentVC!.index
//    }
}









