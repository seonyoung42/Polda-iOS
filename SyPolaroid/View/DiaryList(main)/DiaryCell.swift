//
//  DiaryCell.swift
//  SyPolaroid
//
//  Created by 장선영 on 2021/11/15.
//

import UIKit

class DiaryCell: UICollectionViewCell {
    
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var diaryView: UIView!
    @IBOutlet weak var diaryImage: UIImageView!
    @IBOutlet weak var diaryTitle: UITextField!
    @IBOutlet weak var diaryImageButton: UIButton!
    @IBOutlet weak var highLight: UIView!
    
    @IBAction func done(_ sender: UITextField) {
        sender.resignFirstResponder()
        guard let name = sender.text else {
            print("invalid title")
            return
        }
        let cover = DataManager.shared.coverList[getIndexPath()?.row ?? 0]
        cover.name = name
        DataManager.shared.saveContext()
    }
    
    func getIndexPath() -> IndexPath? {
        guard let superView = self.superview as? UICollectionView else {
            print("superview is not a UITableView - getIndexPath")
            return nil
        }
        let indexPath = superView.indexPath(for: self)
        return indexPath
    }
    
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
                    self.layer.cornerRadius = 80
                    highLight.alpha = 0.3
                } else {
                    highLight.isHidden = true
                    self.layer.borderWidth = 0
                }
            }
        }
}