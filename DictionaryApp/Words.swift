//
//  Words.swift
//  DictionaryApp
//
//  Created by Burak Yılmaz on 11.09.2022.
//

import Foundation

class Words {
    var kelime_id:String?
    var ingilizce:String?
    var turkce: String?
    
    init() {
    }
    
    init(kelime_id:String,ingilizce:String,turkce:String) {
        self.kelime_id = kelime_id
        self.ingilizce = ingilizce
        self.turkce = turkce
    }
}
