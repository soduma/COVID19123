//
//  ViewController.swift
//  COVID19
//
//  Created by 장기화 on 2021/11/25.
//

import UIKit
import Charts
import Alamofire

class ViewController: UIViewController {
    
    @IBOutlet var tatalCaseLabel: UILabel!
    @IBOutlet var newCaseLabel: UIStackView!
    @IBOutlet var pieChartView: PieChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchCovidOverView(completionHandler: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(result):
                debugPrint("success \(result)")
            case let .failure(error):
                debugPrint("error \(error)")
            }
        })
    }
    
    func fetchCovidOverView(completionHandler: @escaping (Result<CityCovidOverView, Error>) -> Void) {
        let url = "https://api.corona-19.kr/korea/country/new/"
        let param = [
            "serviceKey": "xfWtzqya7T4OhvoecMIsXJ36ur1gPARGE"
        ]
        
        AF.request(url, method: .get, parameters: param)
            .responseData(completionHandler: { response in
                switch response.result {
                case let .success(data):
                    do {
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(CityCovidOverView.self, from: data)
                        completionHandler(.success(result))
                    } catch {
                        completionHandler(.failure(error))
                    }
                case let .failure(error):
                    completionHandler(.failure(error))
                }
            })
    }
}

