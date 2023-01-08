# dbt Readme Logger
This package logs information about source, seed, & model nodes to the command line in pipe-delimited csv format. 



## Quickstart
1. Add this package to your `packages.yml`:
```yaml
packages:
  - package: 
    version:
```
2. Run `dbt deps` to install the package.
3. Add an on-run-end hook to your `dbt_project.yml`: `on-run-end: "{{ dbt_readme_logger.log_results_csv() }}"`
4. Run your project!
5. Copy and paste the desired CSV into the "Data Source" area of [TableConvert (CSV-to-Markdown)](https://tableconvert.com/csv-to-markdown)
6. Configure TableConvert "Table Generator" settings:
```markdown
- [x] First row as headers
- [x] Pretty-print your Markdown
- [x] Bold first row
- [x] Text Align = Center
```
7. Copy the TableConverted generated results in the README.md file of the project.

### Sample Output
Below is a sample of the different outputs for the model nodes
1. Output in the command line
```
DATABASE|SCHEMA|MODEL|MATERIALIZATION|TAGS|NOTES
SAMPLE_DATABASE|SAMPLE_SCHEMA|SAMPLE_MODEL_I|INCREMENTAL|["dbt_readme_logger"]
SAMPLE_DATABASE|SAMPLE_SCHEMA|SAMPLE_MODEL_II|VIEW|["dbt_readme_logger", "views"]
```

2. Formatting inside the project's README.md using the output from TableConvert (w/ added notes)
```markdown
## Project Output
This project produces the following tables in snowflake:

| **DATABASE**    | **SCHEMA**    | **MODEL**       | **MATERIALIZATION** | **TAGS**                       | **NOTES**                                                |
|:---------------:|:-------------:|:---------------:|:-------------------:|:------------------------------:|:--------------------------------------------------------:|
| SAMPLE_DATABASE | SAMPLE_SCHEMA | SAMPLE_MODEL_I  | INCREMENTAL         | ["dbt_readme_logger"]          | This model uses the "delete+insert" incremental strategy |
| SAMPLE_DATABASE | SAMPLE_SCHEMA | SAMPLE_MODEL_II | VIEW                | ["dbt_readme_logger", "views"] | This model is a union of other models                    |
```

## Macro Outputs
***Note: These individual macros don't get called directly, they get called by the overarching `log_results_csv` macro.***
### log_sources ([source](macros/log_sources.sql))
Logs information about source nodes to the console in pipe-delimited csv format
```markdown
DATABASE|SCHEMA|TABLE|NOTES
SAMPLE_DATABASE|SAMPLE_SCHEMA|SAMPLE_TABLE
```
- `Database`: The database that the source model is in.
- `Schema`: The schema that the source model is in.
- `Notes`: An empty column that the developer should fill in with any relevant notes.

### log_seeds ([source](macros/log_seeds.sql))
Logs information about seed nodes to the console in pipe-delimited csv format
```markdown
FILENAME|DATABASE|SCHEMA|SEED|NOTES
 |SAMPLE_DATABASE|SAMPLE_SCHEMA|SEED_FILE
```
- `Filename`: An empty column that the developer should fill with the original file name. *If there is no original file use `-` or `SEED` as the value for this column*.
- `Database`: The database that the seed model was outputted to.
- `Schema`: The schema that the seed model was outputted to.
- `Seed`: The name of the table that the seed data was outputted to.
- `Notes`: An empty column that the developer should fill in with any relevant notes.

### log_models ([source](macros/log_models.sql))
Logs information about model nodes to the console in pipe-delimited csv format. See [Sample Output](#Sample-Output)
- `Database`: The database that the model was outputted to.
- `Schema`: The schema that the model was outputted to.
- `Model`: The name of the dbt model inside the warehouse.
- `Materialization`: The materialization the dbt model.
- `Tags`: An array of tags that are "attached" to the model.
- `Notes`: An empty column that the developer should fill in with any relevant notes.

## Acknowledgements
- Thanks to Brooklyn Data and Tails.com for developing and maintaing the [dbt-artifacts](https://github.com/brooklyn-data/dbt_artifacts) package that beautifully parses out the dbt context variables.
- Thank you dbt Labs for developing and maintaining the [dbt-codegen](https://github.com/dbt-labs/dbt-codegen) package that paved the way for logging output to the command line.