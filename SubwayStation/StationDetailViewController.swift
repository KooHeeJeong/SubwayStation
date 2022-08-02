//
//  StationDetailViewController.swift
//  SubwayStation
//
//  Created by 구희정 on 2022/08/01.
//

import Alamofire
import SnapKit
import UIKit

final class StationDetailViewController: UIViewController {
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(fetchData), for: .valueChanged)
        
        return refreshControl
    }()
    
    @objc func fetchData() {
        refreshControl.endRefreshing()
        print("REFRESH ! ")
        
        let urlString = "http://swopenapi.seoul.go.kr/api/subway/sample/json/realtimeStationArrival/0/5/왕십리"
        AF
            .request(urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
            .responseDecodable(of: StationArrivalDataResponseModel.self) { response in
                guard case .success(let data) = response.result else { return }
                
                print(data.realTimeStation)
                
            }
            .resume()
    }
    
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(
            width: view.frame.width - 32.0,
            height: 100.0)
        layout.sectionInset = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(StationDetailCollectionViewCell.self, forCellWithReuseIdentifier: "StationDetailCollectionViewCell")
        
        collectionView.dataSource = self
        
        //refresh 는 collectionView에 있지만, 기능이 nil 로 되어있어 선언 해줘야 한다.
        collectionView.refreshControl = refreshControl
        
        return collectionView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "왕십리"
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        fetchData()
    }
}
extension StationDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "StationDetailCollectionViewCell",
            for: indexPath) as? StationDetailCollectionViewCell
        
        cell?.setup()
        
        return cell ?? UICollectionViewCell()
    }
}
