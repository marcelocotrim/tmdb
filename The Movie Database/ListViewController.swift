//
//  ListViewController.swift
//  The Movie Database
//
//  Created by Marcelo Cotrim on 02/01/17.
//  Copyright © 2017 Marcelo Cotrim. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController {
    
    fileprivate var page: NSInteger!
    fileprivate var totalPages: NSInteger!
    fileprivate var items: [Movie]!
    fileprivate var isLoading: Bool!
    fileprivate var activityView: UIActivityIndicatorView!
    
    //view controller initialization
    init() {
        super.init(style: .grouped)
        page = 1
        totalPages = 0
        items = [Movie]()
        isLoading = false
        activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //load genres
        activityView.startAnimating()
        App.shared.genres { (error) in
            if error == nil {
                //load upcoming movies
                self.load()
            } else {
                self.activityView.stopAnimating()
            }
        }
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

        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
        tableView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        tableView.separatorStyle = .none
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: "cell")
        
        //to hide lines
        tableView.tableFooterView = UIView()
        tableView.addSubview(activityView)
        
        navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "logo"))
        navigationItem.rightBarButtonItems = [UIBarButtonItem.space(-5), UIBarButtonItem.search(target: self, action: #selector(tapSearchButton))]

        activityView.center = CGPoint(x: view.center.x, y: view.center.y - 64)
        activityView.color = .green()
    }
    
    //load upcoming movies
    func load() {
        if !isLoading {
            isLoading = true
            activityView.startAnimating()
            if page == 1 {
                activityView.center = CGPoint(x: view.center.x, y: view.center.y - 64)
            } else {
                activityView.center = CGPoint(x: view.center.x, y: view.bounds.height)
            }
            App.shared.upcomingMovies(page) { (movies, totalPages, error) in
                if movies != nil && totalPages! >= self.page {
                    self.totalPages = totalPages!
                    self.page = self.page + 1
                    self.items.append(contentsOf: movies!)
                    self.tableView!.reloadData()
                }
                self.activityView.stopAnimating()
                self.refreshControl?.endRefreshing()
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
        label.text = "Upcoming Movies"
        
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
            self.load()
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MovieTableViewCell
        cell.layout(items[indexPath.row])
        return cell
    }
    
    //tableview row selection
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.pushViewController(DetailViewController(items[indexPath.row]), animated: true)
    }
    
    //search button action
    func tapSearchButton() {
        navigationController?.pushViewController(SearchViewController(), animated: true)
    }
    
    //refresh action
    func refresh() {
        page = 1
        items.removeAll()
        load()
    }
}

