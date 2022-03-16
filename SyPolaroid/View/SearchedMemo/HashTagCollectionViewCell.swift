//
//  HashTagCollectionViewCell.swift
//  SyPolaroid
//
//  Created by 장선영 on 2022/03/16.
//

import UIKit
import SnapKit

class HashTagCollectionViewCell: UICollectionViewCell {
    let hashTagCellImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
        hashTagCellImageView.layer.borderWidth = 3
        hashTagCellImageView.layer.borderColor = #colorLiteral(red: 1, green: 0.7921494842, blue: 0.7917907834, alpha: 1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(data: Data) {
        hashTagCellImageView.image = UIImage(data: data)
    }
    
    private func layout() {
        contentView.addSubview(hashTagCellImageView)
        hashTagCellImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
