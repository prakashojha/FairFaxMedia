//
//  DataObjectMock.swift
//  FairFaxMediaTests
//
//  Created by bindu.ojha on 5/06/23.
//

import Foundation

struct DataObject: Codable{
    var id: String
       var name: String


       enum CodingKeys: String, CodingKey {
           case id = "Id"
           case name = "Name"

       }

}



