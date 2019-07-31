//
//  WalletDocumentsControllerAttributes.swift
//  Haggle
//
//  Created by Anil Kumar on 22/04/19.
//  Copyright © 2019 AIT. All rights reserved.
//

import Foundation

class documentCollectionViewClass: UICollectionView{
    init(controller: WalletDocumentsController) {
        let layout = UICollectionViewFlowLayout()
        super.init(frame: .zero, collectionViewLayout: layout)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
