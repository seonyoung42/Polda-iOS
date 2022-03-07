//
//  DiaryCell.swift
//  SyPolaroid
//
//  Created by 장선영 on 2021/11/15.
//


import UIKit
import SnapKit

class DiaryCell: UICollectionViewCell {
    
    let diaryImage = UIImageView()
    let diaryTitle = UITextField()
    let highLight = UIView()
  
    override func awakeFromNib() {
        super.awakeFromNib()
        diaryTitle.delegate = self
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
    
    func setupCell(cover: Cover) {
        layout()
        attribute()
        diaryTitle.text = cover.name
        guard let data = cover.image else { return }
        diaryImage.image = UIImage(data: data)
    }
}

extension DiaryCell : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let title = textField.text, !title.isEmpty else {
            return false
        }
    
        let cover = DataManager.shared.coverList[getIndexPath()?.row ?? 0]
        cover.name = title
        DataManager.shared.saveContext()
        diaryTitle.resignFirstResponder()
        return true
    }
    
    func getIndexPath() -> IndexPath? {
        guard let superView = self.superview as? UICollectionView else {
            print("superview is not a UITableView - getIndexPath")
            return nil
        }
        let indexPath = superView.indexPath(for: self)
        return indexPath
    }
}

private extension DiaryCell {
    func layout() {
        [diaryImage,diaryTitle,highLight].forEach {
            contentView.addSubview($0)
        }
        
        diaryImage.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        diaryTitle.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.leading.equalToSuperview().inset(40)
            $0.top.equalToSuperview().inset(65)
            $0.height.equalTo(50)
        }
        
        highLight.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func attribute() {
        contentView.layer.cornerRadius = 80
        
        diaryTitle.textAlignment = .center
        diaryTitle.alpha = 0.5
        diaryTitle.backgroundColor = .white
        diaryTitle.rightViewMode = .always
        diaryTitle.borderStyle = .roundedRect
        diaryTitle.placeholder = "Title.."
        diaryTitle.font = .systemFont(ofSize: 17, weight: .semibold)

        diaryImage.layer.borderWidth = 5
        diaryImage.layer.borderColor = UIColor(red: 0.984081924, green: 0.5641410947, blue: 0.5658608675, alpha: 1).cgColor
        diaryImage.layer.cornerRadius = 80
    }
}


