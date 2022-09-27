//
//  ScoreTableView.swift
//  Bodog
//
//  Created by Anastasia Koldunova on 16.09.2022.
//

import UIKit


class ScoreTableView: UITableView,UITableViewDelegate,UITableViewDataSource {
    var totalScore: Int?
    var items: [RateModel] = [] {
        didSet {
            items.sort(by: {$0.score > $1.score})
        }
    }
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.delegate = self
        self.dataSource = self
        self.backgroundColor = .clear
        self.separatorStyle = .none
//        UIColor(red: 68/255, green: 76/255, blue: 106/255, alpha: 1)
        self.layer.cornerRadius = 10
        self.contentInsetAdjustmentBehavior = .never
        
        self.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: 0))
        self.sectionHeaderTopPadding = 0        
//        print("ddjdjd")
    }
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = RateHeaderView(frame: CGRect(x: 00, y: 0, width: tableView.frame.size.width, height: 80))
//        let count = items.count
//        var totalScore = 0
//        items.forEach({totalScore += $0.score})
//        self.totalScore = totalScore
//        headerView.configure(with: count, score: totalScore)
//        return headerView
//    }
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//            return 80
//        }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScoreTableViewCell")! as! ScoreTableViewCell
        cell.backgroundColor = .clear
        cell.configure(model: items[indexPath.row])

        return cell
    }
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "Section \(section)"
//    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected cell #\(indexPath.row)!")
    }
}
