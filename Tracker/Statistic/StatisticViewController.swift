//
//  ViewController.swift
//  Tracker
//
//  Created by Vladislav Mishukov on 13.01.2024.
//

import UIKit

class StatisticViewController: UIViewController {
    
    //MARK: - UI
    private lazy var trackerNothingFoundLabel : UILabel = {
        let trackerErrLabel = UILabel()
        trackerErrLabel.translatesAutoresizingMaskIntoConstraints = false
        trackerErrLabel.font = UIFont.systemFont(ofSize: 12)
        trackerErrLabel.textAlignment = .center
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.26
        
        trackerErrLabel.attributedText = NSMutableAttributedString(string:  NSLocalizedString( "statistic.nothing.to.analyze", comment: ""), attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        
        view.addSubview(trackerErrLabel)
        return trackerErrLabel
    }()
    
    private lazy var trackerNothingFoundImage : UIImageView = {
        let ImageView = UIImageView()
        let picture = UIImage(named: "crying_emoji")
        ImageView.image = picture
        ImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(ImageView)
        return ImageView
    }()
    
    private lazy var statisticTableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.allowsSelection = false
        table.separatorStyle = .none
        table.backgroundColor = .ypWhite
        table.register(StatisticCell.self, forCellReuseIdentifier: StatisticCell.identifier)
        table.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(table)
        return table
    }()
    //MARK: - PRIVATE
    private var dataProvider: TrackerRecordStoreDataProvider?
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        dataProvider = TrackerRecordStore()
        
        navigationItem.title = NSLocalizedString("statistic.title", comment: "")
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .ypWhite
        constraitsTrackerNothingFoundImage()
        constraitsTrackerNothingFoundLabel()
        stubSetup()
        constraitsStatisticTableView()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        stubSetup()
        statisticTableView.reloadData()
    }
    //MARK: - PRIVATE FUNC
    func stubSetup() {
        do {
            if try dataProvider?.fetchRecordCount() ?? 0 <= 0 {
                statisticTableView.isHidden = true
            } else {
                statisticTableView.isHidden = false
            }
        } catch {
            assertionFailure("\(error)")
        }
        
    }
    
    //MARK: - constraits
    func constraitsStatisticTableView() {
        NSLayoutConstraint.activate([
            statisticTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            statisticTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            statisticTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            statisticTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    private func constraitsTrackerNothingFoundImage() {
        NSLayoutConstraint.activate([
            trackerNothingFoundImage.widthAnchor.constraint(equalToConstant: 80),
            trackerNothingFoundImage.heightAnchor.constraint(equalToConstant: 80),
            trackerNothingFoundImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            trackerNothingFoundImage.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
    private func constraitsTrackerNothingFoundLabel() {
        NSLayoutConstraint.activate([
            trackerNothingFoundLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            trackerNothingFoundLabel.topAnchor.constraint(equalTo: trackerNothingFoundImage.bottomAnchor, constant: 8)
        ])
    }
}

//MARK: - UITableViewDelegate
extension StatisticViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        90
    }
}

//MARK: - UITableViewDataSource
extension StatisticViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: StatisticCell.identifier, for: indexPath) as? StatisticCell
        else {  return UITableViewCell()}
        
            // let count = trackersRecord.countCompleted()
        do {
            cell.setCount(try dataProvider?.fetchRecordCount() ?? 0)
        } catch {
            assertionFailure("\(error)")
        }
        
        
        return cell
    }
}
