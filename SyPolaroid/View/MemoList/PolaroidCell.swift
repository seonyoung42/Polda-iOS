//
//  PolaroidCell.swift
//  SyPolaroid
//
//  Created by 장선영 on 2021/11/17.
//

import UIKit

class PolaroidCell: UICollectionViewCell {
    
    @IBOutlet weak var polaroidView: UIView!
    @IBOutlet weak var polaroidImage: UIImageView!
    @IBOutlet weak var highLight: UIView!
    
    override var isHighlighted: Bool {
            didSet {
                highLight.isHidden = !isHighlighted
            }
        }
    
    override var isSelected: Bool  {
            didSet {
                if isSelected == true {
                    highLight.isHidden = false
                    self.layer.borderWidth = 5
                    self.layer.borderColor = UIColor.lightGray.cgColor
                    highLight.alpha = 0.3
                } else {
                    highLight.isHidden = true
                    self.layer.borderWidth = 0
                }
            }
        }
}
