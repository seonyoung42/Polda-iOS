//
//  ShowMemoViewController.swift
//  SyPolaroid
//
//  Created by 장선영 on 2021/06/23.
//

import UIKit
import TagListView

class ShowMemoViewController: UIViewController, UITextFieldDelegate, TagListViewDelegate  {
    
    @IBOutlet weak var showBackImage: UIImageView!
    @IBOutlet weak var memoView: UIView!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var memoText: UITextView!
    @IBOutlet weak var TagScroll: UIScrollView!
    @IBOutlet weak var myTagListView: TagListView!
    
    var memo : Memo!
    var cover : Cover!
    var finalImage = UIImage()
    var tagArray = [String]()
    var memoIndex : Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.showBackImage.layer.cornerRadius = 40
        self.titleField.delegate = self
        myTagListView.delegate = self
    
        setTagListView()
        setMemoView()
        setFont()
        
        tagArray = memo?.hashTag ?? []
        myTagListView.addTags(tagArray)
    }
    
    
    
    @IBAction func saveMemo(_ sender: Any) {
        
        let renderer = UIGraphicsImageRenderer(size: memoView.bounds.size)
        let memoImage = renderer.image { ctx in memoView.drawHierarchy(in: memoView.bounds, afterScreenUpdates: true) }
       
        if let image = memo.editedImage {
            finalImage = UIImage(data: image)!
        }
       
        memo.title = titleField.text
        memo.content = memoText.text
        memo.hashTag = tagArray
        memo.memoImage = memoImage.pngData()
        DataManager.shared.saveContext()
        
        guard let navigation = self.presentingViewController as? UINavigationController else {
            return
        }
        self.dismiss(animated: false) {
            navigation.popViewController(animated: true)
        }
    }
    

    @IBAction func goBack(_ sender: Any) {
        guard  let pvc = presentingViewController else { return }
    
        self.dismiss(animated: true) {
            pvc.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func TapTagList(_ sender: Any) {
        let alert = UIAlertController(title: "태그를 추가하세요", message: "", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { (ok) in
            guard let userInput = alert.textFields?[0].text, !userInput.isEmpty else {
                ok.isEnabled = false
                return
            }
            self.myTagListView.addTag(userInput)
            self.tagArray.append(userInput)
        }
        let cancel = UIAlertAction(title: "cancel", style: .cancel)

        alert.addAction(cancel)
        alert.addAction(ok)
        alert.addTextField()
        self.present(alert, animated: true, completion: nil)
    }
    
    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
        sender.removeTagView(tagView)

        for i in 0..<tagArray.count {
            if tagArray[i] == title {
                tagArray.remove(at: i)
                break
            }
        }
        print(tagArray)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titleField.resignFirstResponder()
        return true
    }
    
    //터치 시 키보드 내려감
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

// > Custom Functions
extension ShowMemoViewController {
    
    func setTagListView() {
        myTagListView.isUserInteractionEnabled = true

        myTagListView.marginX = 10
        myTagListView.enableRemoveButton = true
        myTagListView.tagBackgroundColor = #colorLiteral(red: 1, green: 0.918815136, blue: 0.9157708287, alpha: 1)
        myTagListView.borderColor = #colorLiteral(red: 1, green: 0.7921494842, blue: 0.7917907834, alpha: 1)
        myTagListView.accessibilityScroll(.down)
        myTagListView.borderWidth = 1.5
        myTagListView.cornerRadius = 12
        myTagListView.textColor = UIColor.darkGray
        myTagListView.removeIconLineColor = UIColor.lightGray
        
        TagScroll.layer.borderWidth = 1.5
        TagScroll.layer.borderColor = #colorLiteral(red: 1, green: 0.7921494842, blue: 0.7917907834, alpha: 1)
    }
    
    func setMemoView() {
        memoText.text = memo?.content
        memoText.isUserInteractionEnabled = true
        
        titleField.text = memo?.title
        titleField.isUserInteractionEnabled = true
        titleField.backgroundColor = #colorLiteral(red: 1, green: 0.7921494842, blue: 0.7917907834, alpha: 1)
        
        // > add shadow
        memoView.layer.shouldRasterize = true
        memoView.layer.shadowOpacity = 0.2
        memoView.layer.shadowRadius = 8
        memoView.layer.shadowOffset = CGSize(width: 10, height: 10)
        
        memoText.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        memoText.layer.borderWidth = 1.5
        memoText.layer.borderColor = #colorLiteral(red: 1, green: 0.7921494842, blue: 0.7917907834, alpha: 1)
        
    }
    
    func setFont() {
        let defaultSize = UIFont.systemFontSize
        let defaultFont = UIFont.systemFont(ofSize: defaultSize).familyName

        titleField.font = UIFont.init(descriptor: .init(name: memo.fontName ?? defaultFont, size: defaultSize), size: defaultSize)
        memoText.font = UIFont.init(descriptor: .init(name: memo.fontName ?? defaultFont, size: defaultSize), size: defaultSize)
    }
}
