//
//  LotameUtils.h
//  Lotame
//
//  Created by Dhawal on 10/06/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LotameUtils : NSObject

+ (NSArray *)getUrlConfig:(NSString *)urlType withConfig:(NSDictionary *)configMap;
+ (NSDictionary *)getMappingConfig:(NSDictionary *)configMap;
@end

NS_ASSUME_NONNULL_END
