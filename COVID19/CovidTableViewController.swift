//
//  CovidTableViewController.swift
//  COVID19
//
//  Created by 장기화 on 2021/11/25.
//

import UIKit

class CovidTableViewController: UITableViewController {

    @IBOutlet var newCaseCell: UITableViewCell!
    @IBOutlet var totalCaseCell: UITableViewCell!
    @IBOutlet var recoveredCell: UITableViewCell!
    @IBOutlet var deathCell: UITableViewCell!
    @IBOutlet var percentageCell: UITableViewCell!
    @IBOutlet var overseasInflowCell: UITableViewCell!
    @IBOutlet var regionalOutbreakCell: UITableViewCell!
    
    var covidOverView: CovidOverView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }

    func configureView() {
        guard let covidOverView = covidOverView else { return }
        title = covidOverView.countryName
        newCaseCell.detailTextLabel?.text = "\(covidOverView.newCase)명"
        totalCaseCell.detailTextLabel?.text = "\(covidOverView.totalCase)명"
        recoveredCell.detailTextLabel?.text = "\(covidOverView.recovered)명"
        deathCell.detailTextLabel?.text = "\(covidOverView.death)명"
        percentageCell.detailTextLabel?.text = "\(covidOverView.percentage)명"
        overseasInflowCell.detailTextLabel?.text = "\(covidOverView.newFcase)명"
        regionalOutbreakCell.detailTextLabel?.text = "\(covidOverView.newCcase)명"
    }
}
