// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SyncStatus.h instead.

#import <CoreData/CoreData.h>

extern const struct SyncStatusAttributes {
	__unsafe_unretained NSString *createdAt;
	__unsafe_unretained NSString *syncFailed;
	__unsafe_unretained NSString *syncNeeded;
} SyncStatusAttributes;

extern const struct SyncStatusRelationships {
	__unsafe_unretained NSString *statusForEntry;
	__unsafe_unretained NSString *statusForTask;
} SyncStatusRelationships;

@class TimeEntry;
@class Task;

@interface SyncStatusID : NSManagedObjectID {}
@end

@interface _SyncStatus : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) SyncStatusID* objectID;

@property (nonatomic, strong) NSDate* createdAt;

//- (BOOL)validateCreatedAt:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* syncFailed;

@property (atomic) BOOL syncFailedValue;
- (BOOL)syncFailedValue;
- (void)setSyncFailedValue:(BOOL)value_;

//- (BOOL)validateSyncFailed:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* syncNeeded;

@property (atomic) BOOL syncNeededValue;
- (BOOL)syncNeededValue;
- (void)setSyncNeededValue:(BOOL)value_;

//- (BOOL)validateSyncNeeded:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) TimeEntry *statusForEntry;

//- (BOOL)validateStatusForEntry:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) Task *statusForTask;

//- (BOOL)validateStatusForTask:(id*)value_ error:(NSError**)error_;

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
