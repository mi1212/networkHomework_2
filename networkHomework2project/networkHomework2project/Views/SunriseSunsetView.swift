//
//  SunriseSunsetView.swift
//  networkHomework2project
//
//  Created by Mikhail Chuparnov on 03.03.2023.
//

import UIKit
import SnapKit

final class SunriseSunsetView: UIView {
    
    private let sunriseLabel = DataLabelView()
    
    private let sunsetLabel = DataLabelView()
    
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
        addSubview(sunriseLabel)
        addSubview(sunsetLabel)
        
        sunriseLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(8)
            $0.leading.equalToSuperview().inset(16)
            $0.width.equalToSuperview().multipliedBy(0.35)
        }
        
        sunsetLabel.snp.makeConstraints {
            $0.top.bottom.equalTo(sunriseLabel)
            $0.trailing.equalToSuperview().inset(16)
            $0.width.equalToSuperview().multipliedBy(0.35)
        }
    }
    func setupData(weatherData: WeatherData) {
        
        sunriseLabel.descriptionLabel.text = "Восход"
        sunriseLabel.valueLabel.text = formateSunriSunseTime(Double(weatherData.sys.sunrise))
        
        sunsetLabel.descriptionLabel.text = "Закат"
        sunsetLabel.valueLabel.text = formateSunriSunseTime(Double(weatherData.sys.sunset))
    }
    
    private func formateSunriSunseTime(_ dateTimeinterval: Double) -> String {
        let dateformatter = DateFormatter()
        let date = NSDate(timeIntervalSince1970: dateTimeinterval)
        dateformatter.locale = Locale(identifier: "ru")
        dateformatter.setLocalizedDateFormatFromTemplate("HHmm")
        let timeString = dateformatter.string(from: date as Date)
        
        return timeString
    }
    
}
