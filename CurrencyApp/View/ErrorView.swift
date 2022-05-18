//
//  ErrorView.swift
//  CryptoApp
//
//  Created by Роман Уваров on 18.05.2022.
//

import UIKit
import SnapKit
import Swissors
import Networking

final class ErrorView: UIView {
    
    private enum Layout {
        static let insets = UIEdgeInsets(value: 16)
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.numberOfLines = 0
        label.textColor = .white
        label.textAlignment = .center
        
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func set(errorText: String) {
        titleLabel.text = errorText
    }
    
    public func set(error: CryptoError) {
        titleLabel.text = error.description
    }
    
    private func configure() {
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(Layout.insets)
        }
    }
}
