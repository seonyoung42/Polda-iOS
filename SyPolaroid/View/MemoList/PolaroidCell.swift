//
//  PolaroidCell.swift
//  SyPolaroid
//
//  Created by 장선영 on 2021/11/17.
//

import UIKit
import SnapKit

class PolaroidCell: UICollectionViewCell {
    let polaroidImage = UIImageView()
    let highLightView = UIView()
    
    override var isHighlighted: Bool {
            didSet {
                highLightView.isHidden = !isHighlighted
            }
        }
    
    override var isSelected: Bool  {
            didSet {
                if isSelected {
                    highLightView.isHidden = false
                    self.layer.borderWidth = 5
                    self.layer.borderColor = UIColor.lightGray.cgColor
                    highLightView.alpha = 0.3
                } else {
                    highLightView.isHidden = true
                    self.layer.borderWidth = 0
                }
            }
        }
    
    func setupCell(data: Data) {
        layout()
        attribute()
        
        polaroidImage.image = UIImage(data: data)
    }
}

// MARK - PolaroidCell UI(attribute, layout)
private extension PolaroidCell {
    func layout() {
        [polaroidImage,highLightView].forEach {
            contentView.addSubview($0)
        }
        
        polaroidImage.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        highLightView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func attribute() {
        polaroidImage.layer.borderWidth = 3
        polaroidImage.layer.borderColor = UIColor(red: 1, green: 0.7921494842, blue: 0.7917907834, alpha: 1).cgColor
        
    }
}
