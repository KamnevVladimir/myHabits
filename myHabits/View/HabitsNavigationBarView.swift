//
//  HabitsNavigationBarView.swift
//  myHabits
//
//  Created by Tsar on 12.02.2021.
//

import UIKit

class HabitsNavigationBarView: UIView {
    private lazy var titleNavBar: UILabel = {
        let label = UILabel()
        label.toAutoLayout()
        label.translatesAutoresizingMaskIntoConstraints = false
  
        return label
    }()
    
    private lazy var addHabbitButton: UIButton = {
        let button = UIButton(type: .contactAdd)
        button.toAutoLayout()
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubviews(titleNavBar,
                         addHabbitButton)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        let constraints = [
            titleNavBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleNavBar.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            
            addHabbitButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            addHabbitButton.topAnchor.constraint(equalTo: topAnchor, constant: 10)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
}
