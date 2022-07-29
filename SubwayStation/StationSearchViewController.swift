//
//  StationSearchViewController.swift
//  SubwayStation
//
//  Created by 구희정 on 2022/07/29.
//

import UIKit
import SnapKit

class StationSearchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "지하철 도착 정보"
        
        let searchController = UISearchController()
        searchController.searchBar.placeholder = "지하철 역을 입력해주세요."
        //검색이 클릭되면, 아래 부분을 어둡게 할 것인가에 대한 Option
        searchController.obscuresBackgroundDuringPresentation = false
        
        navigationItem.searchController = searchController
        
        
    }
}

