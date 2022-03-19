//
//  DetailsViewController.swift
//  ArtBook_CoreData
//
//  Created by Macbook on 18.03.22.
//

import UIKit
import CoreData

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var authorTextField: UITextField!
    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var topCnsrtntMainStack: NSLayoutConstraint!
    var chosenArt = ""
    var chosenArtID: UUID?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }
    
    private func config() {
        configTapGestureRecognizer()
        configTextField()
        configImageView()
        fillTheDetails()
    }
    
    private func configTapGestureRecognizer() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(recognizer)
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
    private func configTextField() {
        nameTextField.delegate = self
        authorTextField.delegate = self
        yearTextField.delegate = self
    }
    
    private func configImageView() {
        imageView.isUserInteractionEnabled = true
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        imageView.addGestureRecognizer(recognizer)
    }
    
    @objc private func selectImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    private func fillTheDetails() {
        if chosenArt != "" {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.entityName)
            let idString = chosenArtID?.uuidString
            fetchRequest.predicate = NSPredicate(format: "id = %@", idString!)
            fetchRequest.returnsObjectsAsFaults = false
            do {
                let results = try context.fetch(fetchRequest)
                if results.count > 0 {
                    for result in results as! [NSManagedObject] {
                        if let name = result.value(forKey: Constants.keyName) as? String {
                            nameTextField.text = name
                        }
                        if let author = result.value(forKey: Constants.keyAuthor) as? String {
                            authorTextField.text = author
                        }
                        if let year = result.value(forKey: Constants.keyYear) as? Int16 {
                            yearTextField.text = String(year)
                        }
                        if let imageData = result.value(forKey: Constants.keyImage) as? Data {
                            let image = UIImage(data: imageData)
                            imageView.image = image
                        }
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        } else {
            nameTextField.text = "e"
            yearTextField.text = "e"
            authorTextField.text = "e"
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.insertNewObject(forEntityName: Constants.entityName, into: context)
        entity.setValue(nameTextField.text, forKey: Constants.keyName)
        entity.setValue(authorTextField.text, forKey: Constants.keyAuthor)
        if let year = Int(yearTextField.text!) {
            entity.setValue(year, forKey: Constants.keyYear)
        }
        entity.setValue(UUID(), forKey: Constants.keyID)

        let data = imageView.image?.jpegData(compressionQuality: 0.5)
        entity.setValue(data, forKey: Constants.keyImage)
        do {
            try context.save()
            print("Context saved succsesfully")
        } catch {
            print(error.localizedDescription)
        }
        NotificationCenter.default.post(name: NSNotification.Name(Constants.notificationName), object: nil)
    }
    
}

extension DetailsViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        topCnsrtntMainStack.constant = -200
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        topCnsrtntMainStack.constant = 40
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
}

extension DetailsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
}
