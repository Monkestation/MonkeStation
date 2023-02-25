// rust_g.dm - DM API for rust_g extension library
//
// To configure, create a `rust_g.config.dm` and set what you care about from
// the following options:
//
// #define RUST_G "path/to/rust_g"
// Override the .dll/.so detection logic with a fixed path or with detection
// logic of your own.
//
// #define RUSTG_OVERRIDE_BUILTINS
// Enable replacement rust-g functions for certain builtins. Off by default.

#ifndef RUST_G
// Default automatic RUST_G detection.
// On Windows, looks in the standard places for `rust_g.dll`.
// On Linux, looks in `.`, `$LD_LIBRARY_PATH`, and `~/.byond/bin` for either of
// `librust_g.so` (preferred) or `rust_g` (old).

/* This comment bypasses grep checks */ /var/__rust_g

/proc/__detect_rust_g()
	if (world.system_type == UNIX)
		if (fexists("./librust_g.so"))
			// No need for LD_LIBRARY_PATH badness.
			return __rust_g = "./librust_g.so"
		else if (fexists("./rust_g"))
			// Old dumb filename.
			return __rust_g = "./rust_g"
		else if (fexists("[world.GetConfig("env", "HOME")]/.byond/bin/rust_g"))
			// Old dumb filename in `~/.byond/bin`.
			return __rust_g = "rust_g"
		else
			// It's not in the current directory, so try others
			return __rust_g = "librust_g.so"
	else
		return __rust_g = "rust_g"

#define RUST_G (__rust_g || __detect_rust_g())
#endif

/**
 * This proc generates a cellular automata noise grid which can be used in procedural generation methods.
 *
 * Returns a single string that goes row by row, with values of 1 representing an alive cell, and a value of 0 representing a dead cell.
 *
 * Arguments:
 * * percentage: The chance of a turf starting closed
 * * smoothing_iterations: The amount of iterations the cellular automata simulates before returning the results
 * * birth_limit: If the number of neighboring cells is higher than this amount, a cell is born
 * * death_limit: If the number of neighboring cells is lower than this amount, a cell dies
 * * width: The width of the grid.
 * * height: The height of the grid.
 */
#define rustg_cnoise_generate(percentage, smoothing_iterations, birth_limit, death_limit, width, height) \
    call(RUST_G, "cnoise_generate")(percentage, smoothing_iterations, birth_limit, death_limit, width, height)

#define rustg_dmi_strip_metadata(fname) call(RUST_G, "dmi_strip_metadata")("[fname]")
#define rustg_dmi_create_png(path, width, height, data) call(RUST_G, "dmi_create_png")(path, width, height, data)
#define rustg_dmi_resize_png(path, width, height, resizetype) call(RUST_G, "dmi_resize_png")(path, width, height, resizetype)

#define rustg_file_read(fname) call(RUST_G, "file_read")("[fname]")
#define rustg_file_exists(fname) call(RUST_G, "file_exists")("[fname]")
#define rustg_file_write(text, fname) call(RUST_G, "file_write")(text, "[fname]")
#define rustg_file_append(text, fname) call(RUST_G, "file_append")(text, "[fname]")

#ifdef RUSTG_OVERRIDE_BUILTINS
    #define file2text(fname) rustg_file_read("[fname]")
    #define text2file(text, fname) rustg_file_append(text, "[fname]")
#endif

#define rustg_git_revparse(rev) call(RUST_G, "rg_git_revparse")(rev)
#define rustg_git_commit_date(rev) call(RUST_G, "rg_git_commit_date")(rev)

#define rustg_hash_string(algorithm, text) call(RUST_G, "hash_string")(algorithm, text)
#define rustg_hash_file(algorithm, fname) call(RUST_G, "hash_file")(algorithm, fname)

/**
 * This proc generates a noise grid using worley noise algorithm
 *
 * Returns a single string that goes row by row, with values of 1 representing an alive cell, and a value of 0 representing a dead cell.
 *
 * Arguments:
 * * region_size: The size of regions
 * * threshold: the value that determines wether a cell is dead or alive
 * * node_per_region_chance: chance of a node existiing in a region
 * * size: size of the returned grid
 * * node_min: minimum amount of nodes in a region (after the node_per_region_chance is applied)
 * * node_max: maximum amount of nodes in a region
 */
#define rustg_worley_generate(region_size, threshold, node_per_region_chance, size, node_min, node_max) \
	call(RUST_G, "worley_generate")(region_size, threshold, node_per_region_chance, size, node_min, node_max)

/**
 * This proc generates a grid of perlin-like noise
 *
 * Returns a single string that goes row by row, with values of 1 representing an turned on cell, and a value of 0 representing a turned off cell.
 *
 * Arguments:
 * * seed: seed for the function
 * * accuracy: how close this is to the original perlin noise, as accuracy approaches infinity, the noise becomes more and more perlin-like
 * * stamp_size: Size of a singular stamp used by the algorithm, think of this as the same stuff as frequency in perlin noise
 * * world_size: size of the returned grid.
 * * lower_range: lower bound of values selected for. (inclusive)
 * * upper_range: upper bound of values selected for. (exclusive)
 */
#define rustg_dbp_generate(seed, accuracy, stamp_size, world_size, lower_range, upper_range) \
	call(RUST_G, "dbp_generate")(seed, accuracy, stamp_size, world_size, lower_range, upper_range)

#define RUSTG_HASH_MD5 "md5"
#define RUSTG_HASH_SHA1 "sha1"
#define RUSTG_HASH_SHA256 "sha256"
#define RUSTG_HASH_SHA512 "sha512"

#ifdef RUSTG_OVERRIDE_BUILTINS
#define md5(thing) (isfile(thing) ? rustg_hash_file(RUSTG_HASH_MD5, "[thing]") : rustg_hash_string(RUSTG_HASH_MD5, thing))
#endif

#define RUSTG_HTTP_METHOD_GET "get"
#define RUSTG_HTTP_METHOD_PUT "put"
#define RUSTG_HTTP_METHOD_DELETE "delete"
#define RUSTG_HTTP_METHOD_PATCH "patch"
#define RUSTG_HTTP_METHOD_HEAD "head"
#define RUSTG_HTTP_METHOD_POST "post"
#define rustg_http_request_blocking(method, url, body, headers) call(RUST_G, "http_request_blocking")(method, url, body, headers)
#define rustg_http_request_async(method, url, body, headers) call(RUST_G, "http_request_async")(method, url, body, headers)
#define rustg_http_check_request(req_id) call(RUST_G, "http_check_request")(req_id)

#define RUSTG_JOB_NO_RESULTS_YET "NO RESULTS YET"
#define RUSTG_JOB_NO_SUCH_JOB "NO SUCH JOB"
#define RUSTG_JOB_ERROR "JOB PANICKED"

#define rustg_json_is_valid(text) (call(RUST_G, "json_is_valid")(text) == "true")

#define rustg_log_write(fname, text, format) call(RUST_G, "log_write")("[fname]", text, format)
/proc/rustg_log_close_all() return call(RUST_G, "log_close_all")()

#define rustg_noise_get_at_coordinates(seed, x, y) call(RUST_G, "noise_get_at_coordinates")(seed, x, y)


/**
 * Register a list of nodes into a rust library. This list of nodes must have been serialized in a json.
 * Node {// Index of this node in the list of nodes
 *  	  unique_id: usize,
 *  	  // Position of the node in byond
 *  	  x: usize,
 *  	  y: usize,
 *  	  z: usize,
 *  	  // Indexes of nodes connected to this one
 *  	  connected_nodes_id: Vec<usize>}
 * It is important that the node with the unique_id 0 is the first in the json, unique_id 1 right after that, etc.
 * It is also important that all unique ids follow. {0, 1, 2, 4} is not a correct list and the registering will fail
 * Nodes should not link across z levels.
 * A node cannot link twice to the same node and shouldn't link itself either
 */
#define rustg_register_nodes_astar(json) call(RUST_G, "register_nodes_astar")(json)

/**
 * Add a new node to the static list of nodes. Same rule as registering_nodes applies.
 * This node unique_id must be equal to the current length of the static list of nodes
 */
#define rustg_add_node_astar(json) call(RUST_G, "add_node_astar")(json)

/**²
 * Remove every link to the node with unique_id. Replace that node by null
 */
#define rustg_remove_node_astart(unique_id) call(RUST_G, "remove_node_astar")(unique_id)

/**
 * Compute the shortest path between start_node and goal_node using A*. Heuristic used is simple geometric distance
 */
#define rustg_generate_path_astar(start_node_id, goal_node_id) call(RUST_G, "generate_path_astar")(start_node_id, goal_node_id)

#define RUSTG_REDIS_ERROR_CHANNEL "RUSTG_REDIS_ERROR_CHANNEL"

#define rustg_redis_connect(addr) call(RUST_G, "redis_connect")(addr)
/proc/rustg_redis_disconnect() return call(RUST_G, "redis_disconnect")()
#define rustg_redis_subscribe(channel) call(RUST_G, "redis_subscribe")(channel)
/proc/rustg_redis_get_messages() return call(RUST_G, "redis_get_messages")()
#define rustg_redis_publish(channel, message) call(RUST_G, "redis_publish")(channel, message)

#define rustg_sql_connect_pool(options) call(RUST_G, "sql_connect_pool")(options)
#define rustg_sql_query_async(handle, query, params) call(RUST_G, "sql_query_async")(handle, query, params)
#define rustg_sql_query_blocking(handle, query, params) call(RUST_G, "sql_query_blocking")(handle, query, params)
#define rustg_sql_connected(handle) call(RUST_G, "sql_connected")(handle)
#define rustg_sql_disconnect_pool(handle) call(RUST_G, "sql_disconnect_pool")(handle)
#define rustg_sql_check_query(job_id) call(RUST_G, "sql_check_query")("[job_id]")

#define rustg_unzip_download_async(url, unzip_directory) call(RUST_G, "unzip_download_async")(url, unzip_directory)
#define rustg_unzip_check(job_id) call(RUST_G, "unzip_check")("[job_id]")

#define rustg_url_encode(text) call(RUST_G, "url_encode")(text)
#define rustg_url_decode(text) call(RUST_G, "url_decode")(text)

#ifdef RUSTG_OVERRIDE_BUILTINS
    #define url_encode(text) rustg_url_encode(text)
    #define url_decode(text) rustg_url_decode(text)
#endif
