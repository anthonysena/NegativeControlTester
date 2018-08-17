INSERT INTO @target_database_schema.@target_cohort_table (
	subject_id,
	cohort_definition_id,
	cohort_start_date,
	cohort_end_date
)
SELECT person_id subject_id,
        ancestor_concept_id cohort_definition_id,
        condition_era_start_date cohort_start_date,
        condition_era_end_date cohort_end_date
FROM @cdm_database_schema.condition_era
INNER JOIN @cdm_database_schema.concept_ancestor
 ON ancestor_concept_id = descendant_concept_id
WHERE ancestor_concept_id IN (@outcome_ids)
UNION ALL
SELECT person_id subject_id,
        ancestor_concept_id cohort_definition_id,
        measurement_date cohort_start_date,
        measurement_date cohort_end_date
FROM @cdm_database_schema.measurement
INNER JOIN @cdm_database_schema.concept_ancestor
 ON ancestor_concept_id = descendant_concept_id
WHERE ancestor_concept_id IN (@outcome_ids)
