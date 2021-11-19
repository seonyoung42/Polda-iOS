//
//  HashTagListViewController.swift
//  SyPolaroid
//
//  Created by 장선영 on 2021/05/23.
//

import UIKit
import CoreData

class HashTagListViewController: UIViewController {
   
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tagName: UITextField!
    @IBOutlet weak var hashBackImage: UIImageView!
    
    let width : Double = Double((UIScreen.main.bounds.width-50)/2)
    let height : Double = Double((UIScreen.main.bounds.height)/3.5)
    var taglist = [Memo]()
    var tagTitle = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = .none
        self.collectionView.contentInset = UIEdgeInsets(top: 50, left:20, bottom: 50, right:20)
        hashBackImage.layer.cornerRadius = 20
        
        self.navigationController?.navigationBar.topItem?.title = ""
        
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: width, height: width/4*4.5)
        flowLayout.minimumLineSpacing = 20
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.scrollDirection = .vertical
        self.collectionView.collectionViewLayout = flowLayout
        
        tagName.text = "  # \(tagTitle)"
//        tagName.textAlignment = .center
        tagName.layer.borderColor = #colorLiteral(red: 0.9853486419, green: 0.5513027906, blue: 0.5535886288, alpha: 1)
        tagName.layer.borderWidth = 2
        tagName.layer.cornerRadius = 10
        
    }
    
    

}

extension HashTagListViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DataManager.shared.searchTagList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell : hashTagCell = collectionView.dequeueReusableCell(withReuseIdentifier: "hashTagCell", for: indexPath) as? hashTagCell else {
            print("error")
            return UICollectionViewCell()
        }
        
        let memo = DataManager.shared.searchTagList[indexPath.row]
                
        if let image = memo.editedImage {
            cell.hashTagImage.image = UIImage(data: image)
            cell.hashTagImage.layer.borderWidth = 3
            cell.hashTagImage.layer.borderColor = #colorLiteral(red: 1, green: 0.7921494842, blue: 0.7917907834, alpha: 1)
        }

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UICollectionViewCell, let indexPath = collectionView.indexPath(for: cell) {
            if let vc = segue.destination as? ShowViewController {
                vc.memo = DataManager.shared.searchTagList[indexPath.row]
            }
        }
    }
}

class hashTagCell : UICollectionViewCell {
    
    @IBOutlet weak var hashTagView: UIView!
    @IBOutlet weak var hashTagImage: UIImageView!
}

