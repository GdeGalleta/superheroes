//
//  MarvelViewController.swift
//  Superheroes
//
//  Created by Dimitri Sopov on 6/3/22.
//

import UIKit

public class MarvelViewController: UIViewController {

    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black
        appearance.titleTextAttributes = [.font: UIFont.boldSystemFont(ofSize: 20.0), .foregroundColor: UIColor.white]

        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
}
