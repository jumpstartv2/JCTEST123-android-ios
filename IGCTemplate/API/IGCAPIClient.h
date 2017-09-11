//
//  IGCAPIClient.h
//  IGCTemplate
//
//  Created by Jason Jon E. Carreos on 05/09/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const kIGCAPIHTTPMethodGet = @"GET";
static NSString * const kIGCAPIHTTPMethodPost = @"POST";

static NSString * const kIGCAPIContentTypeJSON = @"application/json";

@interface IGCAPIClient : NSObject

- (instancetype)initWithRootURL:(NSString *)rootURL authHeader:(NSString *)authHeader;
- (void)cancelTasks;
- (void)getRequestToLink:(NSString *)link
             queryParams:(NSDictionary *)queryParams
           authenticated:(BOOL)authenticated
              completion:(void (^)(NSURLResponse *, NSDictionary *, NSError *))completion;
- (void)postRequestToLink:(NSString *)link
               bodyParams:(NSDictionary *)bodyParams
            authenticated:(BOOL)authenticated
               completion:(void (^)(NSURLResponse *, NSDictionary *, NSError *))completion;

@end
