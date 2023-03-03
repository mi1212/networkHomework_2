//
//  DataLabelView.swift
//
//
//  Created by Mikhail Chuparnov on 02.03.2023.
//

import UIKit
import SnapKit

final class DataLabelView: UIView {
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.backgroundColor = .clear
        return stack
    }()
    
    let descriptionLabel = CustomLabel(text: "descriptionLabel", textAlignment: .left, size: 18, color: .systemGray6, weight: .thin)
    
    let valueLabel = CustomLabel(text: "valueLabel", textAlignment: .left, size: 18, color: .systemGray6, weight: .thin)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        stackView.addArrangedSubview(descriptionLabel)
        stackView.addArrangedSubview(valueLabel)
    }
    
}
