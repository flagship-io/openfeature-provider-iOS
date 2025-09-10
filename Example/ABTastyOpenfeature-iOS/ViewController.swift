//
//  ViewController.swift
//  openFeature-iOS
//
//  Created by Adel on 07/29/2025.
//  Copyright (c) 2025 Adel. All rights reserved.
//

import ABTastyOpenfeature_iOS
import FlagShip
import OpenFeature
import UIKit

class ViewController: UIViewController {
    let startButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Start", for: .normal)
        button.backgroundColor = UIColor.systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return button
    }()

    let btnColorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "btnColor: ---"
        label.textColor = .white
        label.backgroundColor = UIColor.systemPurple
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.white.cgColor
        return label
    }()

    let btnTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "btnTitle: ---"
        label.textColor = .white
        label.backgroundColor = UIColor.systemOrange
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.white.cgColor
        return label
    }()

    let intValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "intValue: ---"
        label.textColor = .white
        label.backgroundColor = UIColor.systemRed
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.white.cgColor
        return label
    }()

    let
        updateContextButton: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("Update Context", for: .normal)
            button.backgroundColor = UIColor.systemIndigo
            button.setTitleColor(.white, for: .normal)
            button.layer.cornerRadius = 8
            button.translatesAutoresizingMaskIntoConstraints = false
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.white.cgColor
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            return button
        }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(startButton)
        view.addSubview(updateContextButton)
        view.addSubview(btnColorLabel)
        view.addSubview(btnTitleLabel)
        view.addSubview(intValueLabel)

        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        updateContextButton.addTarget(self, action: #selector(updateContextButtonTapped), for: .touchUpInside)

        NSLayoutConstraint.activate([
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            startButton.widthAnchor.constraint(equalToConstant: 160),
            startButton.heightAnchor.constraint(equalToConstant: 44),

            updateContextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            updateContextButton.topAnchor.constraint(equalTo: startButton.bottomAnchor, constant: 20),
            updateContextButton.widthAnchor.constraint(equalToConstant: 160),
            updateContextButton.heightAnchor.constraint(equalToConstant: 44),

            btnColorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            btnColorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -44),
            btnColorLabel.widthAnchor.constraint(equalToConstant: 220),
            btnColorLabel.heightAnchor.constraint(equalToConstant: 44),

            btnTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            btnTitleLabel.topAnchor.constraint(equalTo: btnColorLabel.bottomAnchor, constant: 20),
            btnTitleLabel.widthAnchor.constraint(equalToConstant: 220),
            btnTitleLabel.heightAnchor.constraint(equalToConstant: 44),

            intValueLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            intValueLabel.topAnchor.constraint(equalTo: btnTitleLabel.bottomAnchor, constant: 20),
            intValueLabel.widthAnchor.constraint(equalToConstant: 220),
            intValueLabel.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    @objc func startButtonTapped() {
        let ctx = MutableContext(
            targetingKey: "openUserId",
            structure: MutableStructure(attributes: ["isQA": Value.boolean(true),
                                                     "city": Value.string("FR"),
                                                     "hasConsented": Value.boolean(true),
                                                     "ctx1": Value.boolean(false),
                                                     "ctx2": Value.integer(125),
                                                     "ctx3": Value.double(12.0),
                                                     "ctx4": Value.string("valueCtx4")])
        )

        Task {
            let provider = ABTastyProvider(envId: "envId", apiKey: "apiKey", configurator: FSConfigBuilder().build())
            await OpenFeatureAPI.shared.setProviderAndWait(provider: provider, initialContext: ctx)

            // Update the labels on the main thread
            DispatchQueue.main.async {
                // get a bool flag value
                let client = OpenFeatureAPI.shared.getClient()
                let btnTitle = client.getStringValue(key: "btnTitle", defaultValue: "---")
                let btnColor = client.getStringValue(key: "btnColor", defaultValue: "---")
                let intValue = client.getIntegerValue(key: "intValue", defaultValue: 1111)

                self.btnTitleLabel.text = "btnTitle: \(btnTitle)"
                self.btnColorLabel.text = "btnColor: \(btnColor)"
                self.intValueLabel.text = "intValue: \(intValue)"
            }
            
            
            

        }
    }

    @objc func updateContextButtonTapped() {
        
       
        let updatedContext = MutableContext(
            targetingKey: "openUserId",
            structure: MutableStructure(attributes: ["isQA": Value.boolean(false)])
        )

        Task {
            await OpenFeatureAPI.shared.setEvaluationContextAndWait(evaluationContext: updatedContext)

            // Refresh the values after context update
            DispatchQueue.main.async {
                let client = OpenFeatureAPI.shared.getClient()
                let btnTitle = client.getStringValue(key: "btnTitle", defaultValue: "---")
                let btnColor = client.getStringValue(key: "btnColor", defaultValue: "---")
                let intValue = client.getIntegerValue(key: "intValue", defaultValue: 1111)

                self.btnTitleLabel.text = "btnTitle: \(btnTitle)"
                self.btnColorLabel.text = "btnColor: \(btnColor)"
                self.intValueLabel.text = "intValue: \(intValue)"
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
