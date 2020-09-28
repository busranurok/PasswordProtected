//
//  ViewController.swift
//  PasswordProtector
//
//  Created by Yeni Kullanıcı on 31.08.2020.
//  Copyright © 2020 Busra Nur OK. All rights reserved.
//

import UIKit
//context işlemleri için
import CoreData
//send email attachment
import MessageUI

//uıtableviewdelegate ve uıtableviewdatasource tableview işlemleri için gerekli
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    //site isim ve idlerinin listesi oluşturulur.
    //tableview array ile çalıştığı için array oluşturuyoruz
    //sadece id yazmamamızın sebebi listeleme ekranına isim de basmak istememizdir
    var siteNameArray = [String]()
    var idArray = [UUID]()
    //var messageArray = [String]()
    var stringMessage : String = ""
    var passwordArray = [Password]()
    //update table
    var currentPasswordArray = [Password]()
    
    
    //listelerme ekranında bir cell e tıkladığımızdaki veriyi elimize alıp detay ekranına göndermek istediğimizdendir.
    var selectedInformation = ""
    var selectedInformationId : UUID?
    
    
    var colorArray = [UIColor]()
    
    var message = ""
    var siteName = ""
    //var categoryName = ""
    
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        //tableview
        tableView.delegate = self
        tableView.dataSource = self
        
        //tableview cell lerini renklendirmek için
        /*self.colorArray = [
            UIColor(red: 68/255, green: 90/255, blue: 180/255, alpha: 1.0),
            UIColor(red: 75/255, green: 57/255, blue: 170/255, alpha: 1.0),
            UIColor(red: 68/255, green: 90/255, blue: 180/255, alpha: 1.0),
            UIColor(red: 75/255, green: 57/255, blue: 170/255, alpha: 1.0),
            UIColor(red: 68/255, green: 90/255, blue: 180/255, alpha: 1.0),
            UIColor(red: 75/255, green: 57/255, blue: 170/255, alpha: 1.0)
        ]*/
        
       
        
        //Ek çubuk düğmesi öğeleri
        let plusImage   = UIImage(named: "PlusIcon")
        
        let sendImage = UIImage(named: "SendIcon")

        let plusButton   = UIBarButtonItem(image: plusImage,  style: .plain, target: self, action:#selector(didTapPlusButton))
        let sendButton = UIBarButtonItem(image: sendImage, style: .plain, target: self, action: #selector(didTapSendButton))
       
        navigationItem.rightBarButtonItems = [plusButton, sendButton]
        
        
      /*self.navigationItem.rightBarButtonItem =  UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonClicked))*/
        
        //program ilk yüklendiğinde bu fonksiyon bir kez çağırılır
        getData()
        
        setUpSearchBar()
        alterLayout()
        
    }
    
    
    //o ekran her yüklendiğinde çağırılır
    override func viewWillAppear(_ animated: Bool) {
        //programın herhangi bir yerinde newData isminde bir bildiri notification yollanmış mı eğer yollandı ise getdata fonksiyonu çalıuştırılsın.
        //detail ekranında yeni veri eklenince getdata fonksiyonu çalışcak böylece viewcontrolurdaki liste yenilenmiş olur
        //addObserver gözcü. Bayrak gözlüyor.
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name(rawValue: "newData"), object: nil)
        
        
        fetchInformations()
        
    }
    
    
    //verileri çekme işlemi
    @objc func getData() {
        //ekran dolu ise aynı site isimlerini 2. defa göstermesinin önüne geçmek
        //kayıt yaptığında listeye tekrar önceden eklediğimiz geliyor sonra onun üzerine yeniden önceden eklediklerimiz ile beraber yeni eklediğimizi basıyor.iki defa diğer veriler olmuş oluyor.bunun önüne geçmek için listeyi önce bir temizliyoruz!
        siteNameArray.removeAll(keepingCapacity: false)
        idArray.removeAll(keepingCapacity: false)
        passwordArray.removeAll(keepingCapacity: false)
        
        
        //contex oluşturmak için
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        //veri tabanından bir şey getirme isteği oluşturur.hangi tabanında hangi entity e bağlandığı bilgisi alınır.
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Information")
        
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
                
                    var siteNameStr : String = ""
                    if let siteName = result.value(forKey: "siteName") as? String {
                        //sitenamearray ine aldığımız veriyi doldur
                        self.siteNameArray.append(siteName)
                        siteNameStr = siteName
                    }
                    
                    //tıklandığında bu id li data demek için, diğer tarafa göndermek için bunıu alıyoruz
                    if let id = result.value(forKey: "id") as? UUID {
                        self.idArray.append(id)
                    }
                    
                    let categoryName = result.value(forKey: "category") as? String
                    
                    switch categoryName {
                        
                    case "Bank":
                        passwordArray.append(Password(siteName: siteNameStr, category: PasswordType(rawValue: categoryName!)!, image: "BankIcon"))
                        
                    case "Shopping":
                        passwordArray.append(Password(siteName: siteNameStr, category: PasswordType(rawValue: categoryName!)!, image: "ShoppingIcon"))
                        
                    case "Mail":
                        passwordArray.append(Password(siteName: siteNameStr, category: PasswordType(rawValue: categoryName!)!, image: "MailIcon"))
                        
                    case "Shopping":
                        passwordArray.append(Password(siteName: siteNameStr, category: PasswordType(rawValue: categoryName!)!, image: "ShoppingIcon"))
                        
                    case "Others":
                        passwordArray.append(Password(siteName: siteNameStr, category: PasswordType(rawValue: categoryName!)!, image: "OthersIcon"))
                        
                    default:
                        break
                    }
                    //currentPasswordArray.append(Password(siteName: siteName, category: category, image: .ba))
                }
                
                currentPasswordArray = passwordArray
                
                //tableview in içeriğinde değişiklik oluşturduğumuz için ekranı yenileme işlemi gerçekleştiriryoruz.
                self.tableView.reloadData()
                
            }
            
            
        } catch {
            print("error")
        }
        
    }
    
    
    
    
    //ekranın sağ üst kısmında, buraya tıkladığımızdan
    /*@objc func addButtonClicked(){
        //detail view controlda if i yazarken chosenInformation u kullandık. bu yüzden burada da bu veriyi boş gönderdik.
        selectedInformation = ""
        //ekranı değiştirmesini söylüyoruz
        performSegue(withIdentifier: "toDetailsVC", sender: nil)
        
    }*/
    
    
    
    //searchbar
    private func setUpSearchBar() {
        
        searchBar.delegate = self
        
    }
    
    
    
    private func alterLayout() {
        searchBar.placeholder = "Search by sitename"
    }
    
    
    //Table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentPasswordArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? TableViewCell
        //listede sadece sitenin adını görmek istediğimiz için bunu yazdık eğer password falan görmek istese idik onları da yazmamız gerekirdi
        cell?.siteNameLabel.text = currentPasswordArray[indexPath.row].siteName
        cell?.categoryLabel.text = currentPasswordArray[indexPath.row].category.rawValue
        cell?.imageView?.image = UIImage(named: currentPasswordArray[indexPath.row].image)
        cell?.imageView?.layer.cornerRadius = 50
        cell?.imageView?.layer.borderWidth = 1
        cell?.imageView?.layer.borderColor = UIColor.black.cgColor
        cell?.imageView?.layer.shadowRadius = 3
        cell?.imageView?.layer.shadowOpacity = 1.0
        cell?.imageView?.layer.shadowOffset = CGSize(width: 3, height: 3)
        cell?.imageView?.layer.shadowColor = UIColor.yellow.cgColor
        cell?.contentView.layer.cornerRadius = 5
        cell?.contentView.layer.masksToBounds = true
       
        return cell!
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
    
    //Search Bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    
            currentPasswordArray = passwordArray.filter({ password -> Bool in
                
                switch searchBar.selectedScopeButtonIndex {
                case 0:
                    if searchText.isEmpty { return true }
                    return password.siteName.lowercased().contains(searchText.lowercased())
                case 1:
                    if searchText.isEmpty { return password.category == .bank }
                    return password.siteName.lowercased().contains(searchText.lowercased()) && password.category == .bank
                case 2:
                    if searchText.isEmpty { return password.category == .mail }
                    return password.siteName.lowercased().contains(searchText.lowercased()) && password.category == .mail
                case 3:
                    if searchText.isEmpty { return password.category == .shopping }
                    return password.siteName.lowercased().contains(searchText.lowercased()) && password.category == .shopping
                case 4:
                    if searchText.isEmpty { return password.category == .others }
                    return password.siteName.lowercased().contains(searchText.lowercased()) && password.category == .others
                default:
                    return false
                }
            })

        tableView.reloadData()
        
    }
    
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        switch selectedScope {
        case 0:
            currentPasswordArray = passwordArray
            
        case 1:
            currentPasswordArray = passwordArray.filter({ password -> Bool in
                password.category == PasswordType.bank
            })
            
        case 2:
            currentPasswordArray = passwordArray.filter({ password -> Bool in
                password.category == PasswordType.mail
            })
            
        case 3:
            currentPasswordArray = passwordArray.filter({ password -> Bool in
                password.category == PasswordType.shopping
            })
        
        case 4:
            currentPasswordArray = passwordArray.filter({ password -> Bool in
                password.category == PasswordType.others
            })
        default:
            break
        }
        
        tableView.reloadData()
    }
    
    
    
    
    //ekranın sağ üst kısmında, buraya tıkladığımızda
    @objc func didTapPlusButton(sender: AnyObject){
        //detail view controlda if i yazarken chosenInformation u kullandık. bu yüzden burada da bu veriyi boş gönderdik.
        selectedInformation = ""
        //ekranı değiştirmesini söylüyoruz
        performSegue(withIdentifier: "toDetailsVC", sender: nil)
    }
    
    
    //Mail Send Button
    @objc func didTapSendButton(sender: AnyObject){
        
        if MFMailComposeViewController.canSendMail() {
            
            //contex oluşturmak için
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            //veri tabanından bir şey getirme isteği oluşturur.hangi tabanında hangi entity e bağlandığı bilgisi alınır.
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Information")
            
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
                        
                        let siteName = result.value(forKey: "siteName") as! String
                        let username = result.value(forKey: "username") as! String
                        let password = result.value(forKey: "password") as! String
                        
                        message = "Site Name: \(siteName) , " +  "Username :  \(username) , " + "Password : \(password)"
                        
                        //messageArray.append(message)
                        stringMessage += message + "\n\n"
                        
                        }
                    
                    }
                    
                } catch {
                    
                print("error")
                    
            }
            
            let emailComposer = MFMailComposeViewController()
            emailComposer.mailComposeDelegate = self
            emailComposer.setToRecipients([GlobalSettings.email])
            emailComposer.setSubject("My Informations")
            //emailComposer.setMessageBody("\n \n My Registration Information : \n \n \(messageArray)", isHTML: false)
            emailComposer.setMessageBody("My Registered Information:  \n\n" + stringMessage + "\n", isHTML: false)
            self.present(emailComposer, animated: true, completion: nil)
            
        
        } else {
            
            print("Email is not configured in setting app or we are nor able to send an email")
            
        }
        
    }
    
        
        //MailComposerDelegate
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            
            if let _ = error {
                controller.dismiss(animated: true)
            }
            
            switch result {
                
            case .cancelled:
                print("User cancelled.")
                break
                
            case .saved:
                print("Mail is saved by user.")
                break
                
            case .sent:
                print("Mail is sent succesfully.")
                break
                
            case .failed:
                print("Sending mail is failed.")
                break
                
            default:
                break
            }
            
            controller.dismiss(animated: true)
        }
  
    
    
    //başka ekrana geçmeden önce burası çalışıyor
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //eğer geçeceği yer toDetailVC ise
        if segue.identifier == "toDetailsVC" {
            let destinationVC = segue.destination as! DetailsViewController
            //veri gönderme işlemi yapılıyor.
            //detailviewcontroller daki chosenInformation buradaki selectionInformation a eşitleniyor.
            destinationVC.chosenInformation = selectedInformation
            destinationVC.chosenInformationId = selectedInformationId
        }
    }
    
    
    //sağ üsteki artı butonuna tıklamak yerine listeleme kısmındaki veriye tıkladığında toDetailVC ye git diyoruz
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedInformation = siteNameArray[indexPath.row]
        selectedInformationId = idArray[indexPath.row]
        performSegue(withIdentifier: "toDetailsVC", sender: nil)
    }
    
    
    //veri silme işlemi gerçekleştiriyoruz
    /*
     veri silerken şu adımlar dikkate alınır:
     Veritabanından itemi silme
     Array’ den objeyi çıkarma
     listeden o hücreyi çıkarma
     listeyi yenileme
   */
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let alert = UIAlertController(title: "Error", message: "Are you sure you want to delete?", preferredStyle: .alert)
            
            //buton oluşturma
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context = appDelegate.persistentContainer.viewContext
                
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Information")
                
                //bunu yazmamızdaki sebep where koşulundaki id yi string olarak eklemek
                //burada where koşulu NSPredicate, bu bizden string bir veri istiyor
                let idString = self.idArray[indexPath.row].uuidString
                
                fetchRequest.predicate = NSPredicate(format: "id = %@", idString)
                
                fetchRequest.returnsObjectsAsFaults = false
                
                do {
                    let results = try context.fetch(fetchRequest)
                    if results.count > 0 {
                        
                        //results[0].value()
                        
                        for result in results as! [NSManagedObject] {
                            
                            if let id = result.value(forKey: "id") as? UUID {
                                
                                if id == self.idArray[indexPath.row] {
                                    //veritabanından silme işlemi
                                    context.delete(result)
                                    //arraylerdan objeyi çıkartma işlemi
                                    self.siteNameArray.remove(at: indexPath.row)
                                    self.currentPasswordArray.remove(at: indexPath.row)
                                    self.idArray.remove(at: indexPath.row)
                                    //listeden o hücreyi çıkarma işlemi
                                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                                    //liste yenileme işlemi
                                    self.tableView.reloadData()
                                    
                                    do {
                                        try context.save()
                                        print("success")
                                    } catch {
                                        print("error")
                                    }
                                    
                                    //bir tane veriyi bulup sileceği için tekrar for loop un içerisine girmesin diye break yazarız
                                    break
                                    
                                }
                                
                            }
                            
                            
                        }
                        
                        
                    }
                } catch {
                    print("error")
                }
                
            }))
            
            
            alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action) in
                print("No")
            }))
            
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    
    
    //INFORMATİON GÜNCELLEME İŞLEMİ
    func fetchInformations () {
        
        idArray.removeAll(keepingCapacity: false)
        
        
        //contex oluşturmak için
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        //veri tabanından bir şey getirme isteği oluşturur.hangi tabanında hangi entity e bağlandığı bilgisi alınır.
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Information")
        
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
                    
                    //tıklandığında bu id li data demek için, diğer tarafa göndermek için bunıu alıyoruz
                    if let id = result.value(forKey: "id") as? UUID {
                        self.idArray.append(id)
                    }
                }
                
                //tableview in içeriğinde değişiklik oluşturduğumuz için ekranı yenileme işlemi gerçekleştiriryoruz.
                self.tableView.reloadData()
                
            }
        
        } catch let error {
            
            print(error.localizedDescription)
            
        }
        
    }
    
    
    //listemizin kaydırılacağını belirtiyoruz
    func tableView(_ tableView: UITableView,
                   canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    //sağa kaydırıldığında solda duracak aksiyonu gösterir
    //önce update ediliyor sonrasında listenin yenileme işlemi gerçekleştiriliyor
    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let update = UIContextualAction(style: .normal, title: "Update") { (action, UIView, (Bool) -> Void) in
            self.selectedInformation = "Update"
            self.selectedInformationId = self.idArray[indexPath.row]
            self.updateInformation(listInformation: self.idArray[indexPath.row])
            self.fetchInformations()
            self.tableView.reloadData()
        }
        
        
        //update.backgroundColor = UIColor(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        update.backgroundColor = #colorLiteral(red: 0.1503280362, green: 1, blue: 0.05965251515, alpha: 1)
        //update.image = UIImage(named: "edit")
        return UISwipeActionsConfiguration(actions: [update])
    }
    
    
    
    //listInformation : Information listesine ekleyeceğimiz yeni ürünün UUID değerinde.
    func updateInformation(listInformation : UUID) {
        
        performSegue(withIdentifier: "toDetailsVC", sender: nil)
        
    }

}


//tableview data
class Password {
    let siteName : String
    let image : String
    let category : PasswordType
    
    init(siteName : String, category : PasswordType, image : String) {
        
        self.siteName = siteName
        self.category = category
        self.image = image
    }
}



enum PasswordType: String {
    
    case bank = "Bank"
    case mail = "Mail"
    case shopping = "Shopping"
    case others = "Others"
}
