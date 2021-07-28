//
//  InnerVisibilityTrackableCollectionViewModel.swift
//  
//
//  Created by NohEunTae on 2021/07/01.
//
//

#if os(iOS)
import Foundation

extension VisibilityTrackableCollectionView {
    
    final class InnerViewModel {
        let key: IndexPath
        var data = ViewModel()
        var isNeedRefresh: Bool = false
        
        init(key: IndexPath) {
            self.key = key
        }

    }

}
#endif
