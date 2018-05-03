//
//  AddNewMovieTableViewController.swift
//  MovieKeeper
//
//  Created by Stanislav Cherkasov on 24.04.2018.
//  Copyright © 2018 Stanislav Cherkasov. All rights reserved.
//

import UIKit

class AddNewMovieTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var newImage: UIImageView!
    @IBOutlet weak var newTitleTexfield: UITextField!
    @IBOutlet weak var newGenreTextField: UITextField!
    @IBOutlet weak var newYearTextField: UITextField!
    @IBOutlet weak var newDescriptionTextView: UITextView!
    
    // editing = new
    var newMovie: Movie?
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        
        if newTitleTexfield.text == "" || newGenreTextField.text == "" || newYearTextField.text == "" {
            print("Заполните все поля")
        } else {
            //get to the context of CoreData
            if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext {
                let movie = Movie(context: context)
                movie.title = newTitleTexfield.text
                movie.genre = newGenreTextField.text
                movie.year = newYearTextField.text
                movie.textAbout = newDescriptionTextView.text
                
                if let image = newImage.image {
                    movie.image = UIImagePNGRepresentation(image) as! Data
                }
                do {
                    try context.save()
                    print("Сохраненно!")
                } catch let error as NSError{
                    print("Сохранить не удалось \(error) | \(error.userInfo)")
                }
            }
            performSegue(withIdentifier: "saveSegue", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        newImage.image = info[UIImagePickerControllerEditedImage] as? UIImage
        newImage.contentMode = .scaleAspectFill
        newImage.clipsToBounds = true
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //Chosing the source of taking photo
        if indexPath.row == 0 {
            let alertController = UIAlertController(title: "Источник фото", message: nil, preferredStyle: .actionSheet)
            
            let cameraAction = UIAlertAction(title: "Камера", style: .default) { (action) in
                self.choosePhoto(by: .camera)
            }
            
            let pholoLibAction = UIAlertAction(title: "Фото", style: .default) { (action) in
                self.choosePhoto(by: .photoLibrary)
            }
            
            let cancelAction = UIAlertAction(title: "Отменить", style: .cancel, handler: nil)
            
            alertController.addAction(cameraAction)
            alertController.addAction(pholoLibAction)
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true, completion: nil)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func choosePhoto(by type: UIImagePickerControllerSourceType) {
        if UIImagePickerController.isSourceTypeAvailable(type) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = type
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 5
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
}
