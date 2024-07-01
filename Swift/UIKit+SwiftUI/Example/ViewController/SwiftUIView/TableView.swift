//
//  File.swift
//  Example
//
//  Created by William.Weng on 2024/7/1.
//

import SwiftUI

struct Staff: Identifiable {
    let id = UUID()
    let name: String
    let position: String
    let phone: String
}

struct TableView: View {

    private let members: [Staff] = [
        .init(name: "Vanessa Ramos", position: "Software Engineer", phone: "2349-233-323"),
        .init(name: "Margarita Vicente", position: "Senior Software Engineer", phone: "2332-333-423"),
        .init(name: "Yara Hale", position: "Development Manager", phone: "2532-293-623"),
        .init(name: "Carlo Tyson", position: "Business Analyst", phone: "2399-633-899"),
        .init(name: "Ashwin Denton", position: "Software Engineer", phone: "2741-333-623")
    ]
    
    var body: some View {
        
        Table(members) {
            TableColumn("Name", value: \.name)
            TableColumn("Position", value: \.position)
            TableColumn("Phone", value: \.phone)
        }
    }
}

#Preview {
    TableView()
}
