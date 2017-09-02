//
//  UpdateViewController.swift
//  Assesment3 PropertyOwner
//
//  Created by Audrey Lim on 29/08/2017.
//  Copyright © 2017 Audrey Lim. All rights reserved.
//

import UIKit
import CoreData

class UpdateViewController: UIViewController {

    var storedNavBkgColor = String()
    
    var propertyName : PropertyName?

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let pname = propertyName
            else {return}
        
        nameTextField.text = pname.propName
        priceTextField.text = "\(pname.propPrice)"
        locationTextField.text = pname.propLocation
    }
    
    override func viewWillAppear(_ animated: Bool) {
        switch storedNavBkgColor {
        case "purple":
            self.navigationController?.navigationBar.barTintColor = UIColor.purple
        case "blue":
            self.navigationController?.navigationBar.barTintColor = UIColor.blue
        case "green":
            self.navigationController?.navigationBar.barTintColor = UIColor.green
        case "orange":
            self.navigationController?.navigationBar.barTintColor = UIColor.orange
        default :
            break
        }
    }
    
    
    @IBAction func buttonUpdateTapped(_ sender: Any) {
        guard let name = nameTextField.text,
            let price = priceTextField.text,
            let loc = locationTextField.text
            else {return}
        
        if name == "" || price == "" || loc == "" {
            print("Name/ Price / Location cannot be empty")
            return
        }
        
        guard let validatePrice  = Double(price)
            else {
                print("Invalid input for Price")
                return
        }
        
        if (propertyName?.propName == name && (propertyName?.propPrice)! == validatePrice && propertyName?.propLocation == loc) {
            print("User Data is Unchanged")
            return
        }
        
        propertyName?.propName = name
        propertyName?.propPrice = validatePrice
        propertyName?.propLocation = loc
        DataController.saveContext()
        
        navigationController?.popViewController(animated: true) //will go back to prev VC

        
    }
    
    @IBAction func buttonCancelTapped(_ sender: Any) {
                navigationController?.popViewController(animated: true) //will go back to prev VC
        //dismiss(animated: true, completion: nil)
    }
    
 
    

}
