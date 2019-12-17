//
//  UserListRouter.swift
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

@objc protocol UserListRoutingLogic
{
  func routeToSomewhere(segue: UIStoryboardSegue?)
}

protocol UserListDataPassing
{
  var dataStore: UserListDataStore? { get }
}

class UserListRouter: NSObject, UserListRoutingLogic, UserListDataPassing
{
  weak var viewController: UserListViewController?
  var dataStore: UserListDataStore?
  
  // MARK: Routing
  
  func routeToSomewhere(segue: UIStoryboardSegue?)
  {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let vc = storyboard.instantiateViewController(withIdentifier: "CreateUserViewController") as! CreateUserViewController
    viewController?.navigationController?.pushViewController(vc, animated: true)
  }

  // MARK: Navigation
  
  func navigateToSomewhere(source: UserListViewController, destination: CreateUserViewController)
  {
    source.show(destination, sender: nil)
  }
  
  // MARK: Passing data
  
//  func passDataToSomewhere(source: UserListDataStore, destination: inout SomewhereDataStore)
//  {
//    destination.name = source.name
//  }
}
