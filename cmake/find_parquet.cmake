option (ENABLE_PARQUET "Enable parquet" ${NOT_MSVC})  # TODO: MSVC?

if (ENABLE_PARQUET)

option (USE_INTERNAL_PARQUET_LIBRARY "Set to FALSE to use system libparquet instead of the bundled" ${NOT_UNBUNDLED})

if (USE_INTERNAL_PARQUET_LIBRARY AND NOT EXISTS "${ClickHouse_SOURCE_DIR}/contrib/parquet-cpp/CMakeLists.txt")
   message (WARNING "submodule contrib/parquet is missing. to fix try run: \n git submodule update --init --recursive")
   set (USE_INTERNAL_PARQUET_LIBRARY 0)
   set (MISSING_INTERNAL_PARQUET_LIBRARY 1)
endif ()

if (NOT USE_INTERNAL_PARQUET_LIBRARY)
    find_library (PARQUET_LIB parquet)
    find_path (PARQUET_INCLUDE_DIR NAMES librdkafka/rdkafka.h PATHS ${PARQUET_INCLUDE_PATHS})
endif ()

if (PARQUET_LIB AND PARQUET_INCLUDE_DIR)
    # TODO: find a correct path
    # find_library (PARQUET_LIB parquet)
    # find_path (PARQUET_INCLUDE_DIR NAMES parquet/<???>.h PATHS ${PARQUET_INCLUDE_PATHS})
elseif (NOT MISSING_INTERNAL_PARQUET_LIBRARY)
    set (USE_INTERNAL_PARQUET_LIBRARY 1)
# TODO:    find_path (PARQUET_INCLUDE_DIR parquet/api/reader.h PATHS)
# TODO:    set (PARQUET_INCLUDE_DIR "${ClickHouse_SOURCE_DIR}/contrib/parquet/src/parquet/api")
    set (PARQUET_STATIC_LIBRARY )
    set (USE_PARQUET 1)
endif ()

endif ()

message (STATUS "Using libparquet=${USE_PARQUET}: ${PARQUET_INCLUDE_DIR} : ${PARQUET_LIBRARY}")
