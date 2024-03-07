//
//  ListViewController.swift
//  TravelBook
//
//  Created by Aleyna Yerlikaya on 3.03.2024.
//

import UIKit
import CoreData

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var titleArray = [String]()
    var idArray = [UUID]()
    
    var chosenTitle=""
    var chosenTitleId : UUID?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonClicked)) //en üstte artı butonu olsun ve buton diğer sayfaya geçsin(diğer sayfaya geçmesini sağlayan addButtonClicked fonksiyonu)

        tableView.delegate = self
        tableView.dataSource = self
        
        getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name("newPlace"), object: nil)
    }
    
    @objc func getData(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Places") //veritabanı ile bağlantı kurduk
        request.returnsObjectsAsFaults = false
        
        do{
         let results = try context.fetch(request) //context içindeki verileri results a attık
            if results.count > 0 { //eğer results 0dan büyükse yani veri varsa
                
                self.titleArray.removeAll(keepingCapacity: false)
                self.idArray.removeAll(keepingCapacity: false)
                
                for result in results as! [NSManagedObject] { //coredata metodlarına ulaşmayı sağlıyor
                    if let title = result.value(forKey: "title") as? String {
                        self.titleArray.append(title)
                    }
                    if let id = result.value(forKey: "id") as? UUID {
                        self.idArray.append(id)
                    }
                    tableView.reloadData()
                }
            }
        }catch{
            print("error")
        }
    }
    
    @objc func addButtonClicked(){
        chosenTitle="" //harita kısmını açıp boş gösterecek
        performSegue(withIdentifier: "toViewController", sender: nil) //artıya tıklayınca gideceği ekranı belirttik
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = titleArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { //tableviewde seçip harita kısmını açıp dolu gösterecek
        chosenTitle = titleArray[indexPath.row] //seçilen index atanacak
        chosenTitleId = idArray[indexPath.row]
        performSegue(withIdentifier: "toViewController", sender: nil) //vc sayfasına gönderecek
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toViewController" {
            let destinaionVC = segue.destination as! ViewController
            destinaionVC.selectedTitle = chosenTitle
            destinaionVC.selectedTitleID = chosenTitleId
        }
    }
    

    

}
