//
//  LotameUtils.m
//  Lotame
//
//  Created by Dhawal on 10/06/20.
//

#import "LotameUtils.h"

@implementation LotameUtils

+ (NSArray *)convertArrayOfDictsToArray:(NSString *)urlType withArray:(NSMutableArray *)arrayOfDicts {
    NSString* urlKey = [[NSString alloc] initWithFormat:@"%@UrlTemplate", urlType ];
    NSMutableArray* list = [[NSMutableArray alloc] init];
    NSString *value;
    
    for(NSDictionary* url in arrayOfDicts) {
        value = [url objectForKey:urlKey];
        if (value != nil && [value length] > 0) {
            [list addObject:value];
        }
    }
    return [list count] > 0 ? list : nil;
}

+ (NSDictionary *)convertArrayOfDictsToDict:(NSArray *)arrayOfDicts {
    NSMutableDictionary* map = [[NSMutableDictionary alloc] init];
    NSString *key, *value;
    
    for(NSDictionary* node in arrayOfDicts) {
        key = [node objectForKey:@"key"];
        value = [node objectForKey:@"value"];
        if ((key != nil && [key length] > 0) && (value != nil && [value length] > 0)) {
            [map setObject:value forKey:key];
        }
    }
    return [map count] > 0 ? map : nil;
}

+ (NSArray *)getUrlConfig:(NSString *)urlType withConfig:(NSDictionary *)configMap {
    NSString* iFrameKey = [[NSString alloc] initWithFormat:@"%@UrlSettingsIframe", urlType];
    NSString* pixelKey = [[NSString alloc] initWithFormat:@"%@UrlSettingsPixel", urlType];
    
    NSMutableArray* iFrames = [configMap objectForKey:iFrameKey];
    NSMutableArray* pixels = [configMap objectForKey:pixelKey];
    
    NSMutableArray* urlList = nil;
    if (pixels != nil && iFrames != nil) {
        urlList = pixels;
        [urlList addObjectsFromArray:iFrames];
    } else if (pixels != nil && iFrames == nil) {
        urlList = pixels;
    } else if (pixels == nil && iFrames != nil) {
        urlList = iFrames;
    } else {
        return nil;
    }
    
    return [self convertArrayOfDictsToArray:urlType withArray:urlList];
}

+ (NSDictionary *)getMappingConfig:(NSDictionary *)configMap {
    NSArray* arrayOfMappings = [configMap objectForKey:@"mappings"];
    if (arrayOfMappings ==  nil) return nil;
    
    return [self convertArrayOfDictsToDict:arrayOfMappings];
}

@end
