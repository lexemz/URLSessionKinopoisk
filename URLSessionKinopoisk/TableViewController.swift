//
//  TableViewController.swift
//  URLSessionKinopoisk
//
//  Created by Igor on 02.02.2022.
//

import UIKit

class TableViewController: UITableViewController {
    
    var films: [Film] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 150
        
        let url = "https://kinopoiskapiunofficial.tech/api/v2.1/films/search-by-keyword?keyword=spider%20man&page=1"
        NetworkManager.shared.fetchFilms(from: url) { result in
            switch result {
                
            case .success(let films):
                self.films = films.films
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        films.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        let filmForCell = films[indexPath.row]
        
        content.text = filmForCell.nameRu
        content.secondaryText = filmForCell.nameEn
        content.imageProperties.cornerRadius = 10
        
        DispatchQueue.global().async {
            let dataForImage = NetworkManager.shared.fetchImage(from: filmForCell.posterUrlPreview) ?? Data()
            
            DispatchQueue.main.async {
                content.image = UIImage(data: dataForImage)
                cell.contentConfiguration = content
            }
        }
        
        cell.contentConfiguration = content
        return cell
    }


}
