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
        appearance.backgroundColor = K.Color.background
        appearance.titleTextAttributes = [.font: UIFont.boldSystemFont(ofSize: 20.0), .foregroundColor: K.Color.textLight]

        navigationController?.navigationBar.tintColor = K.Color.textLight
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
}
