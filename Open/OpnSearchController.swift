//
//  OpnSearchController.swift
//  
//
//  Created by Bryan Ryczek on 12/21/16.
//
//

import UIKit

//protocol OpnSearchControllerDelegate {
//    
//    func didStartSearching()
//    
//    func didTapOnSearchButton()
//    
//    func didTapOnCancelButton()
//    
//    func didChangeSearchText(searchText: String)
//    
//}


class OpnSearchController: UISearchController, UISearchBarDelegate {

    //var customDelegate: OpnSearchControllerDelegate!
    
    var opnSearchBar = OpnSearchBar()
    
    override var searchBar: UISearchBar {
        get {
            return opnSearchBar
        }
    }
    
    init(searchResultsController: UIViewController!,
                  searchBarFrame: CGRect,
                   searchBarFont: UIFont,
              searchBarTextColor: UIColor,
              searchBarTintColor: UIColor)
    {
        super.init(searchResultsController: searchResultsController)
        
        configureSearchBar(frame: searchBarFrame,
                           font: searchBarFont,
                           textColor: searchBarTextColor,
                           bgColor: searchBarTintColor)
        
    }
    
    func configureSearchBar(frame: CGRect,
                            font: UIFont,
                            textColor: UIColor,
                            bgColor: UIColor) {
        
        //opnSearchBar = OpnSearchBar(frame: frame, font: font, textColor: textColor)
        
        
        opnSearchBar.barTintColor = bgColor
        opnSearchBar.tintColor = textColor
        opnSearchBar.showsBookmarkButton = false
        opnSearchBar.showsScopeBar = false
        opnSearchBar.showsCancelButton = false
        
        //opnSearchBar.delegate = self
    }
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UISearchBarDelegate functions
    
//    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        customDelegate.didStartSearching()
//    }
//    
//    
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        opnSearchBar.resignFirstResponder()
//        customDelegate.didTapOnSearchButton()
//    }
//    
//    
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        opnSearchBar.resignFirstResponder()
//        customDelegate.didTapOnCancelButton()
//    }
//    
//    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        customDelegate.didChangeSearchText(searchText: searchText)
//    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
