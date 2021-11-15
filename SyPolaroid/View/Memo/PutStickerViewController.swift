//
//  PutStickerViewController.swift
//  SyPolaroid
//
//  Created by 장선영 on 2021/05/19.
//

import UIKit

protocol SendDataDelegate {
    func sendData(image:UIImage)
}

class PutStickerViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mySegment: UISegmentedControl!

    var delegate : SendDataDelegate?
    var celldatasource = ["heart1#red","heart1#yellow","heart1#green","heart1#blue","heart1#pink","heart1#red","heart1#brown","heart2#red","heart2#yellow","heart2#green","heart2#blue","heart2#pink","heart2#red","heart2#brown","ellipse#red","ellipse#yellow","ellipse#green","ellipse#blue","ellipse#pink","ellipse#red","ellipse#brown","ribbon#red","ribbon#yellow","ribbon#green","ribbon#blue","ribbon#pink","ribbon#brown"]
    let width : Double = Double((UIScreen.main.bounds.width)/5.5)

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        collectionView.layer.cornerRadius = 10
        view.layer.cornerRadius = 10
        view.backgroundColor = #colorLiteral(red: 1, green: 0.7921494842, blue: 0.7917907834, alpha: 1)
        

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: width, height: width)
        flowLayout.minimumLineSpacing = 20
        flowLayout.minimumInteritemSpacing = 20
        self.collectionView.collectionViewLayout = flowLayout
        
        setSegment()
    }
    
    func setSegment() {
        
        setSegmentImage(imageName: "Union", segmentNum: 0)
        setSegmentImage(imageName: "Ellipse 13", segmentNum: 1)
        setSegmentImage(imageName: "Star 2", segmentNum: 2)
        setSegmentImage(imageName: "Polygon 1", segmentNum: 3)
        setSegmentImage(imageName: "stickerCategory", segmentNum: 4)
        
        mySegment.selectedSegmentIndex = 0
        mySegment.selectedSegmentTintColor = #colorLiteral(red: 0.9818590283, green: 0.8747641444, blue: 0.8722032309, alpha: 1)
        mySegment.tintColor = #colorLiteral(red: 1, green: 0.7921494842, blue: 0.7917907834, alpha: 1)
        mySegment.backgroundColor = UIColor.white

    }
    
    func setSegmentImage(imageName: String, segmentNum: Int) {
        let image = UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal)
        mySegment.setImage(image, forSegmentAt: segmentNum)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        celldatasource.count
    }
    
    @IBAction func onCollectionViewTypeChanged(_ sender: UISegmentedControl) {
    
        switch sender.selectedSegmentIndex {
        case 0:
            self.celldatasource = ["heart1#red","heart1#yellow","heart1#green","heart1#blue","heart1#pink","heart1#red","heart1#brown","heart2#red","heart2#yellow","heart2#green","heart2#blue","heart2#pink","heart2#red","heart2#brown","ellipse#red","ellipse#yellow","ellipse#green","ellipse#blue","ellipse#pink","ellipse#red","ellipse#brown","ribbon#red","ribbon#yellow","ribbon#green","ribbon#blue","ribbon#pink","ribbon#brown"]
            collectionView.reloadData()
            
        case 1:
            self.celldatasource = ["flower1#red","flower1#yellow","flower1#green","flower1#blue","flower1#pink","flower1#brown","pollie1#red","pollie1#yellow","pollie1#green","pollie1#blue","pollie1#pink","pollie1#brown","pollie2#red","pollie2#yellow","pollie2#green","pollie2#blue","pollie2#pink","pollie2#brown"]
            collectionView.reloadData()
            
        case 2:
            self.celldatasource = ["alphabets_50","alphabets_51","alphabets_52","alphabets_53","alphabets_54","alphabets_55","alphabets_56","alphabets_57","alphabets_58","alphabets_59","alphabets_60","alphabets_61","alphabets_62","alphabets_63","alphabets_164","alphabets_64","alphabets_65","alphabets_66","alphabets_67","alphabets_68","alphabets_69","alphabets_70","alphabets_71","alphabets_72","alphabets_73","alphabets_74","alphabets_129","alphabets_130","alphabets_131","alphabets_133","alphabets_136","alphabets_137","alphabets_138","alphabets_140","alphabets_162","alphabets_160","alphabets_147","alphabets_155","alphabets_150","alphabets_151","alphabets_152","alphabets_153","alphabets_157","alphabets_159"]
            collectionView.reloadData()
            
        case 3:
            self.celldatasource = ["circled_01","circled_02","circled_03","circled_04","circled_05","circled_06","circled_alphabets_07","circled_alphabets_08","circled_alphabets_09","circled_alphabets_10","circled_alphabets_11","circled_alphabets_12","circled_alphabets_19","circled_alphabets_20","circled_alphabets_21","circled_alphabets_22","circled_alphabets_23","circled_alphabets_24","circled_alphabets_30","circled_alphabets_31","circled_alphabets_32","circled_alphabets_33","circled_alphabets_34","circled_alphabets_35","circled_alphabets_41","circled_alphabets_42","circled_alphabets_43","circled_alphabets_44","circled_alphabets_45","circled_alphabets_46","circled_alphabets_52","circled_alphabets_53","circled_alphabets_54","circled_alphabets_56","circled_alphabets_58","circled_alphabets_59"]
            collectionView.reloadData()
        case 4:
            self.celldatasource = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","#1","#2","#3","#4","#5","#6","#7","#8","#9","#10","#11","#12","#13","#14","#16","#17","#18"]
            collectionView.reloadData()
        default :
           break
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell : PutStickerCell = collectionView.dequeueReusableCell(withReuseIdentifier: "putStickerCell", for: indexPath) as? PutStickerCell  else {
            print("error")
            return UICollectionViewCell()
        }
        
        cell.stickerImage.image = UIImage(named: celldatasource[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let image = celldatasource[indexPath.row]
        delegate?.sendData(image:UIImage(named: image)!)
    }
}

class PutStickerCell : UICollectionViewCell  {
    @IBOutlet weak var stickerImage: UIImageView!
}
