//
//  WindView.swift
//  networkHomework2project
//
//  Created by Mikhail Chuparnov on 03.03.2023.
//

import UIKit
import SnapKit

final class WindView: UIView {
    
    private let windDirectionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .systemGray6
        imageView.image = UIImage(systemName: "arrow.up.circle.fill")
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let windValueLabel = CustomLabel(text: "windValueLabel", textAlignment: .left, size: 16, color: .systemGray6, weight: .thin)
    
    private let windGustValueLabel = CustomLabel(text: "windGustValueLabel", textAlignment: .left, size: 16, color: .systemGray6, weight: .thin)
    
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
        addSubview(windDirectionImageView)
        addSubview(windValueLabel)
        addSubview(windGustValueLabel)
        
        windDirectionImageView.snp.makeConstraints {
            $0.top.bottom.leading.equalToSuperview().inset(8)
            $0.width.equalToSuperview().multipliedBy(0.1)
            $0.height.equalTo(windDirectionImageView.snp.width)
        }
        
        windValueLabel.snp.makeConstraints {
            $0.top.bottom.equalTo(windDirectionImageView)
            $0.leading.equalTo(windDirectionImageView.snp.trailing).offset(8)
            $0.width.equalToSuperview().multipliedBy(0.35)
        }
        
        windGustValueLabel.snp.makeConstraints {
            $0.top.bottom.equalTo(windDirectionImageView)
            $0.trailing.equalToSuperview().inset(8)
            $0.width.equalToSuperview().multipliedBy(0.35)
        }
        
    }
    
    func setupData(weatherData: WeatherData) {
        windValueLabel.text = "Ветер \(weatherData.wind.speed) м/с"
        if let windGustValue = weatherData.wind.gust {
            windGustValueLabel.text = "Порывы до \(windGustValue) м/с"
        }
        
        setupWindDirection(weatherData)
        
    }
    
    private func setupWindDirection(_ weatherData: WeatherData) {
        let windAngle = CGFloat(weatherData.wind.deg)
        
        //        DispatchQueue.main.async() { [self] in
        windDirectionImageView.transform = windDirectionImageView.transform.rotated(by: 6.28/360*windAngle)
        //        }
    }
    
}
