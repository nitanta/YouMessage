//
//  CustomContentConfiguration.swift
//  youMessage MessagesExtension
//
//  Created by Nitanta Adhikari on 18/08/2023.
//

import UIKit
import Messages

struct CustomContentConfiguration: UIContentConfiguration, Hashable {
    var sticker: MSSticker? = nil
    
    func makeContentView() -> UIView & UIContentView {
        return CustomContentView(configuration: self)
    }
    
    func updated(for state: UIConfigurationState) -> Self {
        return self
    }
}

class CustomContentView: UIView, UIContentView {
    
    private let stickerView = MSStickerView()
    
    init(configuration: CustomContentConfiguration) {
        super.init(frame: .zero)
        setupInternalViews()
        apply(configuration: configuration)
    }
    
    private func setupInternalViews() {
        stickerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stickerView)
        NSLayoutConstraint.activate([
            stickerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stickerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stickerView.topAnchor.constraint(equalTo: topAnchor),
            stickerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private var appliedConfiguration = CustomContentConfiguration()
    
    // Apply the custom configuration.
    private func apply(configuration: CustomContentConfiguration) {
        guard appliedConfiguration != configuration else { return }
        appliedConfiguration = configuration
        stickerView.sticker = appliedConfiguration.sticker
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var configuration: UIContentConfiguration {
        get { appliedConfiguration }
        set {
            guard let newConfig = newValue as? CustomContentConfiguration else { return }
            apply(configuration: newConfig)
        }
    }
    
}
