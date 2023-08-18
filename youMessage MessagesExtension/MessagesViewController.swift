//
//  MessagesViewController.swift
//  youMessage MessagesExtension
//
//  Created by Nitanta Adhikari on 18/08/2023.
//

import UIKit
import Messages

class MessagesViewController: MSMessagesAppViewController {
    
    private enum SectionType: String, CaseIterable {
        case animals
        case tree
    }
    
    private var collectionView: UICollectionView!
    private var datasource: UICollectionViewDiffableDataSource<SectionType, MSSticker>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureUI()
        populateDatasource()
    }
    
    func setupUI() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .systemBackground
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func configureUI() {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewCell, MSSticker> { (cell, indexPath, item) in
            cell.contentConfiguration = CustomContentConfiguration(sticker: item)
        }
        
        let headerRegistration = UICollectionView.SupplementaryRegistration<TitleSupplementaryView>(elementKind: TitleSupplementaryView.identifier) { supplementaryView, elementKind, indexPath in
            supplementaryView.titleLabel.text = SectionType.allCases[indexPath.section].rawValue
        }
        
        datasource = UICollectionViewDiffableDataSource<SectionType, MSSticker>(
            collectionView: collectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
                return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
            }
        )
        
        datasource.supplementaryViewProvider = { (view, kind, index) in
            self.collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: index)
        }
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let headerFooterSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(44)
            )
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.2), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(60))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerFooterSize,
                elementKind: TitleSupplementaryView.identifier,
                alignment: .topLeading
            )
            section.boundarySupplementaryItems = [sectionHeader]
            
            return section
        }
            
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
    }
    
    private func populateDatasource() {
        var snapshot = NSDiffableDataSourceSnapshot<SectionType, MSSticker>()
        snapshot.appendSections(SectionType.allCases)
        
        let animals = (1...4).compactMap { index -> MSSticker? in
            let fileName = "animal-\(index)"
            guard let url = Bundle.main.url(forResource: fileName, withExtension: "png") else { return nil }
            return try? MSSticker(contentsOfFileURL: url, localizedDescription: fileName)
        }
        snapshot.appendItems(animals, toSection: .animals)
        
        let trees = (1...4).compactMap { index -> MSSticker? in
            let fileName = "tree-\(index)"
            guard let url = Bundle.main.url(forResource: fileName, withExtension: "png") else { return nil }
            return try? MSSticker(contentsOfFileURL: url, localizedDescription: fileName)
        }
        snapshot.appendItems(trees, toSection: .tree)
        
        datasource.apply(snapshot, animatingDifferences: true, completion: nil)
    }
}

//MARK: UICollectionViewDelegate
extension MessagesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let conversation = activeConversation, let sticker = datasource.itemIdentifier(for: indexPath) {
            conversation.insert(sticker, completionHandler: nil)
        }
    }
}


// MARK: - Conversation Handling
extension MessagesViewController {
    override func willBecomeActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the inactive to active state.
        // This will happen when the extension is about to present UI.
        
        // Use this method to configure the extension and restore previously stored state.
    }
    
    override func didResignActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the active to inactive state.
        // This will happen when the user dismisses the extension, changes to a different
        // conversation or quits Messages.
        
        // Use this method to release shared resources, save user data, invalidate timers,
        // and store enough state information to restore your extension to its current state
        // in case it is terminated later.
    }
   
    override func didReceive(_ message: MSMessage, conversation: MSConversation) {
        // Called when a message arrives that was generated by another instance of this
        // extension on a remote device.
        
        // Use this method to trigger UI updates in response to the message.
    }
    
    override func didStartSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user taps the send button.
    }
    
    override func didCancelSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user deletes the message without sending it.
    
        // Use this to clean up state related to the deleted message.
    }
    
    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called before the extension transitions to a new presentation style.
    
        // Use this method to prepare for the change in presentation style.
    }
    
    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called after the extension transitions to a new presentation style.
    
        // Use this method to finalize any behaviors associated with the change in presentation style.
    }

}
