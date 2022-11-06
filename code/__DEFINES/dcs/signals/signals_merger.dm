
// Merger datum signals
/// Called on the object being added to a merger group: (datum/merger/new_merger)
#define COMSIG_MERGER_ADDING "comsig_merger_adding"
/// Called on the object being removed from a merger group: (datum/merger/old_merger)
#define COMSIG_MERGER_REMOVING "comsig_merger_removing"
/// Called on the merger after finishing a refresh: (list/leaving_members, list/joining_members)
#define COMSIG_MERGER_REFRESH_COMPLETE "comsig_merger_refresh_complete"
