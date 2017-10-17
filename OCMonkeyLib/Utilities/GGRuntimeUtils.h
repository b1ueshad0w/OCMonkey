//
//  GGRuntimeUtils.h
//  OCMonkeyLib
//
//  Created by gogleyin on 12/10/2017.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

NSArray<Class> *GGClassesThatConformsToProtocol(Protocol *protocol);

void *GGRetrieveSymbolFromBinary(const char *binary, const char *name);

NS_ASSUME_NONNULL_END
