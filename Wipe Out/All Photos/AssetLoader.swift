//
//  AssetLoader.swift
//  Wipe Out
//
//  Created by Angelina Staeck on 04.10.22.
//

import Photos

final class AssetLoader {
    private let photoLibrary: PHPhotoLibrary

    init(photoLibrary: PHPhotoLibrary = PHPhotoLibrary.shared()) {
        self.photoLibrary = photoLibrary
    }
    
    func fetch() async throws -> [PHAsset] {
        return try await withCheckedThrowingContinuation { continuation in
            fetch() { result in
                continuation.resume(with: result)
            }
        }
    }
    
    func delete(assets: [PHAsset]) async throws -> Bool {
        return try await withCheckedThrowingContinuation { continuation in
            delete(assets: assets) { result in
                continuation.resume(with: result)
            }
        }
    }
    
    // MARK: - Private
    
    private func delete(assets: [PHAsset], completion: @escaping (Result<Bool, Error>) -> Void) {
        photoLibrary.performChanges({
            PHAssetChangeRequest.deleteAssets(assets as NSArray)
        }, completionHandler: { success, _ in
            completion(.success(success))
        })
    }
    
    private func fetch(completion: @escaping (Result<[PHAsset], Error>) -> Void) {
        getPermissionIfNecessary { granted in
          guard granted else { return }
            let allPhotosOptions = PHFetchOptions()
            allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]

            let fetchedAssets = PHAsset.fetchAssets(with: allPhotosOptions)
            var assets: [PHAsset] = []
            fetchedAssets.enumerateObjects { (asset, _, _) -> Void in
                assets.append(asset)
            }
            completion(.success(assets))
        }
    }
    
    private func getPermissionIfNecessary(completion: @escaping (Bool) -> Void) {
        guard PHPhotoLibrary.authorizationStatus() != .authorized else {
            completion(true)
            return
        }
        
        PHPhotoLibrary.requestAuthorization { status in
            completion(status == .authorized ? true : false)
        }
    }
}
