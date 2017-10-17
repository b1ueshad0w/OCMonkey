//
//  XCTestPrivateSymbols.h
//  OCMonkeyLib
//
//  Created by gogleyin on 12/10/2017.
//

#import <Foundation/Foundation.h>

@protocol XCDebugLogDelegate;

/*! Accessibility identifier for isVisible attribute */
extern NSNumber *GG_XCAXAIsVisibleAttribute;

/*! Accessibility identifier for is accessible attribute */
extern NSNumber *GG_XCAXAIsElementAttribute;
/**
 Method used to retrieve pointer for given symbol 'name' from given 'binary'
 
 @param name name of the symbol
 @return pointer to symbol
 */
void *GGRetrieveXCTestSymbol(const char *name);

/*! Static constructor that will retrieve XCTest private symbols */
__attribute__((constructor)) void GGLoadXCTestSymbols(void);
