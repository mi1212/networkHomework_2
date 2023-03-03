//
//  CityNameView.swift
//  networkHomework2project
//
//  Created by Mikhail Chuparnov on 03.03.2023.
//

import UIKit
import SnapKit

final class CityNameView: UIView {
    
    private let cityLabel = CustomLabel(text: "cityLabel", textAlignment: .left, size: 24, color: .white, weight: .thin)
 
    let weatherImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
   
    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(cityLabel)
        addSubview(weatherImageView)
        
        cityLabel.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview().inset(8)
        }
        
        weatherImageView.snp.makeConstraints {
            $0.centerY.equalTo(cityLabel)
            $0.leading.equalTo(cityLabel.snp.trailing)
            $0.width.equalToSuperview().multipliedBy(0.1)
            $0.height.equalTo(weatherImageView.snp.width)
        }
        
    }
    
    func setupData(weatherData: WeatherData) {
        cityLabel.text = weatherData.name

    }
    
}
