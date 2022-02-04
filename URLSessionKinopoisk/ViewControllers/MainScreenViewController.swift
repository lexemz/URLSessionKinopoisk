//
//  MainScreenViewController.swift
//  URLSessionKinopoisk
//
//  Created by Igor on 04.02.2022.
//

import UIKit

class MainScreenViewController: UIViewController {
    
    @IBOutlet var mainTextField: UITextField!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navigationController = segue.destination as? UINavigationController else { return }
        guard let findFilmVC = navigationController.topViewController as? SearchFilmsTableViewController else { return }
        
        findFilmVC.filmFromTextfield = mainTextField.text
    }

}
