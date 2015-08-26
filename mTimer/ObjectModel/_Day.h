// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Day.h instead.

#import <CoreData/CoreData.h>

extern const struct DayAttributes {
	__unsafe_unretained NSString *value;
} DayAttributes;

extern const struct DayRelationships {
	__unsafe_unretained NSString *month;
} DayRelationships;

@class Month;

@interface DayID : NSManagedObjectID {}
@end

@interface _Day : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) DayID* objectID;

@property (nonatomic, strong) NSNumber* value;

@property (atomic) int32_t valueValue;
- (int32_t)valueValue;
- (void)setValueValue:(int32_t)value_;

//- (BOOL)validateValue:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) Month *month;

//- (BOOL)validateMonth:(id*)value_ error:(NSError**)error_;

@end

@interface _Day (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveValue;
- (void)setPrimitiveValue:(NSNumber*)value;

- (int32_t)primitiveValueValue;
- (void)setPrimitiveValueValue:(int32_t)value_;

- (Month*)primitiveMonth;
- (void)setPrimitiveMonth:(Month*)value;

@end
