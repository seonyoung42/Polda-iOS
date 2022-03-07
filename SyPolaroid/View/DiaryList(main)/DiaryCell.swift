//
//  DiaryCell.swift
//  SyPolaroid
//
//  Created by 장선영 on 2021/11/15.
//


import UIKit
import SnapKit

class DiaryCell: UICollectionViewCell {
    let diaryImageView = UIImageView()
    let diaryTitleTextField = UITextField()
    private let highLightView = UIView()
  
    override func awakeFromNib() {
        super.awakeFromNib()
        diaryTitleTextField.delegate = self
    }
    
    override var isHighlighted: Bool {
            didSet {
                highLightView.isHidden = !isHighlighted
            }
        }
    
    override var isSelected: Bool  {
        didSet {
            if isSelected == true {
                highLightView.isHidden = false
                self.layer.borderWidth = 5
                self.layer.borderColor = UIColor.lightGray.cgColor
                self.layer.cornerRadius = 80
                highLightView.alpha = 0.3
            } else {
                highLightView.isHidden = true
                self.layer.borderWidth = 0
            }
        }
    }
    
    func setupCell(cover: Cover) {
        layout()
        attribute()
        diaryTitleTextField.text = cover.name
        guard let data = cover.image else { return }
        diaryImageView.image = UIImage(data: data)
    }
}

// MARK - DiaryCell diary title textfield
extension DiaryCell : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let title = textField.text, !title.isEmpty else {
            return false
        }
    
        let cover = DataManager.shared.coverList[getIndexPath()?.row ?? 0]
        cover.name = title
        DataManager.shared.saveContext()
        diaryTitleTextField.resignFirstResponder()
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

// MARK - DiaryCell UI (attribute, layout)
private extension DiaryCell {
    func layout() {
        [diaryImageView,diaryTitleTextField,highLightView].forEach {
            contentView.addSubview($0)
        }
        
        diaryImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        diaryTitleTextField.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.leading.equalToSuperview().inset(40)
            $0.top.equalToSuperview().inset(65)
            $0.height.equalTo(50)
        }
        
        highLightView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func attribute() {
        contentView.layer.cornerRadius = 80
        
        diaryTitleTextField.textAlignment = .center
        diaryTitleTextField.alpha = 0.5
        diaryTitleTextField.backgroundColor = .white
        diaryTitleTextField.rightViewMode = .always
        diaryTitleTextField.borderStyle = .roundedRect
        diaryTitleTextField.placeholder = "Title.."
        diaryTitleTextField.font = .systemFont(ofSize: 17, weight: .semibold)
        diaryTitleTextField.autocorrectionType = .no

        diaryImageView.layer.borderWidth = 5
        diaryImageView.layer.borderColor = UIColor(red: 0.984081924, green: 0.5641410947, blue: 0.5658608675, alpha: 1).cgColor
        diaryImageView.layer.cornerRadius = 80
    }
}


