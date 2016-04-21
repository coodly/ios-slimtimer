// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SyncStatus.h instead.

@import CoreData;

NS_ASSUME_NONNULL_BEGIN

@class TimeEntry;
@class Task;

@interface SyncStatusID : NSManagedObjectID {}
@end

@interface _SyncStatus : NSManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) SyncStatusID*objectID;

@property (nonatomic, strong, nullable) NSDate* createdAt;

@property (nonatomic, strong) NSNumber* syncFailed;

@property (atomic) BOOL syncFailedValue;
- (BOOL)syncFailedValue;
- (void)setSyncFailedValue:(BOOL)value_;

@property (nonatomic, strong) NSNumber* syncNeeded;

@property (atomic) BOOL syncNeededValue;
- (BOOL)syncNeededValue;
- (void)setSyncNeededValue:(BOOL)value_;

@property (nonatomic, strong, nullable) TimeEntry *statusForEntry;

@property (nonatomic, strong, nullable) Task *statusForTask;

@end

@interface _SyncStatus (CoreDataGeneratedPrimitiveAccessors)

- (NSDate*)primitiveCreatedAt;
- (void)setPrimitiveCreatedAt:(NSDate*)value;

- (NSNumber*)primitiveSyncFailed;
- (void)setPrimitiveSyncFailed:(NSNumber*)value;

- (BOOL)primitiveSyncFailedValue;
- (void)setPrimitiveSyncFailedValue:(BOOL)value_;

- (NSNumber*)primitiveSyncNeeded;
- (void)setPrimitiveSyncNeeded:(NSNumber*)value;

- (BOOL)primitiveSyncNeededValue;
- (void)setPrimitiveSyncNeededValue:(BOOL)value_;

- (TimeEntry*)primitiveStatusForEntry;
- (void)setPrimitiveStatusForEntry:(TimeEntry*)value;

- (Task*)primitiveStatusForTask;
- (void)setPrimitiveStatusForTask:(Task*)value;

@end

@interface SyncStatusAttributes: NSObject 
+ (NSString *)createdAt;
+ (NSString *)syncFailed;
+ (NSString *)syncNeeded;
@end

@interface SyncStatusRelationships: NSObject
+ (NSString *)statusForEntry;
+ (NSString *)statusForTask;
@end

NS_ASSUME_NONNULL_END
