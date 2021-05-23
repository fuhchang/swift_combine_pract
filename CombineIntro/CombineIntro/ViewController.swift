//
//  ViewController.swift
//  CombineIntro
//
//  Created by Fuh chang Loi on 21/5/21.
//

import UIKit
import Combine
class MyCustomTableCell: UITableViewCell {
    private let button: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .systemPink
        btn.setTitle("Button", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        return btn
    }()
    
    let action = PassthroughSubject<String, Never>()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(button)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    @objc private func didTapButton() {
        action.send("Cool! Button \(button.titleLabel?.text ?? "") was tap")
    }
    
    func setButtonTitle(_ title: String) {
        button.setTitle(title, for: .normal)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        button.frame = CGRect(x:10, y: 3, width:  contentView.frame.size.width - 20, height:  contentView.frame.size.height - 6)
    }
}

class ViewController: UIViewController, UITableViewDataSource {
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(MyCustomTableCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    private var models = [String]()
    var observer: [AnyCancellable] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.frame = view.bounds
        ApiCaller.shared.fetchCompanies().receive(on: DispatchQueue.main).sink(receiveCompletion: { completion in
            switch completion {
            case.finished:
                print("Finished")
            case .failure(let error):
                print("Error \(error)")
            }
        }, receiveValue: { [weak self] (result) in
            self?.models = result
            self?.tableView.reloadData()
        }).store(in: &observer)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MyCustomTableCell else {
            fatalError()
        }
        cell.setButtonTitle(models[indexPath.row])
        cell.action.sink(receiveValue: {value in
            print(value)
        }).store(in: &observer)
        return cell
    }
}

