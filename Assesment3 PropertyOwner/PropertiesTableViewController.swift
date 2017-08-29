//
//  PropertiesTableViewController.swift
//  Assesment3 PropertyOwner
//
//  Created by Audrey Lim on 29/08/2017.
//  Copyright © 2017 Audrey Lim. All rights reserved.
//

import UIKit
import CoreData

class PropertiesTableViewController: UIViewController {

    var propOwner : PropertyOwner?
    var index : Int?
    
    
   // var propertyOwners : [PropertyOwner] = []    //MOC
    var propertyNames : [PropertyName] = []      //MOC
   // var fetchResultController2 : NSFetchedResultsController<PropertyOwner>!
    var fetchResultController : NSFetchedResultsController<PropertyName>!

    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self

        loadData()

    }

    
    func loadData() {   //Fetch Request Database
        
        let request = NSFetchRequest<PropertyName>(entityName: "PropertyName")
        
        let sort = NSSortDescriptor(key: "propName", ascending: true)
        request.sortDescriptors = [sort]
        
        print(propOwner!)
        guard let dummStr = propOwner?.name else {return}
        guard let dummStr2 = propOwner?.userColor else {return}

        //filter / NSPredicate
        let predicate = NSPredicate(format: "ANY relateToOwner.name == %@", dummStr)
        request.predicate = predicate
        
        //init fetch controller
        fetchResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: DataController.moc, sectionNameKeyPath: nil, cacheName: nil)
        
        //set delegate
        fetchResultController.delegate = self
        
        
        do {
            
            try fetchResultController.performFetch()
            
            tableView.reloadData()
            
        } catch {
            
        }
        
    }
    
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            // Get the new view controller using segue.destinationViewController.
            // Pass the selected object to the new view controller.
            
            // Pass both the times to repeat, and auntie's response to ResultViewController
            
            guard let destination = segue.destination as?
                AddPropertyViewController
                else {return}
            
            guard let validPropName = propOwner else {return}

            
            destination.propOwner = validPropName

            
            
        }

        
        
        
    //End loadData
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


extension PropertiesTableViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchResultController.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = fetchResultController.object(at: indexPath).propName
        
        guard let dumm1 = fetchResultController.object(at: indexPath).propLocation else {return UITableViewCell()}
        let dumm2 = fetchResultController.object(at: indexPath).propPrice
        cell.detailTextLabel?.text = "\(dumm1),\(dumm2)"
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

extension PropertiesTableViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRowRec = fetchResultController.object(at: indexPath)
        
        //move to next VC
        //1. storyboard
        //2. instantiate the Target View Controller
        //3. setup
        //4. present
        
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let targetVC = mainStoryBoard.instantiateViewController(withIdentifier: "UpdateViewController") as? UpdateViewController
            else {return}
        
        targetVC.propertyName = selectedRowRec
        
        
        navigationController?.pushViewController(targetVC, animated: true)

        
        
    }
    
}

extension PropertiesTableViewController : NSFetchedResultsControllerDelegate {
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
        
        print("From: \(indexPath) To: \(newIndexPath)")
        
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
}

