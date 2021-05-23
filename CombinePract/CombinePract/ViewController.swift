//
//  ViewController.swift
//  CombinePract
//
//  Created by Fuh chang Loi on 21/5/21.
//

import UIKit
import Combine
class ViewController: UIViewController {
    lazy var switchmessageLabel: UILabel = {
        var label = UILabel()
        label.text = "Allow Messages"
        return label
    }()
    lazy var allowMessageSwitch: UISwitch = {
        var switchBtn = UISwitch()
        switchBtn.addTarget(self, action: #selector(didSwitch), for: .touchUpInside)
        return switchBtn
    }()
    lazy var sendBtn: UIButton = {
        var sendBtn = UIButton()
        sendBtn.setTitle("Send Message", for: .normal)
        sendBtn.backgroundColor = .red
        return sendBtn
    }()
    lazy var messageLabel: UILabel = {
        var label = UILabel()
        label.text = "The message"
        return label
    }()
    
    private var switchSubscriber: AnyCancellable?
    var action = PassthroughSubject<Action, Never>()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .lightGray
        layout()
        disableButton()
        switchSubscriber = action.receive(on: DispatchQueue.main).sink(receiveValue: {[weak self] action in
            switch action {
            case.enableButton:
                self?.enableButton()
            case .disableButton:
                self?.disableButton()
            }
        })
    }
    
    func layout() {
        self.view.addSubview(switchmessageLabel)
        self.view.addSubview(allowMessageSwitch)
        self.view.addSubview(sendBtn)
        self.view.addSubview(messageLabel)
        addConstraints()
        
    }
    @objc func didSwitch(_ sender: UISwitch) {
        if sender.isOn {
            action.send(.enableButton)
        } else {
            action.send(.disableButton)
        }
    }
    
    func enableButton() {
        sendBtn.isEnabled = true
        sendBtn.alpha = 1.0
    }
    func disableButton() {
        sendBtn.isEnabled = false
        sendBtn.alpha = 0.5
    }
    
    private func addConstraints() {
        switchmessageLabel.translatesAutoresizingMaskIntoConstraints = false
        switchmessageLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -50).isActive = true
        switchmessageLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        switchmessageLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        allowMessageSwitch.translatesAutoresizingMaskIntoConstraints = false
        allowMessageSwitch.leadingAnchor.constraint(equalTo: switchmessageLabel.trailingAnchor, constant: 5).isActive = true
        allowMessageSwitch.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant:  20).isActive = true
        allowMessageSwitch.widthAnchor.constraint(equalToConstant: 200).isActive = true
        allowMessageSwitch.heightAnchor.constraint(equalToConstant: 50).isActive = true
        sendBtn.translatesAutoresizingMaskIntoConstraints = false
        sendBtn.topAnchor.constraint(equalTo: switchmessageLabel.bottomAnchor, constant: 20).isActive = true
        sendBtn.leadingAnchor.constraint(equalTo: switchmessageLabel.leadingAnchor).isActive = true
        sendBtn.widthAnchor.constraint(equalToConstant: 200).isActive = true
        sendBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.topAnchor.constraint(equalTo: sendBtn.bottomAnchor, constant: 10).isActive = true
        messageLabel.leadingAnchor.constraint(equalTo: switchmessageLabel.leadingAnchor).isActive = true
        messageLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
    }
}

extension ViewController {
    enum Action {
        case enableButton
        case disableButton
    }
}
