//
//  ViewController.swift
//  SyPolaroid
//
//  Created by 장선영 on 2021/05/04.
//

import UIKit
import JJFloatingActionButton
import CoreData
import SnapKit

class ViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var backTitle: UIImageView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var textfieldButton : UIButton {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "imgae change"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 8)
        button.addTarget(self, action: #selector(presentImagePicker), for: .touchUpInside)
        return button
    }

    private lazy var imagePicker: UIImagePickerController = {
        let picker: UIImagePickerController = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        return picker
    }()
    
    let width = 310.0
    var actionButton: JJFloatingActionButton!
    var searchText : String = ""
    var diaryIndex : Int?
    var buttonStatus = false {
        didSet {
            if buttonStatus {
                DataManager.shared.fetchCoverbyCount()
            } else {
                DataManager.shared.fetchCover()
            }
            self.collectionView.reloadData()
        }
    }
    
    enum Mode {
        case view
        case select
    }
    
    var mMode : Mode = .view {
        didSet {
            switch mMode {
            case .view:
          
                self.actionButton.items[0].buttonImage = UIImage(named: "thrash icon")
                self.actionButton.addItem(title: "개수 순".localized(), image: UIImage(named:"list icon")) { item in
                    
                    self.buttonStatus = !self.buttonStatus
                    
                    if self.buttonStatus {
                        self.actionButton.items[1].titleLabel.text = "최신 순".localized()
                    } else {
                        self.actionButton.items[1].titleLabel.text = "개수 순".localized()
                    }
                }
                
                self.actionButton.addItem(title: "", image: UIImage(named:"add")) { item in
                    DataManager.shared.saveCover(name: "")
                    self.showToast(message: "다이어리가 추가되었어요 ٩(•̤̀ᵕ•̤́๑)ᵒᵏᵎᵎᵎᵎ".localized())
                    self.collectionView.reloadData()
                }
                
            case .select:
                
                self.actionButton.items[0].buttonImage = UIImage(named: "thrash bin 'x'")
                self.actionButton.removeItem(at: 2)
                self.actionButton.removeItem(at: 1)
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.searchBar.delegate = self
        
        attribute()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setNavigationBar()
        
        if self.buttonStatus {
            DataManager.shared.fetchCoverbyCount()
        } else {
            DataManager.shared.fetchCover()
        }
        
        self.collectionView.reloadData()
    }

    @objc func presentImagePicker(sender: UIButton) {
        self.present(imagePicker, animated: true, completion: nil)
        self.diaryIndex = sender.tag
    }
}


// MARK - CollectionView datasource, delegate
extension ViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return DataManager.shared.coverList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       guard let cell : DiaryCell = collectionView.dequeueReusableCell(withReuseIdentifier: "diaryCell", for: indexPath) as? DiaryCell else {
            print("error")
            return UICollectionViewCell()
        }
        
        let cover = DataManager.shared.coverList[indexPath.row]
        cell.setupCell(cover: cover)
        
        cell.diaryTitleTextField.rightView = textfieldButton
        textfieldButton.tag = indexPath.row
 
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch mMode {
        case .view:
            self.collectionView.deselectItem(at: indexPath, animated: true)
            let item = DataManager.shared.coverList[indexPath.row]
            performSegue(withIdentifier: "showList", sender: item)
            
        case .select:
            let deleteCover = DataManager.shared.coverList[indexPath.row]
            showDeleteAlert(deleteCover: deleteCover, indexPath: indexPath)
        }
    }
    
    func showDeleteAlert(deleteCover: Cover, indexPath: IndexPath) {
        let alert = UIAlertController(title: "", message: "해당 다이어리를 삭제하시겠습니까?".localized(), preferredStyle: .alert)
        let okAction = UIAlertAction(title: "삭제".localized(), style: .destructive) {_ in
            DataManager.shared.deleteCover(deleteCover)
            self.showToast(message: "다이어리가 삭제되었어요 ･ᴗ･̥̥̥".localized())
            
            if self.buttonStatus {
                DataManager.shared.fetchCoverbyCount()
            } else {
                DataManager.shared.fetchCover()
            }
            self.collectionView.deleteItems(at: [indexPath])
        }
        
        let cancelAction = UIAlertAction(title: "취소".localized(), style: .cancel) { _ in
            self.collectionView.deselectItem(at: indexPath, animated: true)
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    // > segue 데이터 전달
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showList" {
            let cover = sender
            let vc = segue.destination as? ListViewController
            vc?.cover = cover as? Cover
        }
        
        if segue.identifier == "showTag" {
            let searchDestination = segue.destination as? HashTagListViewController
            searchDestination?.taglist = DataManager.shared.searchTagList
            searchDestination?.tagTitle = sender as! String
        }
    }
    
    // > toast 알림 메시지 띄우기
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


// MARK - ImagePickerController
extension ViewController : UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var imageCover = UIImage()
        if let coverImage : UIImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            imageCover = coverImage
        } else if let originalImage : UIImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageCover = originalImage
        }
        
        guard let diaryIndex = diaryIndex else { return }
        let cover = DataManager.shared.coverList[diaryIndex]
        cover.image = imageCover.pngData()
        DataManager.shared.saveContext()
        
        self.collectionView.reloadData()
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK - SearchBar delegate
extension ViewController : UISearchBarDelegate {
    // > 서치바 action
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let keyword = searchBar.text, !keyword.isEmpty else {
            searchBar.resignFirstResponder()
            return
        }
            
        DataManager.shared.searchTag(keyword: keyword.lowercased())
            
        if DataManager.shared.searchTagList.isEmpty {
            let alert = UIAlertController(title: "", message: "해당 태그는 없습니다.".localized(), preferredStyle: .alert)
            let defalutAction = UIAlertAction(title: "확인".localized(), style: .default) {_ in
                searchBar.resignFirstResponder()
            }
            alert.addAction(defalutAction)
            present(alert, animated: true, completion: nil)
        } else {
            performSegue(withIdentifier: "showTag", sender: keyword)
        }
    }
}


// MARK - UI
private extension ViewController {
    
    func attribute() {
        setSearchBar()
        setFloatingBtn()
        setCollectionViewFlowLayout()
    }
    
    // > 서치바 텍스트필드 설정
    func setSearchBar() {
        searchBar.backgroundImage = UIImage()
        searchBar.placeholder = "태그 검색".localized()
        
        let textFieldInsideSearchBar = self.searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.backgroundColor = #colorLiteral(red: 1, green: 0.918815136, blue: 0.9157708287, alpha: 1)
        textFieldInsideSearchBar?.layer.borderWidth = 2
        textFieldInsideSearchBar?.layer.borderColor = #colorLiteral(red: 1, green: 0.7921494842, blue: 0.7917907834, alpha: 1)
        textFieldInsideSearchBar?.layer.cornerRadius = 10
    }
    
    // > 플로팅버튼 설정
    func setFloatingBtn() {
        actionButton = JJFloatingActionButton()
        actionButton.addItem(title: "", image: UIImage(named: "thrash icon" )) { item in
            self.mMode = self.mMode == .view ? .select : .view
        }
        actionButton.addItem(title: "개수 순".localized(), image: UIImage(named:"list icon")) { item in
            self.buttonStatus = !self.buttonStatus
            
            if self.buttonStatus {
                self.actionButton.items[1].titleLabel.text = "최신 순".localized()
            } else {
                self.actionButton.items[1].titleLabel.text = "개수 순".localized()
            }
        }
        
        actionButton.addItem(title:"", image: UIImage(named: "add")) { item in
            DataManager.shared.saveCover(name:"")
            self.showToast(message: "다이어리가 추가되었어요 ٩(•̤̀ᵕ•̤́๑)ᵒᵏᵎᵎᵎᵎ".localized())
            self.collectionView.reloadData()
        }
        
        view.addSubview(actionButton)
        let safeArea = view.safeAreaLayoutGuide
        actionButton.snp.makeConstraints {
            $0.bottom.equalTo(safeArea)
            $0.trailing.equalTo(safeArea).inset(16)
        }
        
        actionButton.buttonColor = #colorLiteral(red: 0.9809378982, green: 0.5516198277, blue: 0.5537384748, alpha: 1)
        actionButton.buttonImage = UIImage(named: "circle-plus")
        actionButton.configureDefaultItem { item in
            item.buttonColor = .white
        }
    }
    
    // > 네비게이션 바 설정
    func setNavigationBar() {
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.toolbar.isHidden = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    // > CollectionView 셀 크키, 간격 조정
    func setCollectionViewFlowLayout() {
        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 0)
        self.collectionView.backgroundColor = .none
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: width, height: width*1.3)
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 20
        self.collectionView.collectionViewLayout = flowLayout
    }
    
}

