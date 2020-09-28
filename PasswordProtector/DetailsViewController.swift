//
//  DetailsViewController.swift
//  PasswordProtector
//
//  Created by Yeni Kullanıcı on 31.08.2020.
//  Copyright © 2020 Busra Nur OK. All rights reserved.
//

import UIKit
import CoreData


class DetailsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate{
    
    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var siteNameText: UITextField!
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var categoryText: UITextField!
    
   
    //var pickerData = ["A","B"]
    //picker elementinden kullanılacak değerleri diziye atıyoruz
    var pickerData = [PasswordType]()
    var selectedPickerData: String?
    
    
    
    //list view daki selected ı buraya eşitlemek için böyle bir değişken tanımlıyoruz
    var chosenInformation = ""
    var chosenInformationId : UUID?
    var gestureRecognizer : UITapGestureRecognizer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //giriş butonu şekillendirme
        saveButton.layer.cornerRadius = saveButton.frame.height / 2
        saveButton.layer.borderWidth = 1
        saveButton.layer.borderColor = UIColor.black.cgColor
        saveButton.layer.shadowRadius = 1
        saveButton.layer.shadowOpacity = 1.0
        saveButton.layer.shadowOffset = CGSize(width: 1, height: 1)
        saveButton.layer.shadowColor = UIColor.yellow.cgColor
        
        
        //Dropdown
        createdPicker()
        createdToolBar()
       
        pickerData.append(.bank)
        pickerData.append(.mail)
        pickerData.append(.shopping)
        pickerData.append(.others) //Dropdown
        
        
        

        //yani listeleme ekranından veri uptade yapmak istediğimizde
        //detay sayfasını gösterir
        if chosenInformation == "Update" {
            
            saveButton.isEnabled = true
            saveButton.setTitle("Update", for: UIControl.State.normal)
            
            //Core Data
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Information")
            let idString = chosenInformationId?.uuidString
            //filtreleme işlemi yapılır
            fetchRequest.predicate = NSPredicate(format: "id = %@", idString!)
            fetchRequest.returnsObjectsAsFaults = false
            
            do {
                let results = try context.fetch(fetchRequest)
                
                if results.count > 0 {
                    
                    for result in results as! [NSManagedObject] {
                        
                        //veritabanından aldıklarını textfield lara yazdırıyoruz
                        if let categoryName = result.value(forKey: "category") as? String {
                            categoryText.text = categoryName
                        }
                        
                        if let siteName = result.value(forKey: "siteName") as? String {
                            siteNameText.text = siteName
                        }
                        
                        
                        if let username = result.value(forKey: "username") as? String {
                            usernameText.text = username
                        }
                        
                        if let password = result.value(forKey: "password") as? String {
                            passwordText.text = password
                        }
                    }
                }
                
            } catch{
                
                print("error")
                
            }
            
            
            
            //Recognizers
            
            gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
            view.addGestureRecognizer(gestureRecognizer)
            
        }
            
        //yani listeleme ekranından veri seçilmiş ise
        //detay sayfasını gösterir
        else if chosenInformation != "" {
            
            //detay kısmına gönderecek ve orada save buttonu gözükecek fakat basılmasına izin verilmeyecek
            saveButton.isHidden = false
            saveButton.isEnabled = false
            siteNameText.isEnabled = false
            categoryText.isEnabled = false
            usernameText.isEnabled = false
            passwordText.isEnabled = false

            
            //Core Data
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Information")
            let idString = chosenInformationId?.uuidString
            //filtreleme işlemi yapılır
            fetchRequest.predicate = NSPredicate(format: "id = %@", idString!)
            fetchRequest.returnsObjectsAsFaults = false
            
            do {
                let results = try context.fetch(fetchRequest)
                
                if results.count > 0 {
                    
                    for result in results as! [NSManagedObject] {
                        
                        //veritabanından aldıklarını textfield lara yazdırıyoruz
                        if let categoryName = result.value(forKey: "category") as? String {
                            categoryText.text = categoryName
                        }
                        
                        if let siteName = result.value(forKey: "siteName") as? String {
                            siteNameText.text = siteName
                        }
                        
                        
                        if let username = result.value(forKey: "username") as? String {
                            usernameText.text = username
                        }
                        
                        if let password = result.value(forKey: "password") as? String {
                            passwordText.text = password
                        }
                    }
                }
                
            } catch{
                
                print("error")
                
            }
            
        } else {
            saveButton.isHidden = false
            saveButton.isEnabled = true
            categoryText.text = ""
            siteNameText.text = ""
            usernameText.text = ""
            passwordText.text = ""
        }
        
        
        
        
        //Recognizers
        gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
        
    }
    
    
    
    //Dropdown
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedPickerData = pickerData[row].rawValue
        categoryText.text = selectedPickerData
        //categoryText.resignFirstResponder()
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return pickerData[row].rawValue
    }
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label : UILabel
        
        if let view = view as? UILabel {
            
            label = view
            
        } else {
            label = UILabel()
        }
        
        label.textColor = .white
        label.textAlignment = .center
        label.text = pickerData[row].rawValue
        
        return label
    }
    
    
    func createdPicker() {
        
        //pickerview elementini kod ayarak çalıştırıyoruz
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        categoryText.inputView = picker
        
        picker.backgroundColor = #colorLiteral(red: 0.1294117647, green: 0.5921568627, blue: 0.9529411765, alpha: 1)
        
    }
    
    
    //picker elementini kapatmak için toolbar oluşturulur
    func createdToolBar() {
        
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //Customizations
        toolbar.barTintColor = #colorLiteral(red: 0.1294117647, green: 0.5921568627, blue: 0.9529411765, alpha: 1)
        toolbar.tintColor = .white
        //bar button
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneButton], animated: true)
        
        
        //assign toolbar
        categoryText.inputAccessoryView = toolbar
        
    }
    
    
    @objc func donePressed() {
        
        self.view.endEditing(true)
        
    }
 //Dropdown


    
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    


    @IBAction func saveClick(_ sender: Any) {
        
        if siteNameText.text == "" || usernameText.text == "" || passwordText.text == "" || categoryText.text == "" {
            
            let alert = UIAlertController(title: "Error", message: "Its Mandatort to enter all the fields.", preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
            
            alert.addAction(ok)
            
            self.present(alert, animated: true, completion: nil)
            
        }
        
        if saveButton.currentTitle == "Save" {
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            
            //yeni bir nesne oluşturuyoruz
            let newInformation = NSEntityDescription.insertNewObject(forEntityName: "Information", into: context)
            
            //Attributes
            
            //bu nesneye değer atamalarını yapıyoruz
            newInformation.setValue(siteNameText.text!, forKey: "siteName")
            newInformation.setValue(usernameText.text!, forKey: "username")
            newInformation.setValue(passwordText.text!, forKey: "password")
            newInformation.setValue(categoryText.text!, forKey: "category")
            //newInformation.setValue(GlobalSettings.currentUserId, forKey:"userId")
            newInformation.setValue(UUID(), forKey: "id")
            
            do {
                try context.save()
                print("success")
            } catch {
                print("error")
            }
            
        } else {

            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Information")
            fetchRequest.predicate = NSPredicate(format: "id = %@", chosenInformationId!.uuidString)
            fetchRequest.returnsObjectsAsFaults = false
            
            do {
                let reusults = try context.fetch(fetchRequest)
                
                if reusults.count > 0 {
                    
                    for result in reusults as! [NSManagedObject] {
                        
                        //güncellemede id yazılmaz.
                        result.setValue(siteNameText.text!, forKey: "siteName")
                        result.setValue(usernameText.text!, forKey: "username")
                        result.setValue(passwordText.text!, forKey: "password")
                        result.setValue(categoryText.text!, forKey: "category")
                       
                        
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
        
        //yeni bir veri ekledik git listeyi güncelle diyoruz.
        //yeni bir şey eklendiğine dair bayrak kaldırıyoruz
        //detay ekranından sonra listeye döndüğümüzde detay ekranında yaptığımız değişiklik listeye yansısın diye bu oluşturulur.
        NotificationCenter.default.post(name: NSNotification.Name("newData"), object: nil)
        self.navigationController?.popViewController(animated: true)
        
        //performSegue(withIdentifier: "toListVC", sender: nil)
    }

}
