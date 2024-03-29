//
//  UserListViewController.swift
//  CoredataPOC
//
//  Created by Wipro on 12/12/19.
//  Copyright (c) 2019 wipro. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol UserListDisplayLogic: class
{
  func displaySomething(viewModel: UserList.Something.ViewModel)
}

class UserListViewController: UIViewController, UserListDisplayLogic
{
    
    @IBOutlet weak var contentView: UIView!
    
    var scrollView: UIScrollView!
    var slip1: UITableView!
    var slipArray = [String]()
    var tableCount: CGFloat!
    var scrollCount: CGFloat!
    var x: CGFloat!
    
    var userListArr: [UserList.Something.ViewModel.DisplayedOrder] = []
    var interactor: UserListBusinessLogic?
    var router: (NSObjectProtocol & UserListRoutingLogic & UserListDataPassing)?

  // MARK: Object lifecycle
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
  {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder)
  {
    super.init(coder: aDecoder)
    setup()
  }
  
  // MARK: Setup
  
  private func setup()
  {
    let viewController = self
    let interactor = UserListInteractor()
    let presenter = UserListPresenter()
    let router = UserListRouter()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
  }
  
  // MARK: Routing
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?)
  {
    if let scene = segue.identifier {
      let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
      if let router = router, router.responds(to: selector) {
        router.perform(selector, with: segue)
      }
    }
  }
  
  // MARK: View lifecycle
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    tableCount = 4
    scrollCount = tableCount/3
    scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: contentView.frame.size.height))
    scrollView.contentSize = CGSize(width: self.view.frame.size.width * scrollCount, height: contentView.frame.size.height)
    scrollView.isPagingEnabled = true
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(scrollView)
    x = 0
    self.setupSlipTableview()
    self.title = "Users List"
  }
    
    override func viewWillAppear(_ animated: Bool) {
        doSomething()
    }
  
 
  func setupSlipTableview(){
         
         print(x!,Int(scrollCount))
         for i in 1...Int(tableCount){
             print(x!)
             slip1 = UITableView(frame: CGRect(x: x, y: 0, width: self.view.frame.size.width/3, height: contentView.frame.size.height), style: UITableView.Style.plain)
             slip1.register(UITableViewCell.self, forCellReuseIdentifier: "id")
             slip1.tag = i
             slip1.delegate = self
             slip1.dataSource = self
             slip1.isScrollEnabled = false
             slip1.layer.masksToBounds = true
             slip1.layer.borderColor = UIColor( red: 0/255, green: 0/255, blue:0/255, alpha: 1.0 ).cgColor
             slip1.layer.borderWidth = 2.0
             scrollView.addSubview(slip1)
             x = slip1.frame.origin.x + slip1.frame.size.width
         }
     }
     
    
  func doSomething()
  {
    let request = UserList.Something.Request()
    interactor?.doSomething(request: request)
  }
  
  func displaySomething(viewModel: UserList.Something.ViewModel)
  {
    //nameTextField.text = viewModel.name
  }
    
    @IBAction func createUserBtnAction(_ sender: UIBarButtonItem) {
        router?.routeToSomewhere(segue: nil)
    }
}

extension UserListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return (interactor?.getSlipArrayCount(tag: tableView.tag))!
            
    }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "id", for: indexPath)
            cell.textLabel?.text = interactor?.getSlipArray(tag: tableView.tag) [indexPath.row]
            cell.textLabel?.textAlignment = NSTextAlignment.center
            
            return cell
        }
        
        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let headerLbl = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            headerLbl.backgroundColor = UIColor.lightGray
            headerLbl.textAlignment = NSTextAlignment.center
            headerLbl.font = UIFont .boldSystemFont(ofSize: 20)
            headerLbl.textColor = UIColor.black
            headerLbl.text = interactor?.getSlipTitle(tag: tableView.tag)
          return headerLbl
        }
        
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 50.0
        }
     
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 20
        }
        
       
        
      
}
