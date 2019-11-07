//
//  RDBaseLogicModel.h
//  Reindeer
//
//  Created by Wayde Sun on 3/26/15.
//  Copyright (c) 2015 Sword. All rights reserved.
//

#import "RDBaseModelObject.h"
#import "RDBaseViewController.h"


typedef enum {
    ERDRequestStatusCodeSuccess = 0,
    ERDRequestStatusCodeUserExist = 100003,
    ERDRequestStatusCodeInvalidToken = 100006,

} ERDRequestStatusCode;



@class ServiceBaseModel;

@interface RDBaseLogicModel : RDBaseModelObject

typedef void(^ServiceCallSuccess)();
typedef void(^ServiceCallFailure)(NSString *errorMessage);
typedef void(^SuccessCompletionBlock)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult);
typedef void(^FailureCompletionBlock)(RKObjectRequestOperation *operation, NSError *error);
//
typedef void(^noNetworkFailureBlock)();
typedef void(^removeNetworkFailureViewBlock)();

@property (nonatomic, strong)RDBaseViewController *baseVC;
@property (nonatomic, copy)noNetworkFailureBlock noNetworkFailureBlock;
@property (nonatomic, copy) removeNetworkFailureViewBlock removeNetworkFailureViewBlock;

- (void)doMapping;

- (RKObjectManager *)getSharedObjectManager;

- (void)doCallGetService:(NSString *)keyPath
              parameters:(NSDictionary *)parameters
                 success:(SuccessCompletionBlock)successBlock
                 failure:(FailureCompletionBlock)failureBlock;
- (void)doCallPostService:(NSString *)keyPath
              parameters:(NSDictionary *)parameters
                 success:(SuccessCompletionBlock)successBlock
                 failure:(FailureCompletionBlock)failureBlock;
//
- (void)doCallPostService:(NSString *)keyPath parameters:(NSDictionary *)parameters constructingBodyWithBlock:(void (^)(id <AFRKMultipartFormData> formData))block success:(SuccessCompletionBlock)successBlock failure:(FailureCompletionBlock)failureBlock;

- (void)doCallPostService:(NSString *)keyPath Url:(NSString *)url parameters:(NSDictionary *)parameters constructingBodyWithBlock:(void (^)(id <AFRKMultipartFormData> formData))block success:(SuccessCompletionBlock)successBlock failure:(FailureCompletionBlock)failureBlock;

- (ServiceBaseModel *)serviceBaseModelFromMappingResult:(RKMappingResult *)mappingResult;



- (void)showAlertView:(NSString *)message;
- (void)showMakePlanError;
- (void)showMakePlanError:(NSString *)message;
- (void)alertShowWithTitle:(NSString *)title message:(NSString *)message;
@end
