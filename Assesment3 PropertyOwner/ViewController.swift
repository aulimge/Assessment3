//
//  ViewController.swift
//  Assesment3 PropertyOwner
//
//  Created by Audrey Lim on 29/08/2017.
//  Copyright © 2017 Audrey Lim. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    //var propertyOwners : [PropertyOwner] = []    //MOC
    var fetchResultController : NSFetchedResultsController<PropertyOwner>!
    //var selectedRecVar : String
    
    var storedNavBkgColor = String()
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        tableView.dataSource = self
        tableView.delegate = self
        
        loadData()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        self.navigationController?.navigationBar.barTintColor = UIColor.white
    }
    
    
    @IBAction func buttonAddOwnerTapped(_ sender: Any) {
        //add owner
        
        let alert = UIAlertController(title: "Add", message: "", preferredStyle: .alert)
        
        alert.addTextField { (tmpf) in
            tmpf.placeholder = "Owner Name"
            
        }
        
        
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            //get the name
            guard let nameTextField = alert.textFields?.first,
                let name = nameTextField.text
                else {
                    return
            }
            
            if name.replacingOccurrences(of: " ", with: "") == "" {
                return
            }
            
            
            //Create a New Owner
            guard let desc = NSEntityDescription.entity(forEntityName: "PropertyOwner", in: DataController.moc) else {return}
            
            let newRecord = PropertyOwner(entity: desc, insertInto: DataController.moc)
            newRecord.name = name
            
            DataController.saveContext()
            
            //   self.people.append(newPerson)
            //   self.tableView.reloadData()  not required for Fetch as using delegate
            
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        
        
        present(alert, animated: true, completion: nil)

        
    } // end buttonAddOwnerTapped


    //****** ADD COLOR *********
    @IBAction func buttonColorTapped(_ sender: Any) {
        //assign color
        let alert = UIAlertController(title: "Choose a defaut Color!", message: "", preferredStyle: .alert)
        
        let colorPurple = UIAlertAction(title: "Purple", style: .default) { (action) in
//           fetchResultController.object(at: selectedRecVar).userColor = "purple"
//           DataController.saveContext()
        }
        alert.addAction(colorPurple)

        let colorBlue = UIAlertAction(title: "Blue", style: .default) { (action) in
//            fetchResultController.object(at: selectedRecVar).userColor = "blue"
//            DataController.saveContext()
        }
        alert.addAction(colorBlue)

        let colorOrange = UIAlertAction(title: "Orange", style: .default) { (action) in
//            fetchResultController.object(at: selectedRecVar).userColor = "orange"
//            DataController.saveContext()
        }
        alert.addAction(colorOrange)

        let colorGreen = UIAlertAction(title: "Green", style: .default) { (action) in
//            fetchResultController.object(at: selectedRecVar).userColor = "green"
//            DataController.saveContext()
        }
        alert.addAction(colorGreen)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func loadData() {   //Fetch Request Database
        
        let request = NSFetchRequest<PropertyOwner>(entityName: "PropertyOwner")
        
        let sort = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sort]
        
        //init fetch controller
        fetchResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: DataController.moc, sectionNameKeyPath: nil, cacheName: nil)
        
        //set delegate
        fetchResultController.delegate = self
        
        
        do {
            
            try fetchResultController.performFetch()
            
            tableView.reloadData()
            
        } catch {
            
        }
        
    } //End loadData
    
    
}


extension ViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchResultController.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel?.text = fetchResultController.object(at: indexPath).name
        //cell.detailTextLabel.text = fetchResultController.object(at: indexPath).userColor
        return cell
    }
    
    // Override to support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let selectedRec = fetchResultController.object(at: indexPath)
            DataController.moc.delete(selectedRec)
            DataController.saveContext()
            
            // Delete the row from the data source
            //tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            
            //guard let index = newIndexPath else {return}
//            tableView.insertRows(at: [indexPath], with: .right)
//            DataController.saveContext()
        }
    }
    
    
}

extension ViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRowRec = fetchResultController.object(at: indexPath)
        
        let selectedRecVar = selectedRowRec //indexPath  //store the index
        print("******")
        print(selectedRecVar)
        
        guard let storedColor = fetchResultController.object(at: indexPath).userColor else {return}
        
        switch storedColor {
        case "purple":
             self.navigationController?.navigationBar.tintColor = UIColor.purple
        case "orange":
            self.navigationController?.navigationBar.tintColor = UIColor.orange
        case "blue":
            self.navigationController?.navigationBar.tintColor = UIColor.blue
        case "green":
            self.navigationController?.navigationBar.tintColor = UIColor.green
        default:
            self.navigationController?.navigationBar.tintColor = UIColor.purple
        }
        
        
        //move to next VC
        //1. storyboard
        //2. instantiate the Target View Controller
        //3. setup
        //4. present
        
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let targetVC = mainStoryBoard.instantiateViewController(withIdentifier: "PropertiesTableViewController") as? PropertiesTableViewController
            else {return}
        
        targetVC.propOwner = selectedRowRec  // pass the owner name back
        targetVC.index = indexPath.row   //pass the index back
        
        targetVC.storedNavBkgColor = storedColor
        
        //present(targetVC, animated: true, completion: nil)
        
        navigationController?.pushViewController(targetVC, animated: true)

        
    }
    
}


extension ViewController : NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            print("Insert")
            guard let index = newIndexPath else {return}
            tableView.insertRows(at: [index], with: .right)
            
        case .update:
            print("Update")
            guard let index = indexPath else {return}
            tableView.reloadRows(at: [index], with: .fade)
            
            
        case .move:
            print("Move")
            guard let oldIndex = indexPath,
                let newIndex = newIndexPath
                else {return}
            tableView.moveRow(at: oldIndex, to: newIndex)
            
            
        case .delete:
            print("Delete")
            guard let index = indexPath else {return}
            tableView.deleteRows(at: [index], with: .right)
            
            
            
        } //end switch
        
        
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
}



