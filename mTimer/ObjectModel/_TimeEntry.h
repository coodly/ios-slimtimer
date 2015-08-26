// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TimeEntry.h instead.

#import <CoreData/CoreData.h>

extern const struct TimeEntryAttributes {
	__unsafe_unretained NSString *comment;
	__unsafe_unretained NSString *endTime;
	__unsafe_unretained NSString *markedForDeletion;
	__unsafe_unretained NSString *remoteId;
	__unsafe_unretained NSString *startTime;
	__unsafe_unretained NSString *touchedAt;
} TimeEntryAttributes;

extern const struct TimeEntryRelationships {
	__unsafe_unretained NSString *syncStatus;
	__unsafe_unretained NSString *tags;
	__unsafe_unretained NSString *task;
} TimeEntryRelationships;

@class SyncStatus;
@class Tag;
@class Task;

@interface TimeEntryID : NSManagedObjectID {}
@end

@interface _TimeEntry : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) TimeEntryID* objectID;

@property (nonatomic, strong) NSString* comment;

//- (BOOL)validateComment:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* endTime;

//- (BOOL)validateEndTime:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* markedForDeletion;

@property (atomic) BOOL markedForDeletionValue;
- (BOOL)markedForDeletionValue;
- (void)setMarkedForDeletionValue:(BOOL)value_;

//- (BOOL)validateMarkedForDeletion:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* remoteId;

@property (atomic) int32_t remoteIdValue;
- (int32_t)remoteIdValue;
- (void)setRemoteIdValue:(int32_t)value_;

//- (BOOL)validateRemoteId:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* startTime;

//- (BOOL)validateStartTime:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* touchedAt;

//- (BOOL)validateTouchedAt:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) SyncStatus *syncStatus;

//- (BOOL)validateSyncStatus:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *tags;

- (NSMutableSet*)tagsSet;

@property (nonatomic, strong) Task *task;

//- (BOOL)validateTask:(id*)value_ error:(NSError**)error_;

@end

@interface _TimeEntry (TagsCoreDataGeneratedAccessors)
- (void)addTags:(NSSet*)value_;
- (void)removeTags:(NSSet*)value_;
- (void)addTagsObject:(Tag*)value_;
- (void)removeTagsObject:(Tag*)value_;

@end

@interface _TimeEntry (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveComment;
- (void)setPrimitiveComment:(NSString*)value;

- (NSDate*)primitiveEndTime;
- (void)setPrimitiveEndTime:(NSDate*)value;

- (NSNumber*)primitiveMarkedForDeletion;
- (void)setPrimitiveMarkedForDeletion:(NSNumber*)value;

- (BOOL)primitiveMarkedForDeletionValue;
- (void)setPrimitiveMarkedForDeletionValue:(BOOL)value_;

- (NSNumber*)primitiveRemoteId;
- (void)setPrimitiveRemoteId:(NSNumber*)value;

- (int32_t)primitiveRemoteIdValue;
- (void)setPrimitiveRemoteIdValue:(int32_t)value_;

- (NSDate*)primitiveStartTime;
- (void)setPrimitiveStartTime:(NSDate*)value;

- (NSDate*)primitiveTouchedAt;
- (void)setPrimitiveTouchedAt:(NSDate*)value;

- (SyncStatus*)primitiveSyncStatus;
- (void)setPrimitiveSyncStatus:(SyncStatus*)value;

- (NSMutableSet*)primitiveTags;
- (void)setPrimitiveTags:(NSMutableSet*)value;

- (Task*)primitiveTask;
- (void)setPrimitiveTask:(Task*)value;

@end
