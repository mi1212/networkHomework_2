//
//  CityWeatherViewController.swift
//  networkHomework2project
//
//  Created by Mikhail Chuparnov on 01.03.2023.
//

import UIKit
import SnapKit

final class WeatherViewController: UIViewController {
    
    private let networkService = NetworkManager()
    
    private var weatherData: WeatherData? {
        didSet{
            setupImage(weatherData!)
            setupData(weatherData!)
            setupWindDirection(weatherData!)
            setupWeatherDataStack(weatherData!)
        }
    }
    
    private let activityIndicatorView: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        activity.color = .white
        activity.style = .large
        return activity
    }()
    
    private let cityLabel = CustomLabel(text: "cityLabel", textAlignment: .left, size: 18, color: .systemGray6, weight: .thin)
    
    private let tempLabel = CustomLabel(text: "tempLabel", textAlignment: .left, size: 52, color: .systemGray6, weight: .heavy)
    
    private let descriptionLabel = CustomLabel(text: "descriptionLabel", textAlignment: .right, size: 14, color: .systemGray6, weight: .thin)
    
    private let tempFeelsLikeLabel = CustomLabel(text: "tempFeelsLikeLabel", textAlignment: .right, size: 14, color: .systemGray6, weight: .thin)
    
    private let weatherImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let windDirectionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .systemGray6
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let windValueLabel = CustomLabel(text: "windValueLabel", textAlignment: .left, size: 16, color: .systemGray6, weight: .thin)
    
    private let windGustValueLabel = CustomLabel(text: "windGustValueLabel", textAlignment: .left, size: 16, color: .systemGray6, weight: .thin)
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProperts()
        requestData("Moscow")
        setupLayout()
        setupSearchBar()
    }
    
    private func setupProperts() {
        view.backgroundColor = .background
    }
    
    private func setupLayout() {
        view.addSubview(cityLabel)
        view.addSubview(tempLabel)
        view.addSubview(activityIndicatorView)
        view.addSubview(weatherImageView)
        view.addSubview(descriptionLabel)
        view.addSubview(tempFeelsLikeLabel)
        view.addSubview(windDirectionImageView)
        view.addSubview(windValueLabel)
        view.addSubview(windGustValueLabel)
        
        activityIndicatorView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        
        cityLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        tempLabel.snp.makeConstraints {
            $0.top.equalTo(cityLabel.snp.bottom).offset(8)
            $0.leading.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.trailing.equalToSuperview().multipliedBy(0.4)
        }
        
        weatherImageView.snp.makeConstraints {
            $0.top.equalTo(tempLabel)
            $0.leading.equalTo(tempLabel.snp.trailing).offset(8)
            $0.width.equalToSuperview().multipliedBy(0.1)
            $0.height.equalTo(weatherImageView.snp.width)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(weatherImageView.snp.top)
            $0.trailing.equalToSuperview().inset(16)
            $0.leading.equalTo(weatherImageView.snp.trailing).offset(8)
        }
        
        tempFeelsLikeLabel.snp.makeConstraints {
            $0.bottom.equalTo(tempLabel.snp.bottom)
            $0.trailing.equalToSuperview().inset(16)
            $0.leading.equalTo(weatherImageView.snp.trailing).offset(8)
        }
        
        windDirectionImageView.snp.makeConstraints {
            $0.top.equalTo(tempLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().inset(16)
            $0.width.equalToSuperview().multipliedBy(0.1)
            $0.height.equalTo(windDirectionImageView.snp.width)
        }
        
        windValueLabel.snp.makeConstraints {
            $0.top.bottom.equalTo(windDirectionImageView)
            $0.leading.equalTo(windDirectionImageView.snp.trailing).offset(16)
            $0.width.equalToSuperview().multipliedBy(0.35)
        }
        
        windGustValueLabel.snp.makeConstraints {
            $0.top.bottom.equalTo(windDirectionImageView)
            $0.trailing.equalToSuperview().inset(16)
            $0.width.equalToSuperview().multipliedBy(0.35)
        }
        
        view.addSubview(weatherDataView)
        
        weatherDataView.snp.makeConstraints {
            $0.top.equalTo(windDirectionImageView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(100)
        }
        
    }
    
    private func setupImage(_ weatherData: WeatherData) {
        let iconId = weatherData.weather[0].icon
        
        networkService.getIcon(iconId: iconId) { image in
            self.weatherImageView.image = image
        }
        
    }
    
    private func setupData(_ weatherData: WeatherData) {
        DispatchQueue.main.async() { [self] in
            cityLabel.text = weatherData.name
            tempLabel.text = "\(Int(weatherData.main.temp))" + "\u{2103}"
            descriptionLabel.text = weatherData.weather[0].description
            tempFeelsLikeLabel.text = "ощущается как \(Int(weatherData.main.feelsLike)) " + "\u{2103}"
            windValueLabel.text = "Ветер \(weatherData.wind.speed) м/с"
            
            if let windGustValue = weatherData.wind.gust {
                windGustValueLabel.text = "Порывы до \(windGustValue) м/с"
            }
            activityIndicatorView.stopAnimating()
        }
    }
    
    private func setupWindDirection(_ weatherData: WeatherData) {
        let windAngle = CGFloat(weatherData.wind.deg)
        
        DispatchQueue.main.async() { [self] in
            windDirectionImageView.image = UIImage(systemName: "arrow.up.circle.fill")
            windDirectionImageView.transform = windDirectionImageView.transform.rotated(by: 6.28/360*windAngle)
        }
    }
    
    private func requestData(_ city: String) {
        activityIndicatorView.startAnimating()
        networkService.requestWeatherData(city: city) { weatherData, error in
            if let weatherData = weatherData {
                self.weatherData = weatherData
            } else {
                guard let error = error else {return}
                self.showAlertMessage(message: error.message!)
            }
            
        }
    }
    
    private func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        self.navigationItem.searchController = searchController
        self.navigationItem.searchController?.isActive = false
        searchController.searchBar.tintColor = .systemGray6
        searchController.searchBar.searchTextField.defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemGray6]
        searchController.searchBar.placeholder = "Введите название города"
        searchController.searchBar.barStyle = .black
    }
    
    private func setupWeatherDataStack(_ weatherData: WeatherData) {
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
    
    private func showAlertMessage(message: String) {
        let alert = UIAlertController(
            title: "Ошибка",
            message: message,
            preferredStyle: UIAlertController.Style.alert
        )
        
        alert.addAction(UIAlertAction(
            title: "ОЙ",
            style: UIAlertAction.Style.cancel)
        )
        DispatchQueue.main.async() { [self] in
            activityIndicatorView.stopAnimating()
            present(alert, animated: true, completion: nil)
        }
    }
    
}

extension WeatherViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let city = searchBar.text else { return }
        activityIndicatorView.startAnimating()
        requestData(city)
        searchBar.text = nil
        self.navigationItem.searchController?.isActive = false
    }

    
}
