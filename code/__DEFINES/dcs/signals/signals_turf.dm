// Turf signals. Format:
// When the signal is called: (signal arguments)
// All signals send the source datum of the signal as the first argument

/// from base of turf/ChangeTurf(): (path, list/new_baseturfs, flags, list/post_change_callbacks).
/// `post_change_callbacks` is a list that signal handlers can mutate to append `/datum/callback` objects.
/// They will be called with the new turf after the turf has changed.
#define COMSIG_TURF_CHANGE "turf_change"
///from base of atom/has_gravity(): (atom/asker, list/forced_gravities)
#define COMSIG_TURF_HAS_GRAVITY "turf_has_gravity"
///from base of turf/multiz_turf_del(): (turf/source, direction)
#define COMSIG_TURF_MULTIZ_DEL "turf_multiz_del"
///from base of turf/multiz_turf_new: (turf/source, direction)
#define COMSIG_TURF_MULTIZ_NEW "turf_multiz_new"
/// from base of turf/proc/afterShuttleMove: (turf/new_turf)
#define COMSIG_TURF_AFTER_SHUTTLE_MOVE "turf_after_shuttle_move"

///from /turf/open/temperature_expose(datum/gas_mixture/air, exposed_temperature)
#define COMSIG_TURF_EXPOSE "turf_expose"
///from /turf/proc/immediate_calculate_adjacent_turfs()
#define COMSIG_TURF_CALCULATED_ADJACENT_ATMOS "turf_calculated_adjacent_atmos"

#define COMSIG_TURF_MOB_FALL "turf_mob_fall" //MONKESTATION ADDITION

#define COMSIG_TURF_LIQUIDS_CREATION "turf_liquids_creation" //MONKESTATION ADDITION
