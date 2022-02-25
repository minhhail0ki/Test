//
//  MainViewController.swift
//  Test
//
//  Created by Le Minh Hai on 23/02/2022.
//

import UIKit

class MainViewController: UIViewController {

    var image: [String] = ["m14", "m00", "p12", "p06", "p07", "p13", "m01", "m15", "m03", "m17", "p05", "p11", "p10", "p04", "m16", "m02", "m06", "m12", "c09", "p14", "p01", "c08", "m13", "m07", "m11", "m05", "p03", "p02", "m04", "m10", "s07", "s13", "w03", "w02", "s12", "s06", "s10", "s04", "w14", "w01", "s05", "s11", "s01", "w05", "w11", "w10", "w04", "s14", "s02", "w12", "w06", "w07", "w13", "s13", "w09", "w08", "s08", "s09", "m09", "m21", "c12", "c06", "c07", "c13", "m20", "m08", "c05", "c11", "c10", "c04", "c14", "p09", "p08", "c01", "m18", "c03", "c02", "m19"]
    var image1: [String] = []
    var isOpen = 0

    var listImageup: [String] = []
    
    @IBOutlet weak var CardCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        image.shuffle()
        CardCollectionView.register(UINib(nibName: "CardCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CardCollectionViewCell")
        CardCollectionView.dataSource = self
        CardCollectionView.delegate = self
        
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(_:)))
        CardCollectionView.addGestureRecognizer(gesture)
    }
    
    @objc func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
        
        guard let collectionview = CardCollectionView else {
            return
        }
        
        switch gesture.state {
        case .began:
            guard let targetIndexPath = collectionview.indexPathForItem(at: gesture.location(in: collectionview)) else {
                return
            }
            
            collectionview.beginInteractiveMovementForItem(at: targetIndexPath)
        case .changed:
            collectionview.updateInteractiveMovementTargetPosition(gesture.location(in: collectionview))
        case .ended:
            collectionview.endInteractiveMovement()
        default:
            collectionview.cancelInteractiveMovement()
        }
    }
    
    @IBAction func BackTapped(){
        
        self.dismiss(animated: true)
    }
    
    @IBAction func SuffleTapped(){
        
        listImageup.removeAll()
        CardCollectionView.reloadData()
    }
}
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return image.count

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCollectionViewCell", for: indexPath) as! CardCollectionViewCell
        if listImageup.contains(image[indexPath.row])
        {
            cell.Card.image = UIImage(named: image[indexPath.row])
        }else
        {
            cell.Card.image = UIImage(named: "bb")
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        
        return UICollectionReusableView()
    }
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = image.remove(at: sourceIndexPath.row)
        image.insert(item, at: destinationIndexPath.row)
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        listImageup.append(image[indexPath.row])
        CardCollectionView.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDevice.current.userInterfaceIdiom == .pad{
            return CGSize(width: self.CardCollectionView.frame.width * 1/8 , height: self.CardCollectionView.frame.height * 1/8)
        }
        return CGSize(width: self.CardCollectionView.frame.width * 1/4 , height: self.CardCollectionView.frame.height * 1/4)
    }
}
