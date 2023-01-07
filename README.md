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
3. Add an on-run-end hook to your `dbt_project.yml`: `on-run-end: "{{ dbt_readme_logger.log_results() }}"`
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

### Sample Outputs
Below is a sample of the different outputs for the model nodes
1. Output in the command line
```
DATABASE|SCHEMA|MODEL|MATERIALIZATION|TAGS|NOTES
SAMPLE_DATABASE|SAMPLE_SCHEMA|SAMPLE_MODEL_I|INCREMENTAL|["dbt_readme_logger"]
SAMPLE_DATABASE|SAMPLE_SCHEMA|SAMPLE_MODEL_II|VIEW|["dbt_readme_logger", "views"]
```

2. Formatting inside the project's README.md using the output from TableConvert
```markdown
## Project Output
This project produces the following tables in snowflake:

| **DATABASE**    | **SCHEMA**    | **MODEL**       | **MATERIALIZATION** | **TAGS**                       | **NOTES**                                                |
|:---------------:|:-------------:|:---------------:|:-------------------:|:------------------------------:|:--------------------------------------------------------:|
| SAMPLE_DATABASE | SAMPLE_SCHEMA | SAMPLE_MODEL_I  | INCREMENTAL         | ["dbt_readme_logger"]          | This model uses the "delete+insert" incremental strategy |
| SAMPLE_DATABASE | SAMPLE_SCHEMA | SAMPLE_MODEL_II | VIEW                | ["dbt_readme_logger", "views"] | This model is a union of other models                    |
```