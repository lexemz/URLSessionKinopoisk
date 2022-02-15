//
//  TableViewController.swift
//  URLSessionKinopoisk
//
//  Created by Igor on 02.02.2022.
//

import UIKit

class SearchFilmsTableViewController: UITableViewController {
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var seatchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    
    private var films: [Film] = []
    var filmFromTextfield: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 150
        
        firstRequest()
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Type anything"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func firstRequest() {
        guard let filmFromTextfield = filmFromTextfield, filmFromTextfield != "" else {
            return
        }
        searchController.searchBar.text = filmFromTextfield

        fetchData(filmName: filmFromTextfield)
    }
    
    private func fetchData(filmName: String) {

        KinopoiskFilmsManager.shared.findFilmsWithDistributionInfo(name: filmName) { films in
            self.films = films
            self.tableView.reloadData()
        } faulireHandler: {
            print("Data is empty")
        }
    }
    
    @IBAction func dismissViewController(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    deinit {
        print("VC is closed")
    }
}

// MARK: - Table view delegate
extension SearchFilmsTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dump(films[indexPath.row])
    }
}
 
// MARK: - Table view data source
extension SearchFilmsTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        films.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        let filmForCell = films[indexPath.row]
        
        switch filmForCell.nameRu {
            
        case .none:
            content.text = filmForCell.nameEn
        case .some(let nameRU):
            content.text = nameRU
        }

        content.secondaryText = filmForCell.releases.reduce("") { partialResult, release in
            guard let string = partialResult else { return partialResult }
            var returnderString = string
            returnderString += "\(release.country ?? "NULL"): \(release.date ?? "Неизвестно") \n"
            
            return returnderString
        }
        
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

extension SearchFilmsTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        fetchData(filmName: searchController.searchBar.text ?? "")
    }
}
