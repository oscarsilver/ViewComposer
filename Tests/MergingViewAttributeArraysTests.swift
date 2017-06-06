//
//  MergingViewAttributeArraysTests.swift
//  ViewComposer
//
//  Created by Alexander Cyon on 2017-06-01.
//
//

import XCTest
@testable import ViewComposer

class MergeResultingInAttributeArrayTests: XCTestCase {
    func testMergeCountMasterArray() {
        let attr1: [ViewAttribute] = [.text(text), .backgroundColor(color)]
        let attr2: [ViewAttribute] = [.isHidden(isHidden)]
        let mergeMaster2: ViewStyle = attr1.merge(master: attr2) // declaring type is not needed
        XCTAssert(mergeMaster2.count == 3)
        let mergeMaster1 = attr2.merge(master: attr1)
        XCTAssert(type(of: mergeMaster1) == ViewStyle.self)
        XCTAssert(mergeMaster1.count == 3)
    }
    
    func testMergeCountSlaveArray() {
        let attr1: [ViewAttribute] = [.text(text), .backgroundColor(color)]
        let attr2: [ViewAttribute] = [.isHidden(isHidden)]
        let mergeSlave2 = attr1.merge(slave: attr2)
        XCTAssert(mergeSlave2.count == 3)
        let mergeSlave1 = attr2.merge(slave: attr1)
        XCTAssert(mergeSlave1.count == 3)
    }
    
    func testMergeOperatorCountMasterArray() {
        let attr1: [ViewAttribute] = [.text(text), .backgroundColor(color)]
        let attr2: [ViewAttribute] = [.isHidden(isHidden)]
        let mergeMaster2 = attr1 <<- attr2
        XCTAssert(mergeMaster2.count == 3)
        let mergeMaster1 = attr2 <<- attr1
        XCTAssert(mergeMaster1.count == 3)
    }
    
    func testMergeOperatorCountSlaveArray() {
        let attr1: [ViewAttribute] = [.text(text), .backgroundColor(color)]
        let attr2: [ViewAttribute] = [.isHidden(isHidden)]
        let mergeSlave2 = attr1 <- attr2
        XCTAssert(mergeSlave2.count == 3)
        let mergeSlave1 = attr2 <- attr1
        XCTAssert(mergeSlave1.count == 3)
    }
    
    func testMergeArrays() {
        let fooAttr: [ViewAttribute] = [.text(foo), .backgroundColor(color)]
        let barAttr: [ViewAttribute] = [.text(bar), .isHidden(isHidden)]
        let fooMasterUsingSlave = fooAttr.merge(slave: barAttr)
        let fooMasterUsingMaster = barAttr.merge(master: fooAttr)
        let barMasterUsingSlave = barAttr.merge(slave: fooAttr)
        let barMasterUsingMaster = fooAttr.merge(master: barAttr)
        let attrs = [fooMasterUsingSlave, fooMasterUsingMaster, barMasterUsingSlave, barMasterUsingMaster]
        for attributes in attrs {
            XCTAssert(attributes.count == 3)
            XCTAssert(type(of: attributes) == ViewStyle.self)
            XCTAssert(attributes.contains(.backgroundColor))
            XCTAssert(attributes.contains(.isHidden))
            XCTAssert(attributes.contains(.text))
        }
        XCTAssert(fooMasterUsingSlave.associatedValue(.text) == foo)
        XCTAssert(fooMasterUsingMaster.associatedValue(.text) == foo)
        XCTAssert(barMasterUsingSlave.associatedValue(.text) == bar)
        XCTAssert(barMasterUsingMaster.associatedValue(.text) == bar)
    }
    
    func testMergeArraysOperators() {
        let fooAttr: [ViewAttribute] = [.text(foo), .backgroundColor(color)]
        let barAttr: [ViewAttribute] = [.text(bar), .isHidden(isHidden)]
        let fooMasterUsingSlave = fooAttr <- barAttr
        let fooMasterUsingMaster = barAttr <<- fooAttr
        let barMasterUsingSlave = barAttr <- fooAttr
        let barMasterUsingMaster = fooAttr <<- barAttr
        let attrs = [fooMasterUsingSlave, fooMasterUsingMaster, barMasterUsingSlave, barMasterUsingMaster]
        for attributes in attrs {
            XCTAssert(attributes.count == 3)
            XCTAssert(type(of: attributes) == ViewStyle.self)
            XCTAssert(attributes.contains(.backgroundColor))
            XCTAssert(attributes.contains(.isHidden))
            XCTAssert(attributes.contains(.text))
        }
        XCTAssert(fooMasterUsingSlave.associatedValue(.text) == foo)
        XCTAssert(fooMasterUsingMaster.associatedValue(.text) == foo)
        XCTAssert(barMasterUsingSlave.associatedValue(.text) == bar)
        XCTAssert(barMasterUsingMaster.associatedValue(.text) == bar)
    }
    
    func testMergeArraysTwoDoublets() {
        let fooAttr: [ViewAttribute] = [.text(foo), .cornerRadius(fooRadius)]
        let barAttr: [ViewAttribute] = [.text(bar), .cornerRadius(barRadius)]
        let fooMasterUsingSlave = fooAttr.merge(slave: barAttr)
        let fooMasterUsingMaster = barAttr.merge(master: fooAttr)
        let barMasterUsingSlave = barAttr.merge(slave: fooAttr)
        let barMasterUsingMaster = fooAttr.merge(master: barAttr)
        let attrs = [fooMasterUsingSlave, fooMasterUsingMaster, barMasterUsingSlave, barMasterUsingMaster]
        for attributes in attrs {
            XCTAssert(attributes.count == 2)
            XCTAssert(type(of: attributes) == ViewStyle.self)
            XCTAssert(attributes.contains(.cornerRadius))
            XCTAssert(attributes.contains(.text))
        }
        XCTAssert(fooMasterUsingSlave.associatedValue(.text) == foo)
        XCTAssert(fooMasterUsingMaster.associatedValue(.text) == foo)
        XCTAssert(barMasterUsingSlave.associatedValue(.text) == bar)
        XCTAssert(barMasterUsingMaster.associatedValue(.text) == bar)
        
        XCTAssert(fooMasterUsingSlave.associatedValue(.cornerRadius) == fooRadius)
        XCTAssert(fooMasterUsingMaster.associatedValue(.cornerRadius) == fooRadius)
        XCTAssert(barMasterUsingSlave.associatedValue(.cornerRadius) == barRadius)
        XCTAssert(barMasterUsingMaster.associatedValue(.cornerRadius) == barRadius)
    }
    
    func testMergeArraysTwoDoubletsOperators() {
        let fooAttr: [ViewAttribute] = [.text(foo), .cornerRadius(fooRadius)]
        let barAttr: [ViewAttribute] = [.text(bar), .cornerRadius(barRadius)]
        let fooMasterUsingSlave = fooAttr <- barAttr
        let fooMasterUsingMaster = barAttr <<- fooAttr
        let barMasterUsingSlave = barAttr <- fooAttr
        let barMasterUsingMaster = fooAttr <<- barAttr
        let attrs = [fooMasterUsingSlave, fooMasterUsingMaster, barMasterUsingSlave, barMasterUsingMaster]
        for attributes in attrs {
            XCTAssert(attributes.count == 2)
            XCTAssert(type(of: attributes) == ViewStyle.self)
            XCTAssert(attributes.contains(.cornerRadius))
            XCTAssert(attributes.contains(.text))
        }
        XCTAssert(fooMasterUsingSlave.associatedValue(.text) == foo)
        XCTAssert(fooMasterUsingMaster.associatedValue(.text) == foo)
        XCTAssert(barMasterUsingSlave.associatedValue(.text) == bar)
        XCTAssert(barMasterUsingMaster.associatedValue(.text) == bar)
        
        XCTAssert(fooMasterUsingSlave.associatedValue(.cornerRadius) == fooRadius)
        XCTAssert(fooMasterUsingMaster.associatedValue(.cornerRadius) == fooRadius)
        XCTAssert(barMasterUsingSlave.associatedValue(.cornerRadius) == barRadius)
        XCTAssert(barMasterUsingMaster.associatedValue(.cornerRadius) == barRadius)
    }
    
    func testMergeArraysOneIsEmpty() {
        let fooAttr: [ViewAttribute] = [.text(foo), .cornerRadius(fooRadius)]
        let barAttr: [ViewAttribute] = []
        let fooMasterUsingSlave = fooAttr.merge(slave: barAttr)
        let fooMasterUsingMaster = barAttr.merge(master: fooAttr)
        let barMasterUsingSlave = barAttr.merge(slave: fooAttr)
        let barMasterUsingMaster = fooAttr.merge(master: barAttr)
        let attrs = [fooMasterUsingSlave, fooMasterUsingMaster, barMasterUsingSlave, barMasterUsingMaster]
        for attributes in attrs {
            XCTAssert(attributes.count == 2)
            XCTAssert(type(of: attributes) == ViewStyle.self)
            XCTAssert(attributes.contains(.cornerRadius))
            XCTAssert(attributes.contains(.text))
            XCTAssert(attributes.associatedValue(.text) == foo)
            XCTAssert(attributes.associatedValue(.cornerRadius) == fooRadius)
        }
    }
    
    func testMergeArraysOperatorOneIsEmpty() {
        let fooAttr: [ViewAttribute] = [.text(foo), .cornerRadius(fooRadius)]
        let barAttr: [ViewAttribute] = []
        let fooMasterUsingSlave = fooAttr <- barAttr
        let fooMasterUsingMaster = barAttr <<- fooAttr
        let barMasterUsingSlave = barAttr <- fooAttr
        let barMasterUsingMaster = fooAttr <<- barAttr
        let attrs = [fooMasterUsingSlave, fooMasterUsingMaster, barMasterUsingSlave, barMasterUsingMaster]
        for attributes in attrs {
            XCTAssert(attributes.count == 2)
            XCTAssert(type(of: attributes) == ViewStyle.self)
            XCTAssert(attributes.contains(.cornerRadius))
            XCTAssert(attributes.contains(.text))
            XCTAssert(attributes.associatedValue(.text) == foo)
            XCTAssert(attributes.associatedValue(.cornerRadius) == fooRadius)
        }
    }
    
    func testMergeArrayWithSingleAttribute() {
        let array: [ViewAttribute] = [.text(foo), .cornerRadius(fooRadius)]
        let single: ViewAttribute = .backgroundColor(color)
        let arrayIsMasterUsingSlave = array.merge(slave: single)
        let arrayIsMasterUsingMaster = single.merge(master: array)
        let singleAttributeIsMasterUsingSlave = single.merge(slave: array)
        let singleAttributeIsMasterUsingMaster = array.merge(master: single)
        let attrs = [arrayIsMasterUsingSlave, arrayIsMasterUsingMaster, singleAttributeIsMasterUsingSlave, singleAttributeIsMasterUsingMaster]
        for attributes in attrs {
            XCTAssert(attributes.count == 3)
            XCTAssert(type(of: attributes) == ViewStyle.self)
            XCTAssert(attributes.contains(.cornerRadius))
            XCTAssert(attributes.contains(.text))
            XCTAssert(attributes.contains(.backgroundColor))
            XCTAssert(attributes.associatedValue(.text) == foo)
            XCTAssert(attributes.associatedValue(.cornerRadius) == fooRadius)
        }
    }
    
    func testMergeOperatorArrayWithSingleAttribute() {
        let array: [ViewAttribute] = [.text(foo), .cornerRadius(fooRadius)]
        let single: ViewAttribute = .backgroundColor(color)
        let arrayIsMasterUsingSlave = array <- single
        let arrayIsMasterUsingMaster = single <<- array
        let singleAttributeIsMasterUsingSlave = single <- array
        let singleAttributeIsMasterUsingMaster = array <<- single
        let attrs = [arrayIsMasterUsingSlave, arrayIsMasterUsingMaster, singleAttributeIsMasterUsingSlave, singleAttributeIsMasterUsingMaster]
        for attributes in attrs {
            XCTAssert(attributes.count == 3)
            XCTAssert(type(of: attributes) == ViewStyle.self)
            XCTAssert(attributes.contains(.cornerRadius))
            XCTAssert(attributes.contains(.text))
            XCTAssert(attributes.contains(.backgroundColor))
            XCTAssert(attributes.associatedValue(.text) == foo)
            XCTAssert(attributes.associatedValue(.cornerRadius) == fooRadius)
        }
    }
    
    func testMergeLhsEmptyArrayRhsSingleAttribute() {
        let array: [ViewAttribute] = []
        let single: ViewAttribute = .text(foo)
        let arrayIsMasterUsingSlave = array.merge(slave: single)
        let arrayIsMasterUsingMaster = single.merge(master: array)
        let singleAttributeIsMasterUsingSlave = single.merge(slave: array)
        let singleAttributeIsMasterUsingMaster = array.merge(master: single)
        let attrs = [arrayIsMasterUsingSlave, arrayIsMasterUsingMaster, singleAttributeIsMasterUsingSlave, singleAttributeIsMasterUsingMaster]
        for attributes in attrs {
            XCTAssert(attributes.count == 1)
            XCTAssert(type(of: attributes) == ViewStyle.self)
            XCTAssert(attributes.contains(.text))
            XCTAssert(attributes.associatedValue(.text) == foo)
        }
    }
    
    func testMergeOperatorLhsEmptyArrayRhsSingleAttribute() {
        let array: [ViewAttribute] = []
        let single: ViewAttribute = .text(foo)
        let arrayIsMasterUsingSlave = array <- single
        let arrayIsMasterUsingMaster = single <<- array
        let singleAttributeIsMasterUsingSlave = single <- array
        let singleAttributeIsMasterUsingMaster = array <<- single
        let attrs = [arrayIsMasterUsingSlave, arrayIsMasterUsingMaster, singleAttributeIsMasterUsingSlave, singleAttributeIsMasterUsingMaster]
        for attributes in attrs {
            XCTAssert(attributes.count == 1)
            XCTAssert(type(of: attributes) == ViewStyle.self)
            XCTAssert(attributes.contains(.text))
            XCTAssert(attributes.associatedValue(.text) == foo)
        }
    }
    
    func testMergeArrayWithSingleAttributeDoublets() {
        let fooArray: [ViewAttribute] = [.text(foo), .cornerRadius(fooRadius)]
        let barSingle: ViewAttribute = .text(bar)
        let fooIsMasterUsingSlave = fooArray.merge(slave: barSingle)
        let fooIsMasterUsingMaster = barSingle.merge(master: fooArray)
        let barAttributeIsMasterUsingSlave = barSingle.merge(slave: fooArray)
        let barAttributeIsMasterUsingMaster = fooArray.merge(master: barSingle)
        let attrs = [fooIsMasterUsingSlave, fooIsMasterUsingMaster, barAttributeIsMasterUsingSlave, barAttributeIsMasterUsingMaster]
        for attributes in attrs {
            XCTAssert(attributes.count == 2)
            XCTAssert(type(of: attributes) == ViewStyle.self)
            XCTAssert(attributes.contains(.cornerRadius))
            XCTAssert(attributes.contains(.text))
        }
        XCTAssert(fooIsMasterUsingSlave.associatedValue(.text) == foo)
        XCTAssert(fooIsMasterUsingMaster.associatedValue(.text) == foo)
        XCTAssert(barAttributeIsMasterUsingSlave.associatedValue(.text) == bar)
        XCTAssert(barAttributeIsMasterUsingMaster.associatedValue(.text) == bar)
    }
    
    func testMergeOperatorArrayWithSingleAttributeDoublets() {
        let fooArray: [ViewAttribute] = [.text(foo), .cornerRadius(fooRadius)]
        let barSingle: ViewAttribute = .text(bar)
        let fooIsMasterUsingSlave = fooArray <- barSingle
        let fooIsMasterUsingMaster = barSingle <<- fooArray
        let barAttributeIsMasterUsingSlave = barSingle <- fooArray
        let barAttributeIsMasterUsingMaster = fooArray <<- barSingle
        let attrs = [fooIsMasterUsingSlave, fooIsMasterUsingMaster, barAttributeIsMasterUsingSlave, barAttributeIsMasterUsingMaster]
        for attributes in attrs {
            XCTAssert(attributes.count == 2)
            XCTAssert(type(of: attributes) == ViewStyle.self)
            XCTAssert(attributes.contains(.cornerRadius))
            XCTAssert(attributes.contains(.text))
        }
        XCTAssert(fooIsMasterUsingSlave.associatedValue(.text) == foo)
        XCTAssert(fooIsMasterUsingMaster.associatedValue(.text) == foo)
        XCTAssert(barAttributeIsMasterUsingSlave.associatedValue(.text) == bar)
        XCTAssert(barAttributeIsMasterUsingMaster.associatedValue(.text) == bar)
    }
    
    func testMergeSinglesNoDoublets() {
        let fooAttribute: ViewAttribute = .cornerRadius(fooRadius)
        let barAttribute: ViewAttribute = .text(bar)
        let fooIsMasterUsingSlave = fooAttribute.merge(slave: barAttribute)
        let fooIsMasterUsingMaster = barAttribute.merge(master: fooAttribute)
        let barAttributeIsMasterUsingSlave = barAttribute.merge(slave: fooAttribute)
        let barAttributeIsMasterUsingMaster = fooAttribute.merge(master: barAttribute)
        let attrs = [fooIsMasterUsingSlave, fooIsMasterUsingMaster, barAttributeIsMasterUsingSlave, barAttributeIsMasterUsingMaster]
        for attributes in attrs {
            XCTAssert(attributes.count == 2)
            XCTAssert(type(of: attributes) == ViewStyle.self)
            XCTAssert(attributes.contains(.cornerRadius))
            XCTAssert(attributes.contains(.text))
            XCTAssert(attributes.associatedValue(.text) == bar)
            XCTAssert(attributes.associatedValue(.cornerRadius) == fooRadius)
        }
    }
    
    func testMergeOperatorSinglesNoDoublets() {
        let fooAttribute: ViewAttribute = .cornerRadius(fooRadius)
        let barAttribute: ViewAttribute = .text(bar)
        let fooIsMasterUsingSlave = fooAttribute <- barAttribute
        let fooIsMasterUsingMaster = barAttribute <<- fooAttribute
        let barAttributeIsMasterUsingSlave = barAttribute <- fooAttribute
        let barAttributeIsMasterUsingMaster = fooAttribute <<- barAttribute
        let attrs = [fooIsMasterUsingSlave, fooIsMasterUsingMaster, barAttributeIsMasterUsingSlave, barAttributeIsMasterUsingMaster]
        for attributes in attrs {
            XCTAssert(attributes.count == 2)
            XCTAssert(type(of: attributes) == ViewStyle.self)
            XCTAssert(attributes.contains(.cornerRadius))
            XCTAssert(attributes.contains(.text))
            XCTAssert(attributes.associatedValue(.text) == bar)
            XCTAssert(attributes.associatedValue(.cornerRadius) == fooRadius)
        }
    }
    
    func testMergeSinglesDoublets() {
        let fooAttribute: ViewAttribute = .text(foo)
        let barAttribute: ViewAttribute = .text(bar)
        let fooIsMasterUsingSlave = fooAttribute.merge(slave: barAttribute)
        let fooIsMasterUsingMaster = barAttribute.merge(master: fooAttribute)
        let barAttributeIsMasterUsingSlave = barAttribute.merge(slave: fooAttribute)
        let barAttributeIsMasterUsingMaster = fooAttribute.merge(master: barAttribute)
        let attrs = [fooIsMasterUsingSlave, fooIsMasterUsingMaster, barAttributeIsMasterUsingSlave, barAttributeIsMasterUsingMaster]
        for attributes in attrs {
            XCTAssert(attributes.count == 1)
            XCTAssert(type(of: attributes) == ViewStyle.self)
            XCTAssert(attributes.contains(.text))
        }
        XCTAssert(fooIsMasterUsingSlave.associatedValue(.text) == foo)
        XCTAssert(fooIsMasterUsingMaster.associatedValue(.text) == foo)
        XCTAssert(barAttributeIsMasterUsingSlave.associatedValue(.text) == bar)
        XCTAssert(barAttributeIsMasterUsingMaster.associatedValue(.text) == bar)
    }
    
    func testMergeOperatorSinglesDoublets() {
        let fooAttribute: ViewAttribute = .text(foo)
        let barAttribute: ViewAttribute = .text(bar)
        let fooIsMasterUsingSlave = fooAttribute <- barAttribute
        let fooIsMasterUsingMaster = barAttribute <<- fooAttribute
        let barAttributeIsMasterUsingSlave = barAttribute <- fooAttribute
        let barAttributeIsMasterUsingMaster = fooAttribute <<- barAttribute
        let attrs = [fooIsMasterUsingSlave, fooIsMasterUsingMaster, barAttributeIsMasterUsingSlave, barAttributeIsMasterUsingMaster]
        for attributes in attrs {
            XCTAssert(attributes.count == 1)
            XCTAssert(type(of: attributes) == ViewStyle.self)
            XCTAssert(attributes.contains(.text))
        }
        XCTAssert(fooIsMasterUsingSlave.associatedValue(.text) == foo)
        XCTAssert(fooIsMasterUsingMaster.associatedValue(.text) == foo)
        XCTAssert(barAttributeIsMasterUsingSlave.associatedValue(.text) == bar)
        XCTAssert(barAttributeIsMasterUsingMaster.associatedValue(.text) == bar)
    }
}
