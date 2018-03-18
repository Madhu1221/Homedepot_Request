//
//  ViewController.swift
//  HomeDepot
//
//  Created by Madhu on 3/16/18.
//  Copyright © 2018 Madhu. All rights reserved.
//

import UIKit

enum DisplayMode:Int{
    case grid
    case list
}

class ViewController: UIViewController, UISearchBarDelegate{
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    // Grid and List show and hide based on the segment
    var displayMode:DisplayMode = .grid{
        didSet{
            if displayMode == .grid{
                self.collectionView.isHidden = false
                self.tableView.isHidden = true
            }else{
                self.collectionView.isHidden = true
                self.tableView.isHidden = false
            }
        }
    }
    
    var responseArray = [DataModel]()
    var searchString = ""
    var loadedPageNumber : Int = 1
    var loadingData : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 130.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        // Do any additional setup after loading the view, typically from a nib.
        self.displayMode = .grid
        self.collectionView.collectionViewLayout = DataFlowLayout()
        NotificationCenter.default.addObserver(self, selector: #selector(self.adjustScreenSize), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.adjustScreenSize()
        self.containerView.addSubview(self.tableView)
        self.containerView.addSubview(self.collectionView)
        self.collectionView.backgroundColor = .clear
        self.containerView.bringSubview(toFront: self.activityIndicator)
    }
    
    @objc func adjustScreenSize() {
        self.tableView.frame = self.containerView.bounds
        self.collectionView.frame = self.containerView.bounds
        self.view.layoutSubviews()
        if self.displayMode == .grid{
            self.collectionView.reloadData()
        }
    }
    
    //Searchbar delegate methods
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        if let searchStr = searchBar.text{
            if searchStr != "" {
                self.searchString = searchStr
                self.loadingData = true
                self.retriveAPIData(searchString: searchStr, pageNumber: "1")
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if self.responseArray.count > 0 && searchBar.text == ""{
            self.responseArray.removeAll()
            self.collectionView.reloadData()
            self.tableView.reloadData()
        }
    }
    
    @IBAction func displayModeChaged(_ sender: UISegmentedControl) {
        if let selectedDisplayMode = DisplayMode(rawValue:sender.selectedSegmentIndex){
            self.displayMode = selectedDisplayMode
        }
    }
    
    
    func retriveAPIData(searchString: String, pageNumber: String){
        let urlRequestStr = "https://api.github.com/users/\(searchString)/repos?page=\(pageNumber)&per_page=10"
        if let urlRequest = URL(string: urlRequestStr){
            self.activityIndicator.startAnimating()
            WebserviceManager.initiateWebservice(url: urlRequest, completionHandler: { (object) -> Void in
                do {
                    guard let responseDict = try JSONSerialization.jsonObject(with: object, options: []) as? [Dictionary<String,AnyObject>] else{
                        return
                    }
                    print(responseDict)
                }
                catch {
                    print("error")
                }
                
                let decoder = JSONDecoder()
                do{
                    guard let responseModel = try decoder.decode([DataModel].self, from: object) as? [DataModel] else{
                        DispatchQueue.main.async {
                            self.activityIndicator.stopAnimating()
                        }

                        return
                    }
                    self.loadingData = false
                    self.responseArray.append(contentsOf: responseModel)
                }
                catch {
                    print("Not able to decode the data")
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.collectionView.reloadData()
                    self.activityIndicator.stopAnimating()
                }
            })
        }
    }
    
}

extension ViewController: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.responseArray.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = self.responseArray.count - 1
        if  !self.loadingData && indexPath.row == lastElement {
            self.loadingData = true
            let nextPage : Int = self.loadedPageNumber + 1
            self.retriveAPIData(searchString: self.searchString, pageNumber: String(nextPage))
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "dataCell", for: indexPath) as? DataTableViewCell else{
            return UITableViewCell()
        }
        let data = self.responseArray[indexPath.row]
        if let name = data.name{
            cell.nameLabel.text = name
        }
        if let description = data.description{
            cell.descriptionLabel.text = description
        }
        if let createdAt = data.created_at{
            cell.createdAtLabel.text = createdAt
        }
        if let licenseName = data.license{
            cell.licenseLabel.text = licenseName
        }
        return cell
    }

}

extension ViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int{
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return self.responseArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath as IndexPath) as! DataCollectionViewCell
       
        let data = self.responseArray[indexPath.row]
        if let name = data.name{
            cell.nameLabel.text = name
        }
        if let description = data.description{
            cell.descriptionLabel.text = description
        }
        if let createdAt = data.created_at{
            cell.createdAtLabel.text = createdAt
        }
        if let licenseName = data.license{
            cell.licenseLabel.text = licenseName
        }
        cell.sizeToFit()
        return cell
        
    }
    
}

