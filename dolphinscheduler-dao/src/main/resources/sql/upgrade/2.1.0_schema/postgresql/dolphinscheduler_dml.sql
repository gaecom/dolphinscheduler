/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
*/
delimiter d//
CREATE OR REPLACE FUNCTION public.dolphin_insert_dq_initial_data(
	)
    RETURNS character varying
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
v_schema varchar;
BEGIN
    ---get schema name
    v_schema =current_schema();

EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_dq_comparison_type
    (id, "type", execute_sql, output_table, "name", create_time, update_time, is_inner_source)
    VALUES(1, "FixValue", NULL, NULL, NULL, "2021-06-30 00:00:00.000", "2021-06-30 00:00:00.000", false)';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_dq_comparison_type
    (id, "type", execute_sql, output_table, "name", create_time, update_time, is_inner_source)
    VALUES(2, "DailyAvg", "select round(avg(statistics_value),2) as day_avg from t_ds_dq_task_statistics_value where data_time >=date_trunc(''DAY'', ${data_time}) and data_time < date_add(date_trunc(''day'', ${data_time}),1) and unique_code = ${unique_code} and statistics_name = ''${statistics_name}''", "day_range", "day_range.day_avg", "2021-06-30 00:00:00.000", "2021-06-30 00:00:00.000", true)';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_dq_comparison_type
    (id, "type", execute_sql, output_table, "name", create_time, update_time, is_inner_source)
    VALUES(3, "WeeklyAvg", "select round(avg(statistics_value),2) as week_avg from t_ds_dq_task_statistics_value where  data_time >= date_trunc(''WEEK'', ${data_time}) and data_time <date_trunc(''day'', ${data_time}) and unique_code = ${unique_code} and statistics_name = ''${statistics_name}''", "week_range", "week_range.week_avg", "2021-06-30 00:00:00.000", "2021-06-30 00:00:00.000", true)';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_dq_comparison_type
    (id, "type", execute_sql, output_table, "name", create_time, update_time, is_inner_source)
    VALUES(4, "MonthlyAvg", "select round(avg(statistics_value),2) as month_avg from t_ds_dq_task_statistics_value where  data_time >= date_trunc(''MONTH'', ${data_time}) and data_time <date_trunc(''day'', ${data_time}) and unique_code = ${unique_code} and statistics_name = ''${statistics_name}''", "month_range", "month_range.month_avg", "2021-06-30 00:00:00.000", "2021-06-30 00:00:00.000", true)';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_dq_comparison_type
    (id, "type", execute_sql, output_table, "name", create_time, update_time, is_inner_source)
    VALUES(5, "Last7DayAvg", "select round(avg(statistics_value),2) as last_7_avg from t_ds_dq_task_statistics_value where  data_time >= date_add(date_trunc(''day'', ${data_time}),-7) and  data_time <date_trunc(''day'', ${data_time}) and unique_code = ${unique_code} and statistics_name = ''${statistics_name}''", "last_seven_days", "last_seven_days.last_7_avg", "2021-06-30 00:00:00.000", "2021-06-30 00:00:00.000", true)';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_dq_comparison_type
    (id, "type", execute_sql, output_table, "name", create_time, update_time, is_inner_source)
    VALUES(6, "Last30DayAvg", "select round(avg(statistics_value),2) as last_30_avg from t_ds_dq_task_statistics_value where  data_time >= date_add(date_trunc(''day'', ${data_time}),-30) and  data_time < date_trunc(''day'', ${data_time}) and unique_code = ${unique_code} and statistics_name = ''${statistics_name}''", "last_thirty_days", "last_thirty_days.last_30_avg", "2021-06-30 00:00:00.000", "2021-06-30 00:00:00.000", true)';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_dq_comparison_type
    (id, "type", execute_sql, output_table, "name", create_time, update_time, is_inner_source)
    VALUES(7, "SrcTableTotalRows", "SELECT COUNT(*) AS total FROM ${src_table} WHERE (${src_filter})@, "total_count", "total_count.total", "2021-06-30 00:00:00.000", "2021-06-30 00:00:00.000", false)';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_dq_comparison_type
    (id, "type", execute_sql, output_table, "name", create_time, update_time, is_inner_source)
    VALUES(8, "TargetTableTotalRows", "SELECT COUNT(*) AS total FROM ${target_table} WHERE (${target_filter})@, "total_count", "total_count.total", "2021-06-30 00:00:00.000", "2021-06-30 00:00:00.000", false)';

EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_dq_rule
    (id, "name", "type", user_id, create_time, update_time)
    VALUES(1, "$t(null_check)", 0, 1, "2020-01-12 00:00:00.000", "2020-01-12 00:00:00.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_dq_rule
    (id, "name", "type", user_id, create_time, update_time)
    VALUES(2, "$t(custom_sql)", 1, 1, "2020-01-12 00:00:00.000", "2020-01-12 00:00:00.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_dq_rule
    (id, "name", "type", user_id, create_time, update_time)
    VALUES(3, "$t(multi_table_accuracy)", 2, 1, "2020-01-12 00:00:00.000", "2020-01-12 00:00:00.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_dq_rule
    (id, "name", "type", user_id, create_time, update_time)
    VALUES(4, "$t(multi_table_value_comparison)", 3, 1, "2020-01-12 00:00:00.000", "2020-01-12 00:00:00.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_dq_rule
    (id, "name", "type", user_id, create_time, update_time)
    VALUES(5, "$t(field_length_check)", 0, 1, "2020-01-12 00:00:00.000", "2020-01-12 00:00:00.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_dq_rule
    (id, "name", "type", user_id, create_time, update_time)
    VALUES(6, "$t(uniqueness_check)", 0, 1, "2020-01-12 00:00:00.000", "2020-01-12 00:00:00.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_dq_rule
    (id, "name", "type", user_id, create_time, update_time)
    VALUES(7, "$t(regexp_check)", 0, 1, "2020-01-12 00:00:00.000", "2020-01-12 00:00:00.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_dq_rule
    (id, "name", "type", user_id, create_time, update_time)
    VALUES(8, "$t(timeliness_check)", 0, 1, "2020-01-12 00:00:00.000", "2020-01-12 00:00:00.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_dq_rule
    (id, "name", "type", user_id, create_time, update_time)
    VALUES(9, "$t(enumeration_check)", 0, 1, "2020-01-12 00:00:00.000", "2020-01-12 00:00:00.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_dq_rule
    (id, "name", "type", user_id, create_time, update_time)
    VALUES(10, "$t(table_count_check)", 0, 1, "2020-01-12 00:00:00.000", "2020-01-12 00:00:00.000")';

EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_dq_rule_execute_sql
    (id, "index", "sql", table_alias, "type", is_error_output_sql, create_time, update_time)
    VALUES(1, 1, "SELECT COUNT(*) AS nulls FROM null_items", "null_count", 1, false, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_dq_rule_execute_sql
    (id, "index", "sql", table_alias, "type", is_error_output_sql, create_time, update_time)
    VALUES(2, 1, "SELECT COUNT(*) AS total FROM ${src_table} WHERE (${src_filter})@, "total_count", 2, false, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_dq_rule_execute_sql
    (id, "index", "sql", table_alias, "type", is_error_output_sql, create_time, update_time)
    VALUES(3, 1, "SELECT COUNT(*) AS miss from miss_items", "miss_count", 1, false, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_dq_rule_execute_sql
    (id, "index", "sql", table_alias, "type", is_error_output_sql, create_time, update_time)
    VALUES(4, 1, "SELECT COUNT(*) AS valids FROM invalid_length_items", "invalid_length_count", 1, false, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_dq_rule_execute_sql
    (id, "index", "sql", table_alias, "type", is_error_output_sql, create_time, update_time)
    VALUES(5, 1, "SELECT COUNT(*) AS total FROM ${target_table} WHERE (${target_filter})@, "total_count", 2, false, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_dq_rule_execute_sql
    (id, "index", "sql", table_alias, "type", is_error_output_sql, create_time, update_time)
    VALUES(6, 1, "SELECT ${src_field} FROM ${src_table} group by ${src_field} having count(*) > 1", "duplicate_items", 0, true, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_dq_rule_execute_sql
    (id, "index", "sql", table_alias, "type", is_error_output_sql, create_time, update_time)
    VALUES(7, 1, "SELECT COUNT(*) AS duplicates FROM duplicate_items", "duplicate_count", 1, false, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_dq_rule_execute_sql
    (id, "index", "sql", table_alias, "type", is_error_output_sql, create_time, update_time)
    VALUES(8, 1, "SELECT ${src_table}.* FROM (SELECT * FROM ${src_table} WHERE (${src_filter})) ${src_table} LEFT JOIN (SELECT * FROM ${target_table} WHERE (${target_filter})) ${target_table} ON ${on_clause} WHERE ${where_clause}", "miss_items", 0, true, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_dq_rule_execute_sql
    (id, "index", "sql", table_alias, "type", is_error_output_sql, create_time, update_time)
    VALUES(9, 1, "SELECT * FROM ${src_table} WHERE (${src_field} not regexp ''${regexp_pattern}'') AND (${src_filter}) ", "regexp_items", 0, true, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_dq_rule_execute_sql
    (id, "index", "sql", table_alias, "type", is_error_output_sql, create_time, update_time)
    VALUES(10, 1, "SELECT COUNT(*) AS regexps FROM regexp_items", "regexp_count", 1, false, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_dq_rule_execute_sql
    (id, "index", "sql", table_alias, "type", is_error_output_sql, create_time, update_time)
    VALUES(11, 1, "SELECT * FROM ${src_table} WHERE (to_unix_timestamp(${src_field}, ''${datetime_format}'')-to_unix_timestamp(''${deadline}'', ''${datetime_format}'') <= 0) AND (to_unix_timestamp(${src_field}, ''${datetime_format}'')-to_unix_timestamp(''${begin_time}'', ''${datetime_format}'') >= 0) AND (${src_filter}) ", "timeliness_items", 0, true, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_dq_rule_execute_sql
    (id, "index", "sql", table_alias, "type", is_error_output_sql, create_time, update_time)
    VALUES(12, 1, "SELECT COUNT(*) AS timeliness FROM timeliness_items", "timeliness_count", 1, false, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_dq_rule_execute_sql
    (id, "index", "sql", table_alias, "type", is_error_output_sql, create_time, update_time)
    VALUES(13, 1, "SELECT * FROM ${src_table} where (${src_field} not in ( ${enum_list} ) or ${src_field} is null) AND (${src_filter}) ", "enum_items", 0, true, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_dq_rule_execute_sql
    (id, "index", "sql", table_alias, "type", is_error_output_sql, create_time, update_time)
    VALUES(14, 1, "SELECT COUNT(*) AS enums FROM enum_items", "enum_count", 1, false, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_dq_rule_execute_sql
    (id, "index", "sql", table_alias, "type", is_error_output_sql, create_time, update_time)
    VALUES(15, 1, "SELECT COUNT(*) AS total FROM ${src_table} WHERE (${src_filter})@, "table_count", 1, false, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_dq_rule_execute_sql
    (id, "index", "sql", table_alias, "type", is_error_output_sql, create_time, update_time)
    VALUES(16, 1, "SELECT * FROM ${src_table} WHERE (${src_field} is null or ${src_field} = '''') AND (${src_filter})@, "null_items", 0, true, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_dq_rule_execute_sql
    (id, "index", "sql", table_alias, "type", is_error_output_sql, create_time, update_time)
    VALUES(17, 1, "SELECT * FROM ${src_table} WHERE (length(${src_field}) ${logic_operator} ${field_length}) AND (${src_filter})@, "invalid_length_items", 0, true, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';

EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_dq_rule_input_entry
    (id, field, "type", title, value, "options", placeholder, option_source_type, value_type, input_type, is_show, can_edit, is_emit, is_validate, create_time, update_time)
    VALUES(1, "src_connector_type", "select", "$t(src_connector_type)", '', "[{"label":"HIVE","value":"HIVE"},{"label":"JDBC","value":"JDBC"}]", "please select source connector type", 2, 2, 0, 1, 1, 1, 0, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_dq_rule_input_entry
    (id, field, "type", title, value, "options", placeholder, option_source_type, value_type, input_type, is_show, can_edit, is_emit, is_validate, create_time, update_time)
    VALUES(2, "src_datasource_id", "select", "$t(src_datasource_id)", '', NULL, "please select source datasource id", 1, 2, 0, 1, 1, 1, 0, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_dq_rule_input_entry
    (id, field, "type", title, value, "options", placeholder, option_source_type, value_type, input_type, is_show, can_edit, is_emit, is_validate, create_time, update_time)
    VALUES(3, "src_table", "select", "$t(src_table)", NULL, NULL, "Please enter source table name", 0, 0, 0, 1, 1, 1, 1, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_dq_rule_input_entry
    (id, field, "type", title, value, "options", placeholder, option_source_type, value_type, input_type, is_show, can_edit, is_emit, is_validate, create_time, update_time)
    VALUES(4, "src_filter", "input", "$t(src_filter)", NULL, NULL, "Please enter filter expression", 0, 3, 0, 1, 1, 0, 0, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_dq_rule_input_entry
    (id, field, "type", title, value, "options", placeholder, option_source_type, value_type, input_type, is_show, can_edit, is_emit, is_validate, create_time, update_time)
    VALUES(5, "src_field", "select", "$t(src_field)", NULL, NULL, "Please enter column, only single column is supported", 0, 0, 0, 1, 1, 0, 1, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_dq_rule_input_entry
    (id, field, "type", title, value, "options", placeholder, option_source_type, value_type, input_type, is_show, can_edit, is_emit, is_validate, create_time, update_time)
    VALUES(6, "statistics_name", "input", "$t(statistics_name)", NULL, NULL, "Please enter statistics name, the alias in statistics execute sql", 0, 0, 1, 0, 0, 0, 1, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_dq_rule_input_entry
    (id, field, "type", title, value, "options", placeholder, option_source_type, value_type, input_type, is_show, can_edit, is_emit, is_validate, create_time, update_time)
    VALUES(7, "check_type", "select", "$t(check_type)", "0", "[{"label":"Expected - Actual","value":"0"},{"label":"Actual - Expected","value":"1"},{"label":"Actual / Expected","value":"2"},{"label":"(Expected - Actual) / Expected","value":"3"}]", "please select check type", 0, 0, 3, 1, 1, 1, 0, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_dq_rule_input_entry
    (id, field, "type", title, value, "options", placeholder, option_source_type, value_type, input_type, is_show, can_edit, is_emit, is_validate, create_time, update_time)
    VALUES(8, "operator", "select", "$t(operator)", "0", "[{"label":"=","value":"0"},{"label":"<","value":"1"},{"label":"<=","value":"2"},{"label":">","value":"3"},{"label":">=","value":"4"},{"label":"!=","value":"5"}]", "please select operator", 0, 0, 3, 1, 1, 0, 0, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_dq_rule_input_entry
    (id, field, "type", title, value, "options", placeholder, option_source_type, value_type, input_type, is_show, can_edit, is_emit, is_validate, create_time, update_time)
    VALUES(9, "threshold", "input", "$t(threshold)", NULL, NULL, "Please enter threshold, number is needed", 0, 2, 3, 1, 1, 0, 1, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_dq_rule_input_entry
    (id, field, "type", title, value, "options", placeholder, option_source_type, value_type, input_type, is_show, can_edit, is_emit, is_validate, create_time, update_time)
    VALUES(10, "failure_strategy", "select", "$t(failure_strategy)", "0", "[{"label":"Alert","value":"0"},{"label":"Block","value":"1"}]", "please select failure strategy", 0, 0, 3, 1, 1, 0, 0, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_dq_rule_input_entry
    (id, field, "type", title, value, "options", placeholder, option_source_type, value_type, input_type, is_show, can_edit, is_emit, is_validate, create_time, update_time)
    VALUES(11, "target_connector_type", "select", "$t(target_connector_type)", '', "[{"label":"HIVE","value":"HIVE"},{"label":"JDBC","value":"JDBC"}]", "Please select target connector type", 2, 0, 0, 1, 1, 1, 0, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_dq_rule_input_entry
    (id, field, "type", title, value, "options", placeholder, option_source_type, value_type, input_type, is_show, can_edit, is_emit, is_validate, create_time, update_time)
    VALUES(12, "target_datasource_id", "select", "$t(target_datasource_id)", '', NULL, "Please select target datasource", 1, 2, 0, 1, 1, 1, 0, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_dq_rule_input_entry
    (id, field, "type", title, value, "options", placeholder, option_source_type, value_type, input_type, is_show, can_edit, is_emit, is_validate, create_time, update_time)
    VALUES(13, "target_table", "select", "$t(target_table)", NULL, NULL, "Please enter target table", 0, 0, 0, 1, 1, 1, 1, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_dq_rule_input_entry
    (id, field, "type", title, value, "options", placeholder, option_source_type, value_type, input_type, is_show, can_edit, is_emit, is_validate, create_time, update_time)
    VALUES(14, "target_filter", "input", "$t(target_filter)", NULL, NULL, "Please enter target filter expression", 0, 3, 0, 1, 1, 0, 0, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_dq_rule_input_entry
    (id, field, "type", title, value, "options", placeholder, option_source_type, value_type, input_type, is_show, can_edit, is_emit, is_validate, create_time, update_time)
    VALUES(15, "mapping_columns", "group", "$t(mapping_columns)", NULL, "[{"field":"src_field","props":{"placeholder":"Please input src field","rows":0,"disabled":false,"size":"small"},"type":"input","title":"src_field"},{"field":"operator","props":{"placeholder":"Please input operator","rows":0,"disabled":false,"size":"small"},"type":"input","title":"operator"},{"field":"target_field","props":{"placeholder":"Please input target field","rows":0,"disabled":false,"size":"small"},"type":"input","title":"target_field"}]", "please enter mapping columns", 0, 0, 0, 1, 1, 0, 0, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_dq_rule_input_entry
    (id, field, "type", title, value, "options", placeholder, option_source_type, value_type, input_type, is_show, can_edit, is_emit, is_validate, create_time, update_time)
    VALUES(16, "statistics_execute_sql", "textarea", "$t(statistics_execute_sql)", NULL, NULL, "Please enter statistics execute sql", 0, 3, 0, 1, 1, 0, 1, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_dq_rule_input_entry
    (id, field, "type", title, value, "options", placeholder, option_source_type, value_type, input_type, is_show, can_edit, is_emit, is_validate, create_time, update_time)
    VALUES(17, "comparison_name", "input", "$t(comparison_name)", NULL, NULL, "Please enter comparison name, the alias in comparison execute sql", 0, 0, 0, 0, 0, 0, 1, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_dq_rule_input_entry
    (id, field, "type", title, value, "options", placeholder, option_source_type, value_type, input_type, is_show, can_edit, is_emit, is_validate, create_time, update_time)
    VALUES(18, "comparison_execute_sql", "textarea", "$t(comparison_execute_sql)", NULL, NULL, "Please enter comparison execute sql", 0, 3, 0, 1, 1, 0, 1, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_dq_rule_input_entry
    (id, field, "type", title, value, "options", placeholder, option_source_type, value_type, input_type, is_show, can_edit, is_emit, is_validate, create_time, update_time)
    VALUES(19, "comparison_type", "select", "$t(comparison_type)", '', NULL, "Please enter comparison title", 3, 0, 2, 1, 0, 1, 0, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_dq_rule_input_entry
    (id, field, "type", title, value, "options", placeholder, option_source_type, value_type, input_type, is_show, can_edit, is_emit, is_validate, create_time, update_time)
    VALUES(20, "writer_connector_type", "select", "$t(writer_connector_type)", '', "[{"label":"MYSQL","value":"0"},{"label":"POSTGRESQL","value":"1"}]", "please select writer connector type", 0, 2, 0, 1, 1, 1, 0, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_dq_rule_input_entry
    (id, field, "type", title, value, "options", placeholder, option_source_type, value_type, input_type, is_show, can_edit, is_emit, is_validate, create_time, update_time)
    VALUES(21, "writer_datasource_id", "select", "$t(writer_datasource_id)", '', NULL, "please select writer datasource id", 1, 2, 0, 1, 1, 0, 0, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_dq_rule_input_entry
    (id, field, "type", title, value, "options", placeholder, option_source_type, value_type, input_type, is_show, can_edit, is_emit, is_validate, create_time, update_time)
    VALUES(22, "target_field", "select", "$t(target_field)", NULL, NULL, "Please enter column, only single column is supported", 0, 0, 0, 1, 1, 0, 0, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_dq_rule_input_entry
    (id, field, "type", title, value, "options", placeholder, option_source_type, value_type, input_type, is_show, can_edit, is_emit, is_validate, create_time, update_time)
    VALUES(23, "field_length", "input", "$t(field_length)", NULL, NULL, "Please enter length limit", 0, 3, 0, 1, 1, 0, 0, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_dq_rule_input_entry
    (id, field, "type", title, value, "options", placeholder, option_source_type, value_type, input_type, is_show, can_edit, is_emit, is_validate, create_time, update_time)
    VALUES(24, "logic_operator", "select", "$t(logic_operator)", "=", "[{"label":"=","value":"="},{"label":"<","value":"<"},{"label":"<=","value":"<="},{"label":">","value":">"},{"label":">=","value":">="},{"label":"<>","value":"<>"}]", "please select logic operator", 0, 0, 3, 1, 1, 0, 0, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_dq_rule_input_entry
    (id, field, "type", title, value, "options", placeholder, option_source_type, value_type, input_type, is_show, can_edit, is_emit, is_validate, create_time, update_time)
    VALUES(25, "regexp_pattern", "input", "$t(regexp_pattern)", NULL, NULL, "Please enter regexp pattern", 0, 0, 0, 1, 1, 0, 0, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_dq_rule_input_entry
    (id, field, "type", title, value, "options", placeholder, option_source_type, value_type, input_type, is_show, can_edit, is_emit, is_validate, create_time, update_time)
    VALUES(26, "deadline", "input", "$t(deadline)", NULL, NULL, "Please enter deadline", 0, 0, 0, 1, 1, 0, 0, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_dq_rule_input_entry
    (id, field, "type", title, value, "options", placeholder, option_source_type, value_type, input_type, is_show, can_edit, is_emit, is_validate, create_time, update_time)
    VALUES(27, "datetime_format", "input", "$t(datetime_format)", NULL, NULL, "Please enter datetime format", 0, 0, 0, 1, 1, 0, 0, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_dq_rule_input_entry
    (id, field, "type", title, value, "options", placeholder, option_source_type, value_type, input_type, is_show, can_edit, is_emit, is_validate, create_time, update_time)
    VALUES(28, "enum_list", "input", "$t(enum_list)", NULL, NULL, "Please enter enumeration", 0, 0, 0, 1, 1, 0, 0, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_dq_rule_input_entry
    (id, field, "type", title, value, `options`, placeholder, option_source_type, value_type, input_type, is_show, can_edit, is_emit, is_validate, create_time, update_time)
    VALUES(29, "begin_time", "input", "$t(begin_time)", NULL, NULL, "Please enter begin time", 0, 0, 0, 1, 1, 0, 0, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';

EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_execute_sql
    (id, rule_id, execute_sql_id, create_time, update_time)
    VALUES(1, 1, 1, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_execute_sql
    (id, rule_id, execute_sql_id, create_time, update_time)
    VALUES(3, 5, 4, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_execute_sql
    (id, rule_id, execute_sql_id, create_time, update_time)
    VALUES(2, 3, 3, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_execute_sql
    (id, rule_id, execute_sql_id, create_time, update_time)
    VALUES(4, 3, 8, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_execute_sql
    (id, rule_id, execute_sql_id, create_time, update_time)
    VALUES(5, 6, 6, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_execute_sql
    (id, rule_id, execute_sql_id, create_time, update_time)
    VALUES(6, 6, 7, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_execute_sql
    (id, rule_id, execute_sql_id, create_time, update_time)
    VALUES(7, 7, 9, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_execute_sql
    (id, rule_id, execute_sql_id, create_time, update_time)
    VALUES(8, 7, 10, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_execute_sql
    (id, rule_id, execute_sql_id, create_time, update_time)
    VALUES(9, 8, 11, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_execute_sql
    (id, rule_id, execute_sql_id, create_time, update_time)
    VALUES(10, 8, 12, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_execute_sql
    (id, rule_id, execute_sql_id, create_time, update_time)
    VALUES(11, 9, 13, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_execute_sql
    (id, rule_id, execute_sql_id, create_time, update_time)
    VALUES(12, 9, 14, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_execute_sql
    (id, rule_id, execute_sql_id, create_time, update_time)
    VALUES(13, 10, 15, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_execute_sql
    (id, rule_id, execute_sql_id, create_time, update_time)
    VALUES(14, 1, 16, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_execute_sql
    (id, rule_id, execute_sql_id, create_time, update_time)
    VALUES(15, 5, 17, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';

EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(1, 1, 1, NULL, 1, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(2, 1, 2, NULL, 2, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(3, 1, 3, NULL, 3, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(4, 1, 4, NULL, 4, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(5, 1, 5, NULL, 5, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(6, 1, 6, "{"statistics_name":"null_count.nulls"}", 6, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(7, 1, 7, NULL, 7, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(8, 1, 8, NULL, 8, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(9, 1, 9, NULL, 9, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(10, 1, 10, NULL, 10, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(11, 1, 17, '', 11, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(12, 1, 19, NULL, 12, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(13, 2, 1, NULL, 1, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(14, 2, 2, NULL, 2, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(15, 2, 3, NULL, 3, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(16, 2, 6, "{"is_show":"true","can_edit":"true"}", 4, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(17, 2, 16, NULL, 5, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(18, 2, 4, NULL, 6, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(19, 2, 7, NULL, 7, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(20, 2, 8, NULL, 8, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(21, 2, 9, NULL, 9, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(22, 2, 10, NULL, 10, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(24, 2, 19, NULL, 12, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(25, 3, 1, NULL, 1, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(26, 3, 2, NULL, 2, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(27, 3, 3, NULL, 3, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(28, 3, 4, NULL, 4, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(29, 3, 11, NULL, 5, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(30, 3, 12, NULL, 6, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(31, 3, 13, NULL, 7, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(32, 3, 14, NULL, 8, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(33, 3, 15, NULL, 9, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(34, 3, 7, NULL, 10, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(35, 3, 8, NULL, 11, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(36, 3, 9, NULL, 12, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(37, 3, 10, NULL, 13, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(38, 3, 17, "{"comparison_name":"total_count.total"}", 14, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(39, 3, 19, NULL, 15, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(40, 4, 1, NULL, 1, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(41, 4, 2, NULL, 2, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(42, 4, 3, NULL, 3, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(43, 4, 6, "{"is_show":"true","can_edit":"true"}", 4, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(44, 4, 16, NULL, 5, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(45, 4, 11, NULL, 6, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(46, 4, 12, NULL, 7, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(47, 4, 13, NULL, 8, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(48, 4, 17, "{"is_show":"true","can_edit":"true"}", 9, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(49, 4, 18, NULL, 10, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(50, 4, 7, NULL, 11, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(51, 4, 8, NULL, 12, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(52, 4, 9, NULL, 13, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(53, 4, 10, NULL, 14, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(62, 3, 6, "{"statistics_name":"miss_count.miss"}", 18, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(63, 5, 1, NULL, 1, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(64, 5, 2, NULL, 2, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(65, 5, 3, NULL, 3, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(66, 5, 4, NULL, 4, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(67, 5, 5, NULL, 5, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(68, 5, 6, "{"statistics_name":"invalid_length_count.valids"}", 6, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(69, 5, 24, NULL, 7, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(70, 5, 23, NULL, 8, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(71, 5, 7, NULL, 9, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(72, 5, 8, NULL, 10, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(73, 5, 9, NULL, 11, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(74, 5, 10, NULL, 12, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(75, 5, 17, '', 13, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(76, 5, 19, NULL, 14, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(79, 6, 1, NULL, 1, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(80, 6, 2, NULL, 2, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(81, 6, 3, NULL, 3, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(82, 6, 4, NULL, 4, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(83, 6, 5, NULL, 5, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(84, 6, 6, "{"statistics_name":"duplicate_count.duplicates"}", 6, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(85, 6, 7, NULL, 7, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(86, 6, 8, NULL, 8, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(87, 6, 9, NULL, 9, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(88, 6, 10, NULL, 10, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(89, 6, 17, '', 11, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(90, 6, 19, NULL, 12, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(93, 7, 1, NULL, 1, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(94, 7, 2, NULL, 2, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(95, 7, 3, NULL, 3, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(96, 7, 4, NULL, 4, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(97, 7, 5, NULL, 5, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(98, 7, 6, "{"statistics_name":"regexp_count.regexps"}", 6, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(99, 7, 25, NULL, 5, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(100, 7, 7, NULL, 7, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(101, 7, 8, NULL, 8, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(102, 7, 9, NULL, 9, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(103, 7, 10, NULL, 10, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(104, 7, 17, NULL, 11, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(105, 7, 19, NULL, 12, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(108, 8, 1, NULL, 1, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(109, 8, 2, NULL, 2, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(110, 8, 3, NULL, 3, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(111, 8, 4, NULL, 4, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(112, 8, 5, NULL, 5, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(113, 8, 6, "{"statistics_name":"timeliness_count.timeliness"}", 6, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(114, 8, 26, NULL, 8, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(115, 8, 27, NULL, 9, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(116, 8, 7, NULL, 10, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(117, 8, 8, NULL, 11, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(118, 8, 9, NULL, 12, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(119, 8, 10, NULL, 13, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(120, 8, 17, NULL, 14, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(121, 8, 19, NULL, 15, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(124, 9, 1, NULL, 1, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(125, 9, 2, NULL, 2, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(126, 9, 3, NULL, 3, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(127, 9, 4, NULL, 4, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(128, 9, 5, NULL, 5, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(129, 9, 6, "{"statistics_name":"enum_count.enums"}", 6, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(130, 9, 28, NULL, 7, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(131, 9, 7, NULL, 8, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(132, 9, 8, NULL, 9, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(133, 9, 9, NULL, 10, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(134, 9, 10, NULL, 11, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(135, 9, 17, NULL, 12, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(136, 9, 19, NULL, 13, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(139, 10, 1, NULL, 1, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(140, 10, 2, NULL, 2, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(141, 10, 3, NULL, 3, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(142, 10, 4, NULL, 4, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(143, 10, 6, "{"statistics_name":"table_count.total"}", 6, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(144, 10, 7, NULL, 7, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(145, 10, 8, NULL, 8, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(146, 10, 9, NULL, 9, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(147, 10, 10, NULL, 10, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(148, 10, 17, NULL, 11, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(149, 10, 19, NULL, 12, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';
EXECUTE 'INSERT INTO' || quote_ident(v_schema) ||'.t_ds_relation_rule_input_entry
    (id, rule_id, rule_input_entry_id, values_map, "index", create_time, update_time)
    VALUES(150, 8, 29, NULL, 7, "2021-03-03 11:31:24.000", "2021-03-03 11:31:24.000")';

return 'Success!';
exception when others then
		---Raise EXCEPTION '(%)',SQLERRM;
        return SQLERRM;
END;
$BODY$;

select dolphin_insert_dq_initial_data();

d//