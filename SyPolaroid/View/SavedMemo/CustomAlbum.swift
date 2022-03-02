//
//  CustomAlbum.swift
//  SyPolaroid
//
//  Created by 장선영 on 2022/03/02.
//

import UIKit
import Photos

enum CustomAlbumError: Error {
    case notAuthorized
}

class CustomAlbum {
    static let albumName = "Polda"
    static let sharedInstance = CustomAlbum()
    
    private var assetCollection: PHAssetCollection!
    
    init() {
        if let assetCollection = fetchAssetCollectionForAlbum() {
            self.assetCollection = assetCollection
            return
        }
    }
    
    func saveImageToAlbum(image: UIImage, completion: @escaping (Result<Bool,Error>)-> ()) {
        self.checkAuthorizationWithHandler { result in
            switch result {
            case .success(let success):
                
                if success, self.assetCollection != nil {
                    PHPhotoLibrary.shared().performChanges ({
                        let assetChangeRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
                        let assetPlaceHolder = assetChangeRequest.placeholderForCreatedAsset!
                        
                        if let albumeChangeRequest = PHAssetCollectionChangeRequest(for: self.assetCollection) {
                            let enumeration: NSArray = [assetPlaceHolder]
                            albumeChangeRequest.addAssets(enumeration)
                        }
                    }, completionHandler: { success, error in
                        if let error = error {
                            completion(.failure(error))
                            return
                        }
                        completion(.success(success))
                    })
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}

private extension CustomAlbum {
    // 사진첩접근 권한 확인
    func checkAuthorizationWithHandler(completion: @escaping (Result<Bool,Error>) -> ()) {
        if PHPhotoLibrary.authorizationStatus() == .notDetermined {
            PHPhotoLibrary.requestAuthorization { status in
                self.checkAuthorizationWithHandler(completion: completion)
            }
        } else if PHPhotoLibrary.authorizationStatus() == .authorized {
            self.createAlbumIfNeeded { success in
                completion(success)
            }
        } else {
            completion(.failure(CustomAlbumError.notAuthorized))
        }
    }
    
    // Fetch CutomAlbum
    func fetchAssetCollectionForAlbum() -> PHAssetCollection? {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", CustomAlbum.albumName)
        
        let collection = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
        
        if let _: AnyObject = collection.firstObject {
            return collection.firstObject
        }
        return nil
    }
    
    // CustomAlbum 존재여부 확인하고, 없으면 생성
    func createAlbumIfNeeded(completion: @escaping (Result<Bool,Error>) -> ()) {
        if let assetCollection = fetchAssetCollectionForAlbum() {
            self.assetCollection = assetCollection
            completion(.success(true))
        } else {
            PHPhotoLibrary.shared().performChanges {
                PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: CustomAlbum.albumName)
            } completionHandler: { success, error in
                if let error = error {
                    completion(.failure(error))
                }
                
                if success {
                    self.assetCollection = self.fetchAssetCollectionForAlbum()
                    completion(.success(true))
                } else {
                    completion(.success(false))
                }
            }

        }
    }
}
