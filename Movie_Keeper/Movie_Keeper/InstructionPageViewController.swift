//
//  InstructionPageViewController.swift
//  Movie_Keeper
//
//  Created by Stanislav Cherkasov on 04.05.2018.
//  Copyright © 2018 Stanislav Cherkasov. All rights reserved.
//

import UIKit

class InstructionPageViewController: UIPageViewController,
    UIPageViewControllerDataSource,
    UIPageViewControllerDelegate
{
    static let IsApplicationFirstLaunchKey = "IsApplicationFirstLaunchKey"
    
    static let TurnOnButtonIdentifier = "UserGuideTurnOnButton"
    
    @IBOutlet weak var actionButton: UIBarButtonItem!
    
    var pages = [UIViewController]()
    var pageIndex: Int? {
        didSet {
            self.actionButton.title = self.actionButtonTitle(for: self.pageIndex)
        }
    }
    
    var showGuide: Bool {
        get {
            return UserDefaults.standard.object(forKey: InstructionPageViewController.IsApplicationFirstLaunchKey) as? Bool ?? true
            
        } set {
            UserDefaults.standard.set(newValue,
                                      forKey: InstructionPageViewController.IsApplicationFirstLaunchKey)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        for v in view.subviews {
            if v is UIScrollView {
                v.frame = view.bounds
                break
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        if self.showGuide {
            setupUserGuidePages()
            
            self.showGuide = false
        } else {
            
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "MovieTableViewController")
            
            if let controller = controller {
                self.navigationController?.present(controller, animated: false, completion: {})
            }
        }
    }
    
    @objc
    public func turnOnButtonTouched() {
        self.setViewControllers([self.pages[1]], direction: .forward, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        _ = self.pages
            .map { $0.view.subviews }
            .flatMap {
                $0.map {
                    if let button = $0 as? UIButton {
                        button.addTarget(self,
                                         action:#selector(turnOnButtonTouched),
                                         for: .touchUpInside)
                    }
                }
        }
    }
    
    func setupUserGuidePages() {
        let addPageWithName = { (name: String) -> Void in
            if let board = self.storyboard {
                self.pages.append(board.instantiateViewController(withIdentifier: name))
            }
        }
        
        _ = (1...4).map {
            addPageWithName("page" + String.init(describing: $0))
        }
        
        setViewControllers([pages[0]], direction: .forward, animated: true, completion: nil)
        
        dataSource = self
    }
    
    func actionButtonTitle(for index: Int?) -> String {
        return index.map { $0 < self.pages.count - 1 ? "Skip" : "Start" } ?? ""
    }
    
    // MARK: - UIPageViewControllerDataSource
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let index = pages.index(of: viewController), index > 0 {
            return pages[index - 1]
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let index = pages.index(of: viewController), index < pages.count - 1 {
            return pages[index + 1]
        }
        
        return nil
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pages.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    // MARK: - UIPageViewControllerDelegate
    var pendingViewController: UIViewController?
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            willTransitionTo pendingViewControllers: [UIViewController]) {
        self.pageIndex = nil
        self.pendingViewController = pendingViewControllers[0]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool)
    {
        self.pageIndex = (completed ? self.pendingViewController : previousViewControllers[0])
            .flatMap { self.pages.index(of: $0) }
    }
}
