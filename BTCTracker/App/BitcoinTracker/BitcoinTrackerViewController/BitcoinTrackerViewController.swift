//
//  BitcoinTrackerViewController.swift
//  BTCTracker
//
//  Created by Sachin Ambegave on 26/10/21.
//

import UIKit

// MARK:- BitcoinTrackerViewController
class BitcoinTrackerViewController: UIViewController {
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var currencyPickerView: UIPickerView!
    
    var priceValue: String? {
        didSet {
            guard let priceValue = priceValue else { return }
            threadOnMain { [weak self] in
                self?.priceLabel.text = priceValue
            }
        }
    }
    
    var viewModel: BitcoinTrackerProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = BitcoinTrackerViewModel()
        
        
        
        setupViews()
        fetchBitcoinPrices()
    }
    
    
    
    private func setupViews() {
        threadOnMain { [weak self] in
            self?.logoImageView.layer.cornerRadius = (self?.logoImageView.frame.height)! / 2
        }
        
        self.currencyPickerView.delegate = self
        self.currencyPickerView.dataSource = self
    }
    
    private func fetchBitcoinPrices() {
        self.showSpinner(onView: self.view)
        
        viewModel?.fetchData(completion: { error, message, currencies in
            self.removeSpinner()
            
            if error {
                self.showAlert(title: "Warning", message: "\(message). Do you want to try again ?", actionTitles: ["Yes", "No"], actions: [{ (yesAction) in
                    self.fetchBitcoinPrices()
                }, { (noAction) in
                    return
                }])
            }else {
                //TODO : show data into picker view
                if let currencies = currencies, currencies.count > 0 {
                    threadOnMain { [weak self] in
                        if let viewModel = self?.viewModel, let currency = viewModel.currencies?[0], let currencyValue = currency.value?.rate {
                            self?.priceValue = currencyValue
                        }
                        self?.currencyPickerView.reloadAllComponents()
                    }
                }
            }
        })
    }
}

// MARK:- UIPickerView Delegate & Datasource Methods
extension BitcoinTrackerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel?.currencies?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if let viewModel = viewModel, let currency = viewModel.currencies?[row], let currencyCode = currency.value?.code {
            return currencyCode
        }else {
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let viewModel = viewModel, let currency = viewModel.currencies?[row], let currencyValue = currency.value?.rate {
            self.priceValue = currencyValue
        }
    }
}
