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
        drug_era_start_date cohort_start_date,
        drug_era_end_date cohort_end_date
FROM @cdm_database_schema.drug_era
INNER JOIN @cdm_database_schema.concept_ancestor
 ON ancestor_concept_id = descendant_concept_id
WHERE ancestor_concept_id IN (@outcome_ids)
UNION ALL
SELECT person_id subject_id,
        ancestor_concept_id cohort_definition_id,
        device_exposure_start_date cohort_start_date,
        device_exposure_end_date cohort_end_date
FROM @cdm_database_schema.device_exposure
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
UNION ALL
SELECT person_id subject_id,
        ancestor_concept_id cohort_definition_id,
        observation_date cohort_start_date,
        observation_date cohort_end_date
FROM @cdm_database_schema.observation
INNER JOIN @cdm_database_schema.concept_ancestor
 ON ancestor_concept_id = descendant_concept_id
WHERE ancestor_concept_id IN (@outcome_ids)
UNION ALL
SELECT person_id subject_id,
        ancestor_concept_id cohort_definition_id,
        procedure_date cohort_start_date,
        procedure_date cohort_end_date
FROM @cdm_database_schema.procedure_occurrence
INNER JOIN @cdm_database_schema.concept_ancestor
 ON ancestor_concept_id = descendant_concept_id
WHERE ancestor_concept_id IN (@outcome_ids)
UNION ALL
SELECT person_id subject_id,
        ancestor_concept_id cohort_definition_id,
        visit_start_date cohort_start_date,
        visit_end_date cohort_end_date
FROM @cdm_database_schema.visit_occurrence
INNER JOIN @cdm_database_schema.concept_ancestor
 ON ancestor_concept_id = descendant_concept_id
WHERE ancestor_concept_id IN (@outcome_ids)
    ) e
) s
WHERE s.ordinal = 1
;
