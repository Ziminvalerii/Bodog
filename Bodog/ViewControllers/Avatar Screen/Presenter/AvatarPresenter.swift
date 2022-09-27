//
//  AvatarPresenter.swift
//  Bodog
//
//  Created by Anastasia Koldunova on 15.09.2022.
//

import UIKit


protocol AvatarUpdate {
    func updateImage(with image: UIImage)
}

protocol AvatarViewProtocol : AnyObject {
    func reloadData()
}


protocol AvatarPresenterProtocol : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    init(view: AvatarViewProtocol, router: RouterProtocol, delegate: AvatarUpdate?)
    func goBack(form vc: UIViewController)
}


class AvatarPresenter : NSObject, AvatarPresenterProtocol {
    
    weak var view: AvatarViewProtocol?
    var delegate: AvatarUpdate?
    var imageArray: [UIImage] = [UIImage]()
    private var router: RouterProtocol
    
    required init(view: AvatarViewProtocol, router: RouterProtocol, delegate: AvatarUpdate?) {
        self.view = view
        self.router = router
        self.delegate = delegate
        super.init()
        self.createImageArray()
    }
    //MARK: - Methods
    func createImageArray() {
        let imageCount = Constants.personsCount
        for i in 0 ... imageCount - 1 {
            let person = "person\(i.description)"
            let image = UIImage(named: person)
            imageArray.append(image ?? UIImage(named: "person0")!)
        }
        view?.reloadData()
    }
    //MARK: - Navigation
    func goBack(form vc: UIViewController) {
        router.dismissCurrentVC(vc)
    }
    
}
//MARK: - Collection View Set UP

extension AvatarPresenter : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "image_cell", for: indexPath) as! AvatarCollectionViewCell
        let data = imageArray[indexPath.row]
        cell.configureCell(with: data)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = 100
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        Defaults.imageIndex = indexPath.row
        guard let delegate = delegate else { return }
        delegate.updateImage(with: imageArray[indexPath.row])
    }
    
    
}

