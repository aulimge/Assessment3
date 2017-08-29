//
//  AddPropertyViewController.swift
//  Assesment3 PropertyOwner
//
//  Created by Audrey Lim on 29/08/2017.
//  Copyright © 2017 Audrey Lim. All rights reserved.
//

import UIKit
import CoreData

class AddPropertyViewController: UIViewController {
    
    var propOwner : PropertyOwner?

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    @IBAction func buttonSaveTapped(_ sender: Any) {
        guard
            let inputName = nameTextField.text,
            let inputLocation = locationTextField.text,
            let inputPrice = priceTextField.text
            else {return}
        
        if inputName == "" {
            return
        }
        
        guard let desc = NSEntityDescription.entity(forEntityName: "PropertyName", in: DataController.moc)
            else {return}
        
        let newRec = PropertyName(entity: desc, insertInto: DataController.moc)
        newRec.propName = inputName
        newRec.propLocation = inputLocation
        newRec.propPrice = Double(inputPrice)!
        

       // newRec.addToRelateToOwner(propOwner!)
       
        propOwner?.addToRelateProperty(newRec)
        DataController.saveContext()
        
        //init fields to blank
        nameTextField.text = nil
        priceTextField.text = nil
        locationTextField.text = nil

         dismiss(animated: true, completion: nil)
        
//        //check with database
//        let subjectRequest = NSFetchRequest<Subject>(entityName: "Subject")
//        let subjectFilter = NSPredicate(format: "name = %@", subName)
//        subjectRequest.predicate = subjectFilter
//        
//        do {
//            let data = try DataController.moc.fetch(subjectRequest)
//            if let oldSubject = data.first {
//                student?.addToEnroll(oldSubject)
//            }
    }
    
    
    @IBAction func buttonCancelTapped(_ sender: Any) {
         dismiss(animated: true, completion: nil)
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
