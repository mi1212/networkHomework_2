//
//  MainTempView.swift
//  networkHomework2project
//
//  Created by Mikhail Chuparnov on 03.03.2023.
//

import UIKit
import SnapKit

final class MainTempView: UIView {

    private let tempLabel = CustomLabel(text: "tempLabel", textAlignment: .left, size: 52, color: .systemGray6, weight: .heavy)
    
    private let descriptionLabel = CustomLabel(text: "descriptionLabel", textAlignment: .right, size: 14, color: .systemGray6, weight: .thin)
    
    private let tempFeelsLikeLabel = CustomLabel(text: "tempFeelsLikeLabel", textAlignment: .right, size: 14, color: .systemGray6, weight: .thin)
    
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
        addSubview(tempLabel)
        addSubview(descriptionLabel)
        addSubview(tempFeelsLikeLabel)
        
        tempLabel.snp.makeConstraints {
            $0.top.bottom.leading.equalToSuperview().inset(8)
            $0.width.equalToSuperview().multipliedBy(0.5)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(tempLabel.snp.top)
            $0.trailing.equalToSuperview().inset(16)
            $0.leading.equalTo(tempLabel.snp.trailing).offset(8)
        }
        
        tempFeelsLikeLabel.snp.makeConstraints {
            $0.bottom.equalTo(tempLabel.snp.bottom)
            $0.trailing.equalToSuperview().inset(16)
            $0.leading.equalTo(tempLabel.snp.trailing).offset(8)
        }
        
    }
    
    func setupData(weatherData: WeatherData) {
                    tempLabel.text = "\(Int(weatherData.main.temp))" + "\u{2103}"
                    descriptionLabel.text = weatherData.weather[0].description
                    tempFeelsLikeLabel.text = "ощущается как \(Int(weatherData.main.feelsLike)) " + "\u{2103}"

    }
    
}
