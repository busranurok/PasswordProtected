//
//  RegisterViewController.swift
//  PasswordProtector
//
//  Created by Yeni Kullanıcı on 3.09.2020.
//  Copyright © 2020 Busra Nur OK. All rights reserved.
//

import UIKit
import CoreData

class RegisterViewController:
UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var lastnameLabel: UILabel!
    @IBOutlet weak var lastnameText: UITextField!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var repeatPasswordLabel: UILabel!
    @IBOutlet weak var repeatPasswordText: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    var userId : UUID?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //kaydet butonu şekillendirme
        saveButton.layer.cornerRadius = saveButton.frame.height / 2
        saveButton.layer.borderWidth = 1
        saveButton.layer.borderColor = UIColor.black.cgColor
        saveButton.layer.shadowRadius = 1
        saveButton.layer.shadowOpacity = 1.0
        saveButton.layer.shadowOffset = CGSize(width: 1, height: 1)
        saveButton.layer.shadowColor = UIColor.yellow.cgColor
        
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
        
        getUser()
        

        
    }
    
    
    @objc func getUser() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchRequest.returnsObjectsAsFaults = false
        
        
        do {
            
            let results = try context.fetch(fetchRequest)
            
            //veri geldi ise
            if results.count > 0 {
                
                saveButton.setTitle("Update", for: .normal)
                
                //veri tabanından dönen nesnenin tipi
                for result in results as! [NSManagedObject] {
                    
                    userId = result.value(forKey: "id") as? UUID
                    nameText.text = result.value(forKey: "name") as? String
                    lastnameText.text = result.value(forKey: "lastname") as? String
                    emailText.text = result.value(forKey: "email") as? String
                    //password ü ekrana basmamamızın sebbei kötü niyetli kişilerin düzenleme işlemiş yaptığı zasman şifre hakkında tahminde bulunmamasının sağlanması
                    
                }
                
            }
            
        } catch {
            print("error")
        }
    }
    
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        
        if saveButton.currentTitle == "Save" {
            
            if nameText.text == "" || lastnameText.text == "" || emailText.text == "" || passwordText.text == "" || repeatPasswordText.text == "" {
                
                let alert = UIAlertController(title: "Error", message: "Its Mandatort to enter all the fields.", preferredStyle: .alert)
                
                let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
                
                alert.addAction(ok)
                
                self.present(alert, animated: true, completion: nil)
                
            } else if (passwordText.text != repeatPasswordText.text) {
                
                let alert = UIAlertController(title: "Error", message: "Password does not match", preferredStyle: .alert)
                
                let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
                
                alert.addAction(ok)
                
                self.present(alert, animated: true, completion: nil)
                
            } else {
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context = appDelegate.persistentContainer.viewContext
                
                let newUser = NSEntityDescription.insertNewObject(forEntityName: "User", into: context)
                
                newUser.setValue(nameText.text, forKey: "name")
                newUser.setValue(lastnameText.text, forKey: "lastname")
                newUser.setValue(emailText.text, forKey: "email")
                newUser.setValue(passwordText.text, forKey: "password")
                newUser.setValue(UUID(), forKey: "id")
                
                do
                {
                    try context.save()
                    print("Registered  Sucessfully.")
                }
                catch
                {
                    let Fetcherror = error as NSError
                    print("error", Fetcherror.localizedDescription)
                }
            }
            
            self.navigationController?.popViewController(animated: true)
            
        } else {
            
              saveButton.imageEdgeInsets.right = 130
            
            if nameText.text == "" || lastnameText.text == "" || emailText.text == "" || passwordText.text == "" || repeatPasswordText.text == "" {
                
                let alert = UIAlertController(title: "Error", message: "Its Mandatort to enter all the fields.", preferredStyle: .alert)
                
                let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
                
                alert.addAction(ok)
                
                self.present(alert, animated: true, completion: nil)
                
            } else if (passwordText.text != repeatPasswordText.text) {
                
                let alert = UIAlertController(title: "Error", message: "Password does not match", preferredStyle: .alert)
                
                let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
                
                alert.addAction(ok)
                
                self.present(alert, animated: true, completion: nil)
                
            }
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
            fetchRequest.predicate = NSPredicate(format: "id = %@", userId!.uuidString)
            fetchRequest.returnsObjectsAsFaults = false
            
            do {
                let reusults = try context.fetch(fetchRequest)
                
                if reusults.count > 0 {
                    
                    for result in reusults as! [NSManagedObject] {
                        
                        //güncellemede id yazılmaz.
                        result.setValue(nameText.text, forKey: "name")
                        result.setValue(lastnameText.text!, forKey: "lastname")
                        result.setValue(passwordText.text!, forKey: "password")
                        result.setValue(emailText.text!, forKey: "email")
                        
                        do { try context.save()

                            
                        } catch {
                            
                            print("Error")
                        }
                        
                        }
                        
                    }
                    
            } catch {
                
                print("Error")
                
            }
            
            }
        
        let alert = UIAlertController(title: "Error", message: "Your information has been updated.", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alert.addAction(ok)
        
        self.present(alert, animated: true, completion: nil)
           
        }
    
    
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    

}
