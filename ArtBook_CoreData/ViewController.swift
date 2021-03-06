//
//  ViewController.swift
//  ArtBook_CoreData
//
//  Created by Macbook on 18.03.22.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var titles = [String]()
    var idies = [UUID]()
    var selectedArt = ""
    var selectedArtID: UUID?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name(Constants.notificationName), object: nil)
    }
    
    private func config() {
        configTabBar()
        getData()
        configTableView()
    }
    
    private func configTabBar() {
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonClicked))
    }
    
    @objc private func addButtonClicked() {
        performSegue(withIdentifier: Constants.segueID, sender: nil)
    }
    
    private func configTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @objc private func getData() {
        
        titles.removeAll(keepingCapacity: false)
        idies.removeAll(keepingCapacity: false)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.entityName)
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(fetchRequest)
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    if let name = result.value(forKey: Constants.keyName) as? String {
                        self.titles.append(name)
                    }
                    if let id = result.value(forKey: Constants.keyID) as? UUID {
                        self.idies.append(id)
                    }
                    self.tableView.reloadData()
                }
                print("Data has retrieved")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.segueID {
            let destinationVC = segue.destination as! DetailsViewController
            destinationVC.chosenArt = selectedArt
            destinationVC.chosenArtID = selectedArtID
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = titles[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedArt = titles[indexPath.row]
        selectedArtID = idies[indexPath.row]
        performSegue(withIdentifier: Constants.segueID, sender: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.entityName)
            let idString = idies[indexPath.row].uuidString
            fetchRequest.predicate = NSPredicate(format: "id = %@", idString)
            fetchRequest.returnsObjectsAsFaults = false
            do {
                let results = try context.fetch(fetchRequest)
                if results.count > 0 {
                    for result in results as! [NSManagedObject] {
                        if let id = result.value(forKey: Constants.keyID) as? UUID {
                            if id == idies[indexPath.row] {
                                context.delete(result)
                                titles.remove(at: indexPath.row)
                                idies.remove(at: indexPath.row)
                                self.tableView.reloadData()
                                
                                do {
                                    try context.save()
                                } catch {
                                    print("Delete error")
                                }
                                break
                            }
                        }
                    }
                }
            } catch {
                
            }
        }
    }
}

