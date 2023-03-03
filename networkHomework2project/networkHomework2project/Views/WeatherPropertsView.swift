//
//  WeatherPropertsView.swift
//  networkHomework2project
//
//  Created by Mikhail Chuparnov on 03.03.2023.
//

import UIKit
import SnapKit

final class WeatherPropertsView: UIView {
    
    private let weatherDataView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .equalSpacing
        stack.axis = .vertical
        stack.backgroundColor = .clear
        return stack
    }()
    
    let maxTempDataView = DataLabelView()
    let minTempDataView = DataLabelView()
    let pressureDataView = DataLabelView()
    let humidityDataView = DataLabelView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        setupLayout()
        setupCornerRadius()
    }
    
    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(weatherDataView)
        
        weatherDataView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview().inset(8)
            $0.height.equalTo(100)
        }
    }
    
    func setupData(_ weatherData: WeatherData) {
        DispatchQueue.main.async() { [self] in
            maxTempDataView.descriptionLabel.text = "Макс температура"
            maxTempDataView.valueLabel.text = "\(Int(weatherData.main.tempMax)) " + "\u{2103}"
            
            minTempDataView.descriptionLabel.text = "Мин температура"
            minTempDataView.valueLabel.text = "\(Int(weatherData.main.tempMin)) " + "\u{2103}"
            
            pressureDataView.descriptionLabel.text = "Давление"
            pressureDataView.valueLabel.text = "\(Int(weatherData.main.pressure!)) мм рт ст"
            
            humidityDataView.descriptionLabel.text = "Влажность"
            humidityDataView.valueLabel.text = "\(Int(weatherData.main.humidity!)) %"
            
            weatherDataView.addArrangedSubview(maxTempDataView)
            weatherDataView.addArrangedSubview(minTempDataView)
            weatherDataView.addArrangedSubview(pressureDataView)
            weatherDataView.addArrangedSubview(humidityDataView)
        }
    }

}
