//
//  StickerCollectionViewCell.swift
//  SyPolaroid
//
//  Created by 장선영 on 2022/03/02.
//

import UIKit
import SnapKit

class StickerCollectionViewCell: UICollectionViewCell {
    let stickerImage = UIImageView()
    
    func setupCell(sticker: UIImage) {
        setupLayout()
        stickerImage.image = sticker
    }
    
    private func setupLayout() {
        contentView.addSubview(stickerImage)
        stickerImage.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
