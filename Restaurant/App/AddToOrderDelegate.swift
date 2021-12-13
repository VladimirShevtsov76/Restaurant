//
//  AddToOrderDelegate.swift
//  Restaurant
//
//  Created by Vladimir Shevtsov on 07.12.2021.
//
//  Protocol for adding items to the order

protocol AddToOrderDelegate {
    /// Called when menu item is added
    func added(menuItem: MenuItem)
}
