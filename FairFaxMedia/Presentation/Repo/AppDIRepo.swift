//
//  AppDIRepo.swift
//  FairFaxMedia
//
//  Created by bindu.ojha on 4/06/23.
//

import Foundation

// This Repo is exposed by Presentation layer
// Presentation Layer cannot access app layer data hence expose this protocol
// App layer adopt and confirm this protocol to provide data to Presentation layer


/// Dependencies passed down from AppLayer to Presentation Layer
protocol AppDIRepo{
    func articleViewDependencies()->ArticleViewModel
}
