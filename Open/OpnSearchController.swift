//
//  OpnSearchController.swift
//  
//
//  Created by Bryan Ryczek on 12/21/16.
//
//

import UIKit

class OpnSearchController: UISearchController {
    
    //MARK: must init OpnSearchBar here because the searchBar override will be looking for it.
    var opnSearchBar = OpnSearchBar()
    
    //MARK: Override get only searchBar
    override var searchBar: UISearchBar {
        get {
            return opnSearchBar
        }
    }
    
    //MARK: Custom Init
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
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    //MARK: configure search bar
    func configureSearchBar(frame: CGRect,
                            font: UIFont,
                            textColor: UIColor,
                            bgColor: UIColor) {
        
        opnSearchBar.barTintColor = bgColor
        opnSearchBar.tintColor = textColor
        opnSearchBar.showsBookmarkButton = false
        opnSearchBar.showsScopeBar = false
        opnSearchBar.showsCancelButton = false

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
