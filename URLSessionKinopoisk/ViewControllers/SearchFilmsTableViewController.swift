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
        // TODO: Make custom cell with the same imageView size
        
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
        KinopoiskFilmsManager.shared.findFilmsWithDistributionInfo(name: filmName) { result in
            switch result {

            case .success(let films):
                self.films = films
                self.tableView.reloadData()
            case .failure(let error):
                Logger.error(error)
                self.films = []
                self.tableView.reloadData()
                
                // TODO: Error Alert
            }
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
        Logger.dumpData(films[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
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
        
        if let name = filmForCell.nameRu {
            content.text = name
        } else {
            content.text = filmForCell.nameEn
        }

        content.secondaryText = filmForCell.releases.reduce("") { partialResult, release in
            guard let string = partialResult else { return partialResult }
            var returnderString = string
            returnderString += "\(release.country ?? "NULL"): \(release.date ?? "????????????????????") \n"
            
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
        if searchController.searchBar.text == "" {
            films = []
        }
        
        fetchData(filmName: searchController.searchBar.text ?? "")
    }
}
