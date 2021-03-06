//
//  ViewController.swift
//  Log In Demo
//
//  Created by Tyler McGee on 6/9/17.
//  Copyright © 2017 Tyler McGee. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var logoutButton: UIButton!
    
    @IBAction func logOut(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        
        do {
            
            let results = try context.fetch(request)
            
            if results.count > 0 {
                
                for result in results as! [NSManagedObject] {
                    
                    context.delete(result)
                    
                    do {
                        
                        try context.save()
                        
                        
                    } catch {
                        
                        print("individual delete failed")
                        
                    }
                }
                
                label.alpha = 0
                
                logoutButton.alpha = 0
                
                logInButton.setTitle("Login", for: [])
                
                isLoggedIn = false
                
                textField.alpha = 1
                
            }
            
            
        } catch {
            
            print("delete failed")
            
        }
        
    }
    
    @IBOutlet weak var textField: UITextField!

    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var logInButton: UIButton!
    
    var isLoggedIn = false
    
    @IBAction func logIn(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        
        if isLoggedIn {
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
            
            do {
                
                let results = try context.fetch(request)
                    
                if results.count > 0 {
                    
                    for result in results as! [NSManagedObject] {
                        
                        result.setValue(textField.text, forKey: "name")
                        
                        do {
                            
                            try context.save()
                            
                        } catch {
                            
                            print("update username save failed")
                            
                        }
                        
                    }
                    
                    label.text = "Hi there " + textField.text! + "!"
                    
                }
                
            } catch {
                
                print("update username failed")
                
            }
            
        } else {
        
            let newValue = NSEntityDescription.insertNewObject(forEntityName: "Users", into: context)
        
            newValue.setValue(textField.text, forKey: "name")
        
            do {
            
                try context.save()
            
                logInButton.setTitle("Update username", for: [])
            
                label.alpha = 1
            
                label.text = "Hi there " + textField.text! + "!"
            
                isLoggedIn = true
                
                logoutButton.alpha = 1
            
            
            } catch {
            
                print("failed to save")
            
            }
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        
        request.returnsObjectsAsFaults = false
        
        do {
            
            let results = try context.fetch(request)
            
            for result in results as! [NSManagedObject] {
                
                if let username = result.value(forKey: "name") as? String {
                    
                    textField.alpha = 0
                    
                    logInButton.setTitle("Update username", for: [])
                    
                    logoutButton.alpha = 1
                    
                    label.alpha = 1
                    
                    label.text = "Hi there " + username + "!"
                }
            }
            
            
        } catch {
            
            print("request failed")
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

