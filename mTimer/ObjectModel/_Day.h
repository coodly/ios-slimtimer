// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Day.h instead.

@import CoreData;

NS_ASSUME_NONNULL_BEGIN

@class Month;

@interface DayID : NSManagedObjectID {}
@end

@interface _Day : NSManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) DayID*objectID;

@property (nonatomic, strong, nullable) NSNumber* value;

@property (atomic) int32_t valueValue;
- (int32_t)valueValue;
- (void)setValueValue:(int32_t)value_;

@property (nonatomic, strong, nullable) Month *month;

@end

@interface _Day (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveValue;
- (void)setPrimitiveValue:(NSNumber*)value;

- (int32_t)primitiveValueValue;
- (void)setPrimitiveValueValue:(int32_t)value_;

- (Month*)primitiveMonth;
- (void)setPrimitiveMonth:(Month*)value;

@end

@interface DayAttributes: NSObject 
+ (NSString *)value;
@end

@interface DayRelationships: NSObject
+ (NSString *)month;
@end

NS_ASSUME_NONNULL_END
