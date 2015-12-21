//
//  SimpleGenericCollectionViewAdapter.swift
//  Pods
//
//  Created by Haizhen Lee on 15/11/8.
//
//

import UIKit


public class SimpleGenericCollectionViewAdapter<T:BXModelAware,V:UICollectionViewCell where V:BXBindable >: SimpleGenericDataSource<T>,UICollectionViewDelegate{
    public let collectionView:UICollectionView
    public var didSelectedItem: DidSelectedItemBlock?
    
    public init(collectionView:UICollectionView,items:[T] = []){
        self.collectionView = collectionView
        super.init(items: items)
        collectionView.delegate = self
        collectionView.dataSource = self
      self.reuseIdentifier = simpleClassName(V)+"_cell"
      if V.hasNib{
        collectionView.registerNib(V.nib(), forCellWithReuseIdentifier: reuseIdentifier)
      }else{
        collectionView.registerClass(V.self, forCellWithReuseIdentifier: reuseIdentifier)
      }
    }
  
    public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.didSelectedItem?(itemAtIndexPath(indexPath),atIndexPath:indexPath)
    }
    
    public override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(self.reuseIdentifier, forIndexPath: indexPath) as! V
        let model = itemAtIndexPath(indexPath)
        if let m = model as? V.ModelType{
            cell.bind(m)
        }
        return cell
    }
    
  
  
    public override func updateItems<S : SequenceType where S.Generator.Element == ItemType>(items: S) {
          super.updateItems(items)
          collectionView.reloadData()
    }
    
 
  
  public override func appendItems<S : SequenceType where S.Generator.Element == ItemType>(items: S) {
    super.appendItems(items)
    collectionView.reloadData()
  }
  
  
  
}