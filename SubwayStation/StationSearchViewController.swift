//
//  StationSearchViewController.swift
//  SubwayStation
//
//  Created by 구희정 on 2022/07/29.
//

import Alamofire
import UIKit
import SnapKit

class StationSearchViewController: UIViewController {
    private var stations: [Station] = []
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationItems()
        setTableViewLayout()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // MARK: 포커스 table뷰의 포커스 viewWillAppear 시점에서 삭제
        //PUSH -> POP 진입시 tableView의 포커스 없애기
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: animated)
        }
    }

    
    
    private func setNavigationItems() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "지하철 도착 정보"
        
        let searchController = UISearchController()
        searchController.searchBar.placeholder = "지하철 역을 입력해주세요."
        //검색이 클릭되면, 아래 부분을 어둡게 할 것인가에 대한 Option
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        
        navigationItem.searchController = searchController
    }
    
    private func setTableViewLayout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
    
    //역 정보 가져오기
    //클로저를 사용한 비동기처리
    private func requestStationName(from stationName: String) {
        let urlString = "http://openapi.seoul.go.kr:8088/sample/json/SearchInfoBySubwayNameService/1/5/\(stationName)"
        
        AF
            .request(urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
            .responseDecodable(of: StationResponseModel.self) { [weak self] response in
                guard case .success(let data) = response.result else { return }
                
                self?.stations = data.stations
                self?.tableView.reloadData()
            }
            .resume()
    }
}

extension StationSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        let station = stations[indexPath.row]
        cell.textLabel?.text = station.stationName
        cell.detailTextLabel?.text = station.lineNumber
        cell.selectionStyle = .blue
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stations.count
    }
}
extension StationSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let station = stations[indexPath.row]
        let vc = StationDetailViewController(station: station)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension StationSearchViewController: UISearchBarDelegate {
    //User가 SearchBar를 시작 하기전에 불려진다.
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        // TODO: 다른 화면 진입 했다가 다시 뒤로 왔을 때, 키보드가 자동오르 올라오지 않도록 생각해보기.
        print("시작 전 호출")
        tableView.reloadData()
        tableView.isHidden = false
    }
    //User가 SearchBar를 끝낼 때 호출이 된다.
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("시작 후 호출")
        if stations.isEmpty {
            tableView.isHidden = true
        }
    }
    
    //User가 Cancel 버튼 눌렀을 때 데이터 초기화
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("취소버튼")
        stations = []
        if stations.isEmpty {
            tableView.isHidden = true
        }
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("버튼 클릭 완성")
    }

    
    //User가 text를 입력 하자마자 실행
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        requestStationName(from: searchText)
    }
    
}

