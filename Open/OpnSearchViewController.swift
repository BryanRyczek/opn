//
//  OpnSearchViewController.swift
//  Open
//
//  Created by Bryan Ryczek on 12/15/16.
//  Copyright © 2016 Bryan Ryczek. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import GooglePlaces
import SwiftyJSON

class OpnSearchViewController:  UIViewController {

    var predictionsArray : [GMSAutocompletePrediction] = []
    var placesArray : [GMSPlace] = []
    
    var placesClient: GMSPlacesClient!
    
    let GoogleMapsAPIServerKey = "AIzaSyBnajvDIhZR3W5ksBmOvzU3j1yJSX48ZBY"

    var locationManager : CLLocationManager!
    var currentLat : CLLocationDegrees?
    var currentLong : CLLocationDegrees?
    
    
    //MARK: search
    var searchController : OpnSearchController!
    var tableDataSource: GMSAutocompleteTableDataSource?

    @IBOutlet weak var searchTableView: UITableView!
    
    @IBOutlet weak var searchControllerView: UIView!
    
    @IBOutlet weak var topView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSearchController()
        
        placesClient = GMSPlacesClient.shared()
        
        placesClient.currentPlace(callback: { (placeLikelihoodList, error) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            
            if let placeLikelihoodList = placeLikelihoodList {
                let place = placeLikelihoodList.likelihoods.first?.place
                if let place = place {
                     print("place \(place.name) ")
                    //self.addressLabel.text = place.formattedAddress?.components(separatedBy: ", ")
                        //.joined(separator: "\n")
                }
            }
        })
        
        
        searchTableView.delegate = self
        searchTableView.dataSource = self
        
        //register nib for custom cell & other setup
        searchTableView.register(UINib(nibName: "GooglePlaceTableViewCell", bundle: nil), forCellReuseIdentifier: "GooglePlaceTableViewCell")
        searchTableView.estimatedRowHeight = 64.0
        searchTableView.rowHeight = UITableViewAutomaticDimension
        
        determineMyCurrentLocation()
    }

    
    //MARK: set notifications for
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(OpnSearchViewController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        notificationCenter.addObserver(self, selector: #selector(OpnSearchViewController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        notificationCenter.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    
    func keyboardWillShow(notification: NSNotification) {
        let userInfo = notification.userInfo!
        let keyboardHeight = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        
//        UIView.animate(withDuration: 0.3, animations: {
//            self.topView.isHidden = true
//        }, completion: { (true) in
//            self.view.layoutIfNeeded()
//            print("topViewHidden: \(self.topView.isHidden)")
//        })
        
        
        print(keyboardHeight);
    }
    
    func keyboardWillHide(notification: NSNotification) {
            
            UIView.animate(withDuration: 0.15, animations: {
                self.topView.isHidden = false
                self.view.layoutIfNeeded()
            }, completion: { (true) in
                print("topViewHidden: \(self.topView.isHidden)")
            })
        
    }
    
    func configureSearchController() {
        
        let scFrame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: self.view.frame.size.width * 0.8, height: self.view.frame.size.height * 0.15))
        
        searchController = OpnSearchController(searchResultsController: nil,
                                               searchBarFrame: scFrame,
                                               searchBarFont: UIFont(name: avenir85, size: 24.0)!,
                                               searchBarTextColor: opnBlue,
                                               searchBarTintColor: opnRed)
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = true
        searchController.searchBar.delegate = self
        
        definesPresentationContext = true
        
        // add searchController to tableview which will display its results
        //searchTableView.tableHeaderView = searchController.searchBar
        searchControllerView.addSubview(searchController.searchBar)
        
        searchController.searchBar.sizeToFit()

    }
    
    
    
    func didUpdateAutocompletePredictionsForTableDataSource(tableDataSource: GMSAutocompleteTableDataSource) {
        // Turn the network activity indicator off.
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        // Reload table data.
        
        DispatchQueue.main.async {
            self.searchTableView.reloadData()
        }
    }
    
    func didRequestAutocompletePredictionsForTableDataSource(tableDataSource: GMSAutocompleteTableDataSource) {
        // Turn the network activity indicator on.
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        // Reload table data.
        DispatchQueue.main.async {
            self.searchTableView.reloadData()
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func presentSearch(_ sender: Any) {
        
        print("button pressed")
        
        if topView.isHidden {
            
            self.searchController.searchBar.resignFirstResponder()
            
            
        } else if !topView.isHidden {
            UIView.animate(withDuration: 0.3, animations: {
                self.topView.isHidden = true
                self.view.layoutIfNeeded()
            }, completion: { (true) in
                print("topViewHidden: \(self.topView.isHidden)")
                self.searchController.searchBar.becomeFirstResponder()
            })

        }
        
        
    }
    
    func animateTableView() {
        
        //DispatchQueue.main.asyncAfter(deadline: .now() + 1.00) {
        
        //     }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//MARK: Search Bar (embedded inside UISearchController) Delegate Methods
extension OpnSearchViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
       //searchBar.resignFirstResponder()
        
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
//        UIView.animate(withDuration: 0.5) {
//            self.topView.isHidden = false
//            self.view.layoutIfNeeded()
//        }
    }
    
}

//MARK: Location Manager Delegate Methods
extension OpnSearchViewController: CLLocationManagerDelegate {
    
    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            //locationManager.startUpdatingHeading()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        
        
        currentLat = userLocation.coordinate.latitude
        currentLong = userLocation.coordinate.longitude
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }

}

//MARK: TableView Delegate / Datasource Methods
extension OpnSearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView (_: UITableView, numberOfRowsInSection section: Int) -> Int {
        
       return predictionsArray.count

    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "GooglePlaceTableViewCell", for: indexPath) as! GooglePlaceTableViewCell
        
        let place = predictionsArray[indexPath.row]
        
        if let secondtxt = place.attributedSecondaryText as NSAttributedString! {
            cell.secondaryLabel.text = secondtxt.string
        }
        
        let placeName = predictionsArray[indexPath.row].attributedPrimaryText.string
        
        cell.nameLabel.text = placeName
        
        cell.update(placeID: place.placeID!)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "GooglePlaceTableViewCell", for: indexPath) as! GooglePlaceTableViewCell
        guard let biz = cell.firebaseBusiness else { return }
        cacheBusiness(business: biz)
        
    }
    
}

//MARK: searchbar results updater
extension OpnSearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {return}
        placeAutocomplete(searchText)
    }
    
    func placeAutocomplete(_ searchText: String) {
        let currentLocation = CLLocationCoordinate2D(latitude: currentLat!, longitude: currentLong!)
        let nwOffset = locationWithBearing(bearing: 315.0, distanceMeters: 25000, origin: currentLocation)
        let seOffset = locationWithBearing(bearing: 135.0, distanceMeters: 25000, origin: currentLocation)
        let bounds = GMSCoordinateBounds(coordinate: nwOffset, coordinate: seOffset)
        
        let filter = GMSAutocompleteFilter()
        filter.type = GMSPlacesAutocompleteTypeFilter.establishment
        //filter.country = "USA"
        
        if !searchText.isEmpty {
            GMSPlacesClient.shared().autocompleteQuery(searchText, bounds: bounds, filter: filter) { (results, error ) in
                if let error = error {
                    print("lookup place prediction query error: \(error.localizedDescription)")
                    return
                }
                
                if let results = results {
                    self.predictionsArray = results
                    DispatchQueue.main.async {
                        self.searchTableView.reloadData()
                    }
                    
                }
            }
        }
        
    }
    
}

