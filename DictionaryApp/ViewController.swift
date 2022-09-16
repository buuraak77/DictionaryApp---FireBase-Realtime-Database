//
//  ViewController.swift
//  DictionaryApp
//
//  Created by Burak Yılmaz on 11.09.2022.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import Firebase

      
class ViewController: UIViewController {
    
    var ref: DatabaseReference!
    var words = [Words]()
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.delegate = self
        tableView.dataSource = self
        ref = Database.database().reference()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewWord))
        
        getAllWords()
        
    }
    

    
    func getAllWords() {
        
        ref.child("kelimeler").observe(.value) { DataSnapshot in
            if let gelenVeriButunu = DataSnapshot.value as? [String:AnyObject] {
                self.words.removeAll()
                
                for gelenSatırVerisi in gelenVeriButunu {
                    if let dict = gelenSatırVerisi.value as? NSDictionary {
                        let key = gelenSatırVerisi.key
                        let turkce = dict["turkce"] as? String ?? ""
                        let inngilizce = dict["ingilizce"] as? String ?? ""
                        let kelime = Words(kelime_id: key, ingilizce: inngilizce, turkce: turkce)
                        self.words.append(kelime)
                    }
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    @objc func addNewWord() {
        
        let alert = UIAlertController(title: "Add New Word", message: nil, preferredStyle: .alert)
        alert.addTextField{ (textField) in
            textField.placeholder = "İngilizce"
        }
        alert.addTextField{ (textField) in
            textField.placeholder = "Türkçe"
        }
        let ok = UIAlertAction(title: "Add", style: .default) { UIAlertAction in
            if let english = alert.textFields![0].text, let trk = alert.textFields![1].text {
                self.addNewData(eng: english, tr: trk)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        alert.addAction(ok)
        present(alert, animated: true)
        
    }
    
    func addNewData(eng:String,tr:String) {
        
        let dict:[String:Any] = ["kelime_id":"","ingilizce":eng,"turkce":tr]
        let newRef = ref.child("kelimeler").childByAutoId()
        newRef.setValue(dict)
    }
    
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return words.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! WordCell
        cell.Label1.text = words[indexPath.row].ingilizce
        cell.label2.text = words[indexPath.row].turkce
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var alertWord = words[indexPath.row]
        
        let alert = UIAlertController(title: "\(alertWord.ingilizce!)", message: "İngilizce: \(alertWord.ingilizce!)\nTürkçe: \(alertWord.turkce!)", preferredStyle: .actionSheet)
        let ok = UIAlertAction(title: "OK", style: .default)
        alert.addAction(ok)
        present(alert, animated: true)
        
        
    }
    
    
    
}

