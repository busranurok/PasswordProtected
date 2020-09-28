//
//  UsersViewController.swift
//  PasswordProtector
//
//  Created by Yeni Kullanıcı on 2.09.2020.
//  Copyright © 2020 Busra Nur OK. All rights reserved.
//

import UIKit
import CoreData
import LocalAuthentication

class UsersViewController: UIViewController {

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var forgetLabel: UILabel!
    @IBOutlet weak var signinButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    
    var buttonCustomButton = CustomButton()
    
    var username : String!
    var password : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        //self.view.backgroundColor = #colorLiteral(red: 0.06666666667, green: 0.6196078431, blue: 1, alpha: 1)
        //buttonCustomButton.setRadiusAndShadow()
        
        
        //giriş butonu şekillendirme
        signinButton.layer.cornerRadius = signinButton.frame.height / 2
        signinButton.layer.borderWidth = 1
        signinButton.layer.borderColor = UIColor.black.cgColor
        signinButton.layer.shadowRadius = 1
        signinButton.layer.shadowOpacity = 1.0
        signinButton.layer.shadowOffset = CGSize(width: 1, height: 1)
        signinButton.layer.shadowColor = UIColor.yellow.cgColor
        
        
        //kayıt butonu şekillendirme
        signupButton.layer.cornerRadius = signinButton.frame.height / 2
        signupButton.layer.borderWidth = 1
        signupButton.layer.borderColor = UIColor.black.cgColor
        signupButton.layer.shadowRadius = 1
        signupButton.layer.shadowOpacity = 1.0
        signupButton.layer.shadowOffset = CGSize(width: 1, height: 1)
        signupButton.layer.shadowColor = UIColor.yellow.cgColor
        
        
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
        
        
        //forgot password?
        //tıklanabilir hale getirmek için
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(forgetLabelClicked(sender:)))
        
        //Kullanıcı etkileşimini etkinleştiriyoruz
        forgetLabel.isUserInteractionEnabled = true
        forgetLabel.addGestureRecognizer(tapGesture)
        
        
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "FingerprintIcon"), style: UIBarButtonItem.Style.done, target: self, action: #selector(signInWithFingerprint))

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        usernameText.text = ""
        passwordText.text = ""
    }
    
    //parmak izi ile giriş
    @objc func signInWithFingerprint () {
        
        //contex oluşturmak için
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        //veri tabanından bir şey getirme isteği oluşturur.hangi tabanında hangi entity e bağlandığı bilgisi alınır.
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        
        //giriş yapan kullanıcının information ları gerekiyor
        //fetchRequest.predicate = NSPredicate(format: "userId = %@", GlobalSettings.currentUserId.uuidString)
        //catche ile alakalı
        fetchRequest.returnsObjectsAsFaults = false
        
        
        do {
            //bu requesti kullanarak ilgili verileri getir diyoruz
            //bunu results değişkenine atıyoruz sebebi de çoğul data getirmesidir.
            let results = try context.fetch(fetchRequest)
            
            //veri geldi ise
            if results.count > 0 {
                //veri tabanından dönen nesnenin tipi
                for result in results as! [NSManagedObject] {
                
                    GlobalSettings.email = result.value(forKey: "email") as! String
                    
                }
                
            }  else {
                
                let alert = UIAlertController(title: "Error", message: "There is no user available. You must register first.", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default)
                alert.addAction(ok)
                self.present(alert, animated: true)
                
                return
            }
        
        } catch {
            
            print("error")
            
        }
        
        //doğrulama işlemleri için kullandığımız bir obje
        let authContext = LAContext()
        //authContext.localizedCancelTitle = "Enter Username/Password"
        
        //ikinokta üst üste kullandığım için opsiyonel yaptım
        var error : NSError?
        
        
        //yüz ya da parmak izi kullanacvağım için biometrik
        //biometrik kullanarak kullanıcının gerçekten kullanıcı olup oolmadığını anlamaya çalışıyoruz
        //bizim kullandığımız cihaz bunu değerlendirebiliyor ise aşağıdakileri yap.
        if authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"
            
            authContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [unowned self] success, authenticationError in
                
                DispatchQueue.main.async {
                    
                    if success {
                        
                        self.performSegue(withIdentifier: "toListVC", sender: nil)
                        
                    } else {
                        
                        let alert = UIAlertController(title: "Authentication failed", message: "Sorry!", preferredStyle: .alert)
                        let ok = UIAlertAction(title: "OK", style: .default)
                        alert.addAction(ok)
                        self.present(alert, animated: true)
                        
                    }
                }
            }
            
        } else {
            let alert = UIAlertController(title: "Touch ID not available", message: "Your device is not configured for Touch ID.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default)
            alert.addAction(ok)
            present(alert, animated: true)
        }
 }

    
    
    //ekranın sağ üst kısmında, buraya tıkladığımızdan
    @objc func addButtonClicked(){
        //detail view controlda if i yazarken chosenInformation u kullandık. bu yüzden burada da bu veriyi boş gönderdik.
        //selectedInformation = ""
        //ekranı değiştirmesini söylüyoruz
        performSegue(withIdentifier: "toDetailsVC", sender: nil)
        
        let vc = DetailsViewController()
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    //forgot password?
    @objc func forgetLabelClicked(sender: UITapGestureRecognizer) {
        
        //contex oluşturmak için
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
    
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchRequest.returnsObjectsAsFaults = false
        
        
        do {
            
            let results = try context.fetch(fetchRequest)
            
            //herhangi bir kullanıcı mevcut değil ise hata mesajı veriyoruz
            if results.count == 0 {
                
                let alert = UIAlertController(title: "Error", message: "There is no user available. You must register first.", preferredStyle: .alert)
                let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
                
            } else {
                
                performSegue(withIdentifier: "toRegisterVC", sender: nil)
                
            }
            
        } catch {
            
            print("error")
            
        }
    }
    
    
 
    @IBAction func signInButtonClicked(_ sender: Any) {
        
        username = usernameText.text
        password = passwordText.text
        
        
        if (username.isEmpty || password.isEmpty) {
            
            alertMessage(title: "Error", message: "Its Mandatort to enter all the fields.")
            //username password ü girmedi ise adam veritabanı sorgulamalarını hiç yapmasın
            return 
        }
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "email = %@", username!)
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let reusutls = try context.fetch(fetchRequest)
            
            if reusutls.count > 0 {
                
                for result in reusutls as! [NSManagedObject] {
                    
                    let passwordFromData = result.value(forKey: "password") as! String
                    let usernameFromData = result.value(forKey: "email") as! String
                    
                    if password! == passwordFromData {
                        
                        //girişidoğru yaptıktan sonra viewcontrollar da send buttonunda email değerini elimize alabilmemiz adına burada email değerini alıyoruz.
                        GlobalSettings.email = result.value(forKey: "email") as! String
                        
                        //giriş yapan kullanıcının id bilgisini elde ediyoruz
                        //let userId = result.value(forKey: "id") as? UUID
                        
                        //GlobalSettings.currentUserId = userId
                        
                        performSegue(withIdentifier: "toListVC", sender: nil)
                        
                    } else if (password != passwordFromData) {
                        
                        let alert = UIAlertController(title: "Error", message: "Password does not match.", preferredStyle: .alert
                            
                        )
                        
                        let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
                        
                        alert.addAction(ok)
                        
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                    
                } 
                
            } else {
                
                let alert = UIAlertController(title: "Error", message: "Username does not match.", preferredStyle: .alert)
                let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
                
                alert.addAction(ok)
                
                self.present(alert, animated: true, completion: nil)
            }
        }
            
        catch {
            
            let fetch_error = error as NSError
            print("error", fetch_error.localizedDescription)
            
        }
    }
    
    @IBAction func signUpButtonClicked(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchRequest.returnsObjectsAsFaults = false
        
        
        do {
            
            let results = try context.fetch(fetchRequest)
            
            //herhangi bir kullanıcı mevcut ise hata mesajı veriyoruz
            //değil ise kayıt olabilmesi için register ekranına yönlendiriyoruz
            if results.count != 0 {
                
                let alert = UIAlertController(title: "Error", message: "There is already a registered user in the system. Please login with your username and password.", preferredStyle: .alert)
                let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
                
            } else {
                
                performSegue(withIdentifier: "toRegisterVC", sender: nil)
                
            }
            
        } catch {
            
            print("error")
            
        }
    }
    
    
    func alertMessage (title : String, message : String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func hideKeyboard() {
        
        view.endEditing(true)
    }
    
}
