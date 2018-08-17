INSERT INTO @target_database_schema.@target_cohort_table (
	subject_id,
	cohort_definition_id,
	cohort_start_date,
	cohort_end_date
)
SELECT 
	s.subject_id,
	s.cohort_definition_id,
	s.cohort_start_date,
	s.cohort_end_date
FROM (
    SELECT
            e.subject_id,
            e.cohort_definition_id,
            e.cohort_start_date,
            e.cohort_end_date,
            ROW_NUMBER() OVER (PARTITION BY e.subject_id, e.cohort_definition_id ORDER BY e.COHORT_START_DATE ASC) ordinal
    FROM (
        SELECT person_id subject_id,
        procedure_concept_id cohort_definition_id,
        procedure_date cohort_start_date,
        procedure_date cohort_end_date
FROM @cdm_database_schema.procedure_occurrence

WHERE procedure_concept_id IN (@outcome_ids)
    ) e
) s
WHERE s.ordinal = 1
;
