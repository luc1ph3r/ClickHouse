#include <iostream>
#include <memory>
#include <arrow/api.h>
#include <arrow/io/api.h>
#include <arrow/io/file.h>
#include <arrow/memory_pool.h>
#include <parquet/arrow/reader.h>
#include <parquet/arrow/writer.h>
#include <parquet/exception.h>

int mainEntryClickHouseTest(int argc, char ** argv)
{
    if (argc > 1) {
        std::cout << argv[1] << std::endl;
    }

    std::cout << "Reading userdata1.parquet" << std::endl;
    std::shared_ptr<arrow::io::ReadableFile> infile;
    arrow::default_memory_pool();
    PARQUET_THROW_NOT_OK(arrow::io::ReadableFile::Open(
        "userdata1.parquet", arrow::default_memory_pool(), &infile));

    std::unique_ptr<parquet::arrow::FileReader> reader;
    PARQUET_THROW_NOT_OK(
        parquet::arrow::OpenFile(infile, arrow::default_memory_pool(), &reader));
    std::shared_ptr<arrow::Table> table;
    PARQUET_THROW_NOT_OK(reader->ReadTable(&table));
    std::cout << "Loaded " << table->num_rows() << " rows in " << table->num_columns()
              << " columns." << std::endl;
    return 0;
}
