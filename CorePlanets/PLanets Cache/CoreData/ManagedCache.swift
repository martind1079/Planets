//
//  Copyright © 2019 Essential Developer. All rights reserved.
//

import CoreData

@objc(ManagedCache)
public class ManagedCache: NSManagedObject {
    @NSManaged internal var items: NSOrderedSet
}


extension ManagedCache {
	internal static func find(in context: NSManagedObjectContext) throws -> ManagedCache? {
		let request = NSFetchRequest<ManagedCache>(entityName: entity().name!)
		request.returnsObjectsAsFaults = false
		return try context.fetch(request).first
	}
	
	internal static func newUniqueInstance(in context: NSManagedObjectContext) throws -> ManagedCache {
		try find(in: context).map(context.delete)
		return ManagedCache(context: context)
	}
	
	internal var localFeed: [LocalPlanet] {
        return items.compactMap { ($0 as? ManagedPlanet)?.local }
	}
}
