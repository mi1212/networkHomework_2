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
            requestImage(weatherData!)
            setupData(weatherData!)
        }
    }
    
    private let activityIndicatorView: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        activity.color = .white
        activity.style = .large
        return activity
    }()
    
    private let cityNameView = CityNameView()
    
    private let mainTempView = MainTempView()
    
    private let windView = WindView()
    
    private let sunriseSunsetView = SunriseSunsetView()
    
    private let weatherPropertsView = WeatherPropertsView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProperts()
        requestData("Moscow")
        setupActivityIndicatorView()
        setupSearchBar()
    }
    
    private func setupProperts() {
        view.backgroundColor = .background
    }
    
    private func setupActivityIndicatorView() {
        view.addSubview(activityIndicatorView)
        
        activityIndicatorView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
    
    private func setupLayout() {
        view.addSubview(cityNameView)
        view.addSubview(mainTempView)
        view.addSubview(windView)
        view.addSubview(sunriseSunsetView)
        view.addSubview(weatherPropertsView)
        
        cityNameView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(8)
        }
        
        mainTempView.snp.makeConstraints {
            $0.top.equalTo(cityNameView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(8)
        }
        
        windView.snp.makeConstraints {
            $0.top.equalTo(mainTempView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(8)
        }
        
        sunriseSunsetView.snp.makeConstraints {
            $0.top.equalTo(windView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(8)
        }
        
        weatherPropertsView.snp.makeConstraints {
            $0.top.equalTo(sunriseSunsetView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(8)
        }
    }
    
    private func requestImage(_ weatherData: WeatherData) {
        let iconId = weatherData.weather[0].icon
        
        networkService.getIcon(iconId: iconId) { image in
            self.cityNameView.weatherImageView.image = image
        }
        
    }
    
    private func setupData(_ weatherData: WeatherData) {
        DispatchQueue.main.async() { [self] in
            cityNameView.setupData(weatherData: weatherData)
            mainTempView.setupData(weatherData: weatherData)
            windView.setupData(weatherData: weatherData)
            sunriseSunsetView.setupData(weatherData: weatherData)
            weatherPropertsView.setupData(weatherData)
            activityIndicatorView.stopAnimating()
            setupLayout()
        }
    }
    
    private func requestData(_ city: String) {
        activityIndicatorView.startAnimating()
        networkService.requestWeatherData(city: city) { weatherData, error in
            
            DispatchQueue.main.async() { [self] in
                if let weatherData = weatherData {
                    self.weatherData = weatherData
                } else {
                    guard let error = error else {return}
                    self.showAlertMessage(message: error.message!)
                }
            }
            
        }
    }
    
    private func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        self.navigationItem.searchController = searchController
        self.navigationItem.searchController?.isActive = false
        searchController.searchBar.tintColor = .systemGray6
        searchController.searchBar.placeholder = "Введите название города"
        searchController.searchBar.barStyle = .black
        let attributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(attributes, for: .normal)
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
