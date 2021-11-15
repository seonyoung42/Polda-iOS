//
//  ListViewController.swift
//  SyPolaroid
//
//  Created by 장선영 on 2021/05/05.
//

import UIKit
import JJFloatingActionButton

class ListViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var ListBackImage: UIImageView!
    let realHeight : Double = Double(UIScreen.main.bounds.height)

    var sectionInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    var collectionViewHeight = Double()
    var cellHeight = Double()
    var cover : Cover?
    var buttonStatus = false
    var actionButton : JJFloatingActionButton!
    var memoIndex : Int!
    
    enum Mode {
        case view
        case select
    }
    
    var mMode : Mode = .view {
        didSet {
            switch mMode {
            case .view:
                self.actionButton.items[0].buttonImage = UIImage(named: "thrash icon")
                self.actionButton.addItem(title: "", image: UIImage(named: "add polaroid icon")) { item in
                    self.goToEdit()
                }
                self.navigationItem.hidesBackButton = false
                
            case .select:
                
                self.actionButton.items[0].buttonImage = UIImage(named:"thrash bin 'x'")
                self.actionButton.removeItem(at: 1)
                self.navigationItem.hidesBackButton = true
        }
    }
        
}
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        super.viewWillAppear(animated)
        self.collectionView.reloadData()
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_gesture:)))
        collectionView.addGestureRecognizer(gesture)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.backgroundColor = .none
        

        self.ListBackImage.layer.cornerRadius = 40
        
        //네비게이션바 세팅
        setNavigationBar()
        
        //셀 크기 조정
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        self.collectionView.collectionViewLayout = flowLayout
        
        
        //floating Action button
        actionButton = JJFloatingActionButton()
        actionButton.addItem(title: "", image: UIImage(named: "thrash icon" )) { [self] item in
            self.mMode = self.mMode == .view ? .select : .view
        }
        actionButton.addItem(title: "", image: UIImage(named: "add polaroid icon")) { item in
                self.goToEdit()
            }

        view.addSubview(actionButton)
        actionButton.buttonColor = #colorLiteral(red: 0.9809378982, green: 0.5516198277, blue: 0.5537384748, alpha: 1)
        actionButton.buttonImage = UIImage(named: "circle-plus")
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
    }
    
    func setNavigationBar() {
        
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.topItem?.title = cover?.name
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.9809378982, green: 0.5516198277, blue: 0.5537384748, alpha: 1)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = ""
    }
    
    func goToEdit() {
        performSegue(withIdentifier: "goToEdit", sender: UIButton())
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMemo" {
            let memo = sender
            let vc = segue.destination as? ShowViewController
            vc?.memo = memo as? Memo
            vc?.cover = cover
            vc?.memoIndex = memoIndex
        }
        
        guard let destination = segue.destination as? EditViewController else {
            return
        }
        destination.cover = cover
    }
}

// 컬렉션 뷰
extension ListViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cover?.memos?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell : PolaroidCell = collectionView.dequeueReusableCell(withReuseIdentifier: "polaroidCell", for: indexPath) as? PolaroidCell  else {
            print("error")
            return UICollectionViewCell()
        }
        
        if let memo = cover?.memos?[indexPath.row], let image = memo.editedImage {
            cell.polaroidImage.image = UIImage(data: image)
            cell.polaroidImage.layer.borderWidth = 3
            cell.polaroidImage.layer.borderColor = #colorLiteral(red: 1, green: 0.7921494842, blue: 0.7917907834, alpha: 1)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        if realHeight < 700 {
            cellHeight = 170
            sectionInsets = UIEdgeInsets(top: 0, left: 20, bottom: 60, right: 0)
            self.collectionView.contentInset = sectionInsets
        } else {
            cellHeight = 200
            sectionInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
            self.collectionView.contentInset = sectionInsets
        }
        return CGSize(width: cellHeight/4.5*4, height: cellHeight)
    }
    

    // > 폴라로이드 삭제
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        switch mMode {
        case .view:
            self.collectionView.deselectItem(at: indexPath, animated: true)
            memoIndex = indexPath.row
            let item = cover?.memos?[memoIndex]
            performSegue(withIdentifier: "showMemo", sender: item)
        case .select:
            let deleteMemo = cover?.memos?[indexPath.row]
            let alert = UIAlertController(title: "", message: "해당 폴라로이드를 삭제하시겠습니까?", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "삭제", style: .destructive) {_ in
                self.cover?.removeFromRawMemos(deleteMemo!)
                self.showToast(message: "폴라로이드가 삭제되었어요 ･ᴗ･̥̥̥")
                self.collectionView.reloadData()
            }
            let cancelAction = UIAlertAction(title: "취소", style: .cancel) {_ in
                collectionView.deselectItem(at: indexPath, animated: true)
            }
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    // 위치 이동
    @objc func handleLongPress(_gesture:UILongPressGestureRecognizer) {
        guard let collectionView = collectionView else {
            return
        }
        
        switch _gesture.state {
        case .began:
            guard let targetIndexPath = collectionView.indexPathForItem(at: _gesture.location(in: collectionView)) else {
                return
            }
            collectionView.beginInteractiveMovementForItem(at: targetIndexPath)
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(_gesture.location(in: collectionView))
        case .ended:
            collectionView.endInteractiveMovement()
        default:
            collectionView.cancelInteractiveMovement()
        }
    }
    
    //reorder
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = cover?.memos?[sourceIndexPath.row]
        cover?.removeFromRawMemos(item!)
        cover?.insertIntoRawMemos(item!, at: destinationIndexPath.row)
    }
    
    func showToast(message : String) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 150, y: self.view.frame.size.height-100, width: 300, height: 35))
        
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds = true
        
        self.view.addSubview(toastLabel)
        
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: { toastLabel.alpha = 0.0 }, completion: {(isCompleted) in toastLabel.removeFromSuperview() })
    }
    
    
}

class PolaroidCell : UICollectionViewCell {
    
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
