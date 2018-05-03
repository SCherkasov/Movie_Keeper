//
//  DetailMovieViewController.swift
//  MovieKeeper
//
//  Created by Stanislav Cherkasov on 24.04.2018.
//  Copyright © 2018 Stanislav Cherkasov. All rights reserved.
//

import UIKit

class DetailMovieViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var imageDetail: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var movies: Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        title = movies!.title //title for nav bar
        
        imageDetail.image = UIImage(data: movies!.image as! Data)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as! DetailMovieView2TableViewCell
        
        cell.titleLabelDetail.text = movies?.title
        cell.genreLabelDetail.text = movies?.genre
        cell.yearLabelDetail.text = movies?.year
        cell.descriptionTextViewDetail.text = movies?.description
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 283
    }
}
