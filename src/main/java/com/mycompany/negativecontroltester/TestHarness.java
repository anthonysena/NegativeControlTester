/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.mycompany.negativecontroltester;

import java.io.FileNotFoundException;
import java.io.PrintWriter;
import org.ohdsi.circe.cohortdefinition.negativecontrols.CohortExpressionQueryBuilder;
import org.ohdsi.circe.cohortdefinition.negativecontrols.OutcomeCohortExpression;
import org.ohdsi.circe.cohortdefinition.negativecontrols.OccurrenceType;

/**
 *
 * @author asena5
 */
public class TestHarness {

    public static void main(String[] args) {
        OutcomeCohortExpression test1 = new OutcomeCohortExpression();
        test1.occurrenceType = OccurrenceType.FIRST;
        test1.detectOnDescendants = true;
        test1.domains.add("CONDITION");
        test1.domains.add("DRUG");
        test1.domains.add("DEVICE");
        test1.domains.add("MEASUREMENT");
        test1.domains.add("OBSERVATION");
        test1.domains.add("PROCEDURE");
        test1.domains.add("VISIT");
        
        OutcomeCohortExpression test2 = new OutcomeCohortExpression();
        test2.occurrenceType = OccurrenceType.ALL;
        test2.detectOnDescendants = true;
        test2.domains.add("CONDITION");
        test2.domains.add("MEASUREMENT");

        OutcomeCohortExpression test3 = new OutcomeCohortExpression();
        test3.occurrenceType = OccurrenceType.FIRST;
        test3.detectOnDescendants = false;
        test3.domains.add("PROCEDURE");
        
        CohortExpressionQueryBuilder queryBuilder = new CohortExpressionQueryBuilder();
        String query = "";
        try {
            query = queryBuilder.buildExpressionQuery(test1);
            try (PrintWriter out = new PrintWriter("test-1-all-domains-detect-true-occurrence-first.sql")) {
                out.println(query);
            } catch (FileNotFoundException ex) {
                System.out.println("ERROR: " + ex.getMessage());
            }
            
            query = queryBuilder.buildExpressionQuery(test2);
            try (PrintWriter out = new PrintWriter("test-2-2-domains-detect-true-occurrence-all.sql")) {
                out.println(query);
            } catch (FileNotFoundException ex) {
                System.out.println("ERROR: " + ex.getMessage());
            }
            
            query = queryBuilder.buildExpressionQuery(test3);
            try (PrintWriter out = new PrintWriter("test-3-1-domain-detect-false-occurrence-first.sql")) {
                out.println(query);
            } catch (FileNotFoundException ex) {
                System.out.println("ERROR: " + ex.getMessage());
            }
            
            String json = "{\"detectOnDescendants\":\"true\",\"domains\":[\"condition\"],\"occurrenceType\":\"all\"}";
            OutcomeCohortExpression cohortExpression = OutcomeCohortExpression.fromJson(json);
            query = queryBuilder.buildExpressionQuery(cohortExpression);
            try (PrintWriter out = new PrintWriter("test-4-from-json.sql")) {
                out.println(query);
            } catch (FileNotFoundException ex) {
                System.out.println("ERROR: " + ex.getMessage());
            }
        } catch (Exception e) {
            System.out.println("Error: " + e.getMessage());
        }
        System.out.println(query);

    }
}
