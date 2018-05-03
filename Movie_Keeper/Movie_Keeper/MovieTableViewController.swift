//
//  MovieTableViewController.swift
//  MovieKeeper
//
//  Created by Stanislav Cherkasov on 24.04.2018.
//  Copyright © 2018 Stanislav Cherkasov. All rights reserved.
//

import UIKit
import CoreData

class MovieTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var searchBarController: UISearchController!
    var filteredResultsArray = [Movie]()
    
    var movie: [Movie] = []
    
    //fetchResultController usefull in work with TableView!
    var fetchResultController: NSFetchedResultsController<Movie>!
    
    //dismiss from New Movie Controller
    @IBAction func close(segue: UIStoryboardSegue) {
    }
    
    //hide nav bar on swipe
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.hidesBarsOnSwipe = false
        //navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    //search bar funcs
    func filterContentFor(searchText text: String) {
        filteredResultsArray = movie.filter{ (movie) -> Bool in
            return (movie.title!.lowercased().contains(text.lowercased()))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //search bar View
        searchBarController = UISearchController(searchResultsController: nil)
        searchBarController.searchResultsUpdater = self
        searchBarController.dimsBackgroundDuringPresentation = false
        tableView.tableHeaderView = searchBarController.searchBar
        
        searchBarController.searchBar.delegate = self
        searchBarController.searchBar.barTintColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        searchBarController.searchBar.tintColor = .white
        
        //Canceling the search controller to the next screen
        definesPresentationContext = true
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil) //changing the back button of nav VC
        
        //fetching saved Core Data
        let fetchedRequest: NSFetchRequest<Movie> = Movie.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        fetchedRequest.sortDescriptors = [sortDescriptor]
        
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext {
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchedRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            
            do {
                try fetchResultController.performFetch()
                movie = fetchResultController.fetchedObjects!
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Fetch results controller Delegate
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            guard let index = newIndexPath else {break}
            tableView.insertRows(at: [index], with: .fade)
        case .delete:
            guard let index = indexPath else {break}
            tableView.deleteRows(at: [index], with: .fade)
        case .update:
            guard let index = indexPath else {break}
            tableView.reloadRows(at: [index], with: .fade)
        default:
            tableView.reloadData()
        }
        movie = controller.fetchedObjects as! [Movie]
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchBarController.isActive && searchBarController.searchBar.text != "" {
            return filteredResultsArray.count
        }
        return movie.count
    }
    
    //return cells according to the search bar status
    func movieToDisplayAt(indexPath: IndexPath) -> Movie {
        let moviess: Movie
        if searchBarController.isActive && searchBarController.searchBar.text != "" {
            moviess = filteredResultsArray[indexPath.row]
        } else {
            moviess = movie[indexPath.row]
        }
        return moviess
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! MovieTableViewCell
        
        //create an aaray according to result of the func
        let movie = movieToDisplayAt(indexPath: indexPath)
        
        //MARK: - Represent info in the Cell
        
        cell.posterImage.image = UIImage(data: movie.image as! Data)
        cell.titleLabel.text = movie.title
        cell.genreLabel.text = movie.genre
        cell.yearLabel.text = movie.year
        cell.descriptionTextView.text = movie.textAbout
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            self.movie.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext {
                
                let objectToDelete = self.fetchResultController.object(at: indexPath)
                context.delete(objectToDelete)
                
                do {
                    try context.save()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        delete.backgroundColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        return [delete]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationViewController = segue.destination as! DetailMovieViewController
                destinationViewController.movies = movieToDisplayAt(indexPath: indexPath)
            }
        }
    }
}
//search bar funcs
extension MovieTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentFor(searchText: searchController.searchBar.text!)
        tableView.reloadData()
    }
}

extension MovieTableViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if searchBar.text == "" {
            navigationController?.hidesBarsOnSwipe = false
        }
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        navigationController?.hidesBarsOnSwipe = true
    }
}
