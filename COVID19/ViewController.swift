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
    
    @IBOutlet weak var totalCaseLabel: UILabel!
    @IBOutlet weak var newCaseLabel: UILabel!
    @IBOutlet weak var pieChartView: PieChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchCovidOverView(completionHandler: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(result):
                self.configureStackView(koreaCovidOverView: result.korea)
                let covidOverViewList = self.makeCovidOverViewList(cityCovidOverView: result)
                self.configureChartView(covidOverViewList: covidOverViewList)
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
    
    func configureStackView(koreaCovidOverView: CovidOverView) {
        totalCaseLabel.text = "\(koreaCovidOverView.totalCase)명"
        newCaseLabel.text = "\(koreaCovidOverView.newCase)명"
    }
    
    func makeCovidOverViewList(cityCovidOverView: CityCovidOverView) -> [CovidOverView] {
        return [
            cityCovidOverView.seoul,
            cityCovidOverView.busan,
            cityCovidOverView.daegu,
            cityCovidOverView.incheon,
            cityCovidOverView.gwangju,
            cityCovidOverView.daejeon,
            cityCovidOverView.ulsan,
            cityCovidOverView.sejong,
            cityCovidOverView.gyeonggi,
            cityCovidOverView.gangwon,
            cityCovidOverView.chungbuk,
            cityCovidOverView.chungnam,
            cityCovidOverView.jeonbuk,
            cityCovidOverView.jeonnam,
            cityCovidOverView.gyeongbuk,
            cityCovidOverView.gyeongnam,
            cityCovidOverView.jeju
        ]
    }
    
    func configureChartView(covidOverViewList: [CovidOverView]) {
        let entrys = covidOverViewList.compactMap { [weak self] overview -> PieChartDataEntry? in
            guard let self = self else { return nil }
            return PieChartDataEntry(value: removeFormatString(string: overview.newCase), label: overview.countryName, data: overview)
        }
        let dataSet = PieChartDataSet(entries: entrys, label: "코로나 발생 현황")
        dataSet.sliceSpace = 1
        dataSet.entryLabelColor = .black
        dataSet.valueTextColor = .black
        dataSet.xValuePosition = .outsideSlice
        dataSet.valueLinePart1OffsetPercentage = 0.8
        dataSet.valueLinePart1Length = 0.2
        dataSet.valueLinePart2Length = 0.3
        dataSet.colors = ChartColorTemplates.vordiplom() + ChartColorTemplates.joyful() + ChartColorTemplates.liberty() + ChartColorTemplates.pastel() + ChartColorTemplates.material()
        
        pieChartView.data = PieChartData(dataSet: dataSet)
        pieChartView.spin(duration: 0.3, fromAngle: pieChartView.rotationAngle, toAngle: pieChartView.rotationAngle + 80)
    }
    
    func removeFormatString(string: String) -> Double {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.number(from: string)?.doubleValue ?? 0
    }
}

