//
//  SearchingViewController.swift
//  ShowSearch
//
//  Created by Markim Shaw on 9/17/16.
//  Copyright © 2016 Markim Shaw. All rights reserved.
//

import UIKit
import Messages

class SearchingViewController: UIViewController{
    
    let reuseIdentifier = "SearchResultsCell"

    
    @IBOutlet weak var _tableView: UITableView!
    @IBOutlet weak var _dimView: UIView!
    @IBOutlet weak var _searchBar: UISearchBar!
    
    var model:ViewModel!
    weak var messagesViewController:MSMessagesAppViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model = ViewModel(delegate: self)
        self._tableView.keyboardDismissMode = .onDrag
        self._tableView.contentInset = UIEdgeInsetsMake(-80, 0, 0, 0)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.isNavigationBarHidden = true

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "to_ShowResultsViewController" {
            if let cell = sender as? SearchingTableViewCell {
                let indexPath = self._tableView.indexPath(for: cell)
                if let data = self.model.data {
                    let destination = segue.destination as! ShowResultsViewController
                    destination.delegate = messagesViewController as! ShowControllerDelegate
                    destination.selectedShow = data[indexPath!.row]
                    //destination.selectedTVShow = data[indexPath!.row]
                }
                
            }
        }
            
    }
    
}

extension SearchingViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.model.clearSearchData()
        self._tableView.reloadData()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        self._tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.performSegue(withIdentifier: "to_ShowResultsViewController", sender: self)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            self.model.clearSearchData()
            self._tableView.reloadData()
        } else {
            self.model.clearSearchData()
            let api_call = ShowAPI(url: "http://api.tvmaze.com/search/shows?", params: ["q":searchBar.text!], delegate: model)
            api_call.request()
        }
        
    }
}

extension SearchingViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultsCell", for: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = self.model.data?.count else { return 0 }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseIdentifier, for: indexPath) as! SearchingTableViewCell
        
        guard let modelData = self.model.data , modelData.count != 0 else { return cell }
        cell.showTitle.text = modelData[indexPath.row].value.name
        
        return cell
    }
}

extension SearchingViewController : ViewModelDelegate {
    func reloadData(){
        self._tableView.reloadData()
    }
}
