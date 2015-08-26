// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TimeReport.h instead.

#import <CoreData/CoreData.h>

extern const struct TimeReportAttributes {
	__unsafe_unretained NSString *seconds;
} TimeReportAttributes;

extern const struct TimeReportRelationships {
	__unsafe_unretained NSString *syncStatus;
} TimeReportRelationships;

@class SyncStatus;

@interface TimeReportID : NSManagedObjectID {}
@end

@interface _TimeReport : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) TimeReportID* objectID;

@property (nonatomic, strong) NSNumber* seconds;

@property (atomic) int32_t secondsValue;
- (int32_t)secondsValue;
- (void)setSecondsValue:(int32_t)value_;

//- (BOOL)validateSeconds:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) SyncStatus *syncStatus;

//- (BOOL)validateSyncStatus:(id*)value_ error:(NSError**)error_;

@end

@interface _TimeReport (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveSeconds;
- (void)setPrimitiveSeconds:(NSNumber*)value;

- (int32_t)primitiveSecondsValue;
- (void)setPrimitiveSecondsValue:(int32_t)value_;

- (SyncStatus*)primitiveSyncStatus;
- (void)setPrimitiveSyncStatus:(SyncStatus*)value;

@end
