//
//  SearchViewController.swift
//  The Movie Database
//
//  Created by Marcelo Cotrim on 03/01/17.
//  Copyright © 2017 Marcelo Cotrim. All rights reserved.
//

import UIKit

class SearchViewController: UITableViewController, UISearchBarDelegate {
    
    fileprivate var page: NSInteger!
    fileprivate var totalPages: NSInteger!
    fileprivate var items: [Movie]!
    fileprivate var isLoading: Bool!
    fileprivate var activityView: UIActivityIndicatorView!
    fileprivate var searchBar: UISearchBar!
    
    //view controller initialization
    init() {
        super.init(style: .grouped)
        page = 1
        totalPages = 0
        items = [Movie]()
        isLoading = false
        activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //layout of view and subviews
        self.layout()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //layout of view and subviews
    func layout() {
        view.backgroundColor = .background()
        
        tableView.addSubview(activityView)
        tableView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        tableView.separatorStyle = .none
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: "cell")

        //to hide lines
        tableView.tableFooterView = UIView()
        navigationItem.titleView = searchBar
        
        activityView.color = .green()
        
        let textField = self.searchBar.value(forKey: "searchField") as? UITextField
        textField?.font = UIFont.systemFont(ofSize: 14)
        textField?.tintColor = .green()
        textField!.setValue(UIColor.lightGray, forKeyPath: "_placeholderLabel.textColor")
        textField!.backgroundColor = .white
        
        self.searchBar.barTintColor = .white
        self.searchBar.tintColor = .white
        self.searchBar.placeholder = "Search"
        self.searchBar.delegate = self
        self.searchBar.autocapitalizationType = .none
    }
    
    //load movie results
    func load(_ reload: Bool) {
        if !isLoading {
            isLoading = true
            if page == 1 {
                activityView.center = CGPoint(x: view.center.x, y: view.center.y - 64)
            } else {
                activityView.center = CGPoint(x: view.center.x, y: view.bounds.height)
            }
            activityView.startAnimating()
            App.shared.searchMovies(searchBar.text!, page) { (movies, totalPages, error) in
                if movies != nil && totalPages! >= self.page {
                    self.totalPages = totalPages!
                    self.page = self.page + 1
                    if reload {
                        self.items.removeAll()
                    }
                    self.items.append(contentsOf: movies!)
                    self.tableView!.reloadData()
                }
                self.activityView.stopAnimating()
                self.isLoading = false
            }
        }
    }
    
    //tableview header section height
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    //tableview footer section height
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    //tableview section view
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel(frame: CGRect(x: 15, y: 0, width: UIScreen.main.bounds.width - 30, height: 30))
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.text = "Movie Results"
        
        let header = UIView()
        header.addSubview(label)
        return header
    }
    
    //tableview row height
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MovieTableViewCell.height()
    }
    
    //tableview number of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //tableview number of rows in section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    //tableview cell for row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //paging control
        if indexPath.item >= items.count - 5 && page <= totalPages && isLoading == false {
            self.load(false)
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MovieTableViewCell
        cell.layout(items[indexPath.row])
        return cell
    }
    
    //tableview row selection
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.pushViewController(DetailViewController(items[indexPath.row]), animated: true)
    }
    
    //searchbar text change
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.characters.count == 0 {
            items.removeAll()
            tableView.reloadData()
        } else {
            search()
        }
    }
    
    //searchbar search button action
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        search()
    }
    
    //new search
    func search() {
        page = 1
        load(true)
    }
}
