// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TimeEntry.h instead.

@import CoreData;

NS_ASSUME_NONNULL_BEGIN

@class SyncStatus;
@class Tag;
@class Task;

@interface TimeEntryID : NSManagedObjectID {}
@end

@interface _TimeEntry : NSManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) TimeEntryID*objectID;

@property (nonatomic, strong, nullable) NSString* comment;

@property (nonatomic, strong, nullable) NSDate* endTime;

@property (nonatomic, strong) NSNumber* markedForDeletion;

@property (atomic) BOOL markedForDeletionValue;
- (BOOL)markedForDeletionValue;
- (void)setMarkedForDeletionValue:(BOOL)value_;

@property (nonatomic, strong, nullable) NSNumber* remoteId;

@property (atomic) int32_t remoteIdValue;
- (int32_t)remoteIdValue;
- (void)setRemoteIdValue:(int32_t)value_;

@property (nonatomic, strong) NSDate* startTime;

@property (nonatomic, strong, nullable) NSDate* touchedAt;

@property (nonatomic, strong, nullable) SyncStatus *syncStatus;

@property (nonatomic, strong, nullable) NSSet<Tag*> *tags;
- (nullable NSMutableSet<Tag*>*)tagsSet;

@property (nonatomic, strong, nullable) Task *task;

@end

@interface _TimeEntry (TagsCoreDataGeneratedAccessors)
- (void)addTags:(NSSet<Tag*>*)value_;
- (void)removeTags:(NSSet<Tag*>*)value_;
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

- (NSMutableSet<Tag*>*)primitiveTags;
- (void)setPrimitiveTags:(NSMutableSet<Tag*>*)value;

- (Task*)primitiveTask;
- (void)setPrimitiveTask:(Task*)value;

@end

@interface TimeEntryAttributes: NSObject 
+ (NSString *)comment;
+ (NSString *)endTime;
+ (NSString *)markedForDeletion;
+ (NSString *)remoteId;
+ (NSString *)startTime;
+ (NSString *)touchedAt;
@end

@interface TimeEntryRelationships: NSObject
+ (NSString *)syncStatus;
+ (NSString *)tags;
+ (NSString *)task;
@end

NS_ASSUME_NONNULL_END
