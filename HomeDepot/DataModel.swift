//
//  DataModel.swift
//  HomeDepot
//
//  Created by Madhu on 3/17/18.
//  Copyright © 2018 Madhu. All rights reserved.
//

import Foundation

struct DataModel : Codable{
    let name : String?
    let description : String?
    let created_at : String?
    let license : String?

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .name)
        description = try values.decodeIfPresent(String.self, forKey: .description) ?? ""
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at) ?? ""
        license = "Null"
    }
}
