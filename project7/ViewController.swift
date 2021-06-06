//
//  ViewController.swift
//  project7
//
//  Created by Ярослав on 3/30/21.
//

import UIKit

class ViewController: UITableViewController {

    var petitions       = [Petition]()
    var preferedArticle = [Petition]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showTextField))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(removeSearch))
        
        let urlString: String
            
        if navigationController?.tabBarItem.tag == 0{
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        }else{
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        DispatchQueue.global().async { [weak self] in
            if let url = URL(string: urlString){
                if let data = try? Data(contentsOf: url){
                    //we are ok to load data
                    self?.parse(json: data)
                    return
                }
            } else {
                DispatchQueue.main.async {
                    self?.showError()
                }
            }
        }
    }
    
    @objc func removeSearch(){
        preferedArticle.removeAll()
        tableView.reloadData()
    }
    
    @objc func showTextField(){
        let ac = UIAlertController(title: "Enter serched words", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Search", style: .default){[weak ac,weak self] _ in
            guard let searchingString = ac?.textFields?[0].text else{ return }
            self?.createPreferedArticle(string: searchingString)
            self?.tableView.reloadData()
        })
        present(ac, animated: true)
    }
    
    func createPreferedArticle(string: String){
        
        let string = string.lowercased()
        
        preferedArticle.removeAll()
        
        guard string.count > 3 else {
            showCastomizedError(title: "Error", massage: "You searck reques must contains at least 4 letters")
            return
        }
        
        for petition in petitions{
            if petition.title.lowercased().contains(string) || petition.body.lowercased().contains(string){
                preferedArticle.append(petition)
            }
        }
       
    
        
    }
    
    func showCastomizedError(title: String, massage: String?){
        let ac = UIAlertController(title: title, message: massage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func showError(){
        let ac = UIAlertController(title: "Loading Error", message: "Please, check your internet connection and try again", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func parse(json: Data){
        let decoder = JSONDecoder()
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json){
            DispatchQueue.main.async { [weak self] in
                self?.petitions = jsonPetitions.results
                self?.tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if preferedArticle.isEmpty{
            return petitions.count
        }else{
            return preferedArticle.count
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = "\(preferedArticle.isEmpty ? petitions[indexPath.row].title : preferedArticle[indexPath.row].title )"
        cell.detailTextLabel?.text = "\(preferedArticle.isEmpty ? petitions[indexPath.row].signatureCount : preferedArticle[indexPath.row].signatureCount)"
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = preferedArticle.isEmpty ? petitions[indexPath.row] : preferedArticle[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    

    
}

