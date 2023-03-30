/*
    Lab 1 - SQL Select Statements (queries)
    
    Name: Nathan Oliver
 */
 
-- don't forget to set your search path; this sets it for the current session:
SET search_path = history;

-- windows psql needs the following line uncommented
-- \encoding utf-8

-- add other environment changes here (pager, etc.)

-- add your SQL query to provide the answer to each question 
-- after the comment containing the question; for example:

/*
   0. What do we know about pioneers born before 1900?
 */
SELECT * 
FROM pioneer 
WHERE birth < 1900;

/*
   1. What is Jim Melton known for?
 */
SELECT known_for 
FROM pioneer 
WHERE last = 'Melton';
/* 
   2. Which pioneer's last name started with 'S' whose first name did not start with 'M' 
      and what were they known for?
 */
SELECT pioneer.first, pioneer.last, pioneer.known_for 
FROM pioneer 
WHERE LEFT(last, 1) = 'S' AND LEFT(first, 1) <> 'M';
/* 
   3. For the pioneers who are living, give me their name in a single column (first and
      last, separated with a space), their birth year, and what they are known for, 
      sorted from oldest to youngest.
 */
SELECT CONCAT(pioneer.first, ' ', pioneer.last), pioneer.birth, pioneer.known_for 
FROM pioneer 
WHERE pioneer.death is null ORDER BY pioneer.birth;
/* 
   4. Which of the pioneers are deceased (have a known death date)? Include their name,
      their age at death, and their death date, and provide in descending age.
 */
SELECT CONCAT(pioneer.first, ' ', pioneer.last), pioneer.death - pioneer.birth AS age, pioneer.death 
FROM pioneer 
WHERE pioneer.death is not null ORDER BY age DESC;
/* 
   5. Provide a list of organizations and their database_contributions where the
      contribution includes the word developing in it, in any case (upper, lower, or mixed
      case). In the result, call the organization name simply organization, and change 
      database_contribution to contribution. List in alphabetic order by organization 
      name.
 */
SELECT organization.name, organization.database_contributions AS contribution 
FROM organization 
WHERE UPPER(organization.database_contributions) LIKE UPPER('%developing%') ORDER BY organization.name;
/* 
   6. List the roles pioneers take in their organizations, only listing each role one time
      and sorting alphabetically. (Note, if two pioneers have the same role, it would 
      still only be listed one time.)
 */
SELECT DISTINCT role 
FROM pioneer_org_xref
ORDER BY role;
/* 
   7. What is the contribution of the organizations which were founded in the timeframe
      1890-1960? Provide the organization’s name and contribution, and list them in the
      order they were founded.
 */
SELECT organization.name, organization.database_contributions 
FROM organization 
WHERE organization.founded > 1889 AND organization.founded < 1961 ORDER BY organization.founded;

/* 
   8. Provide a list of pioneers ordered by their age; use their age at death if they are
      dead, otherwise use their current age (do not hard-code the current year). Include
      the pioneer's name as a single column and their age. Put them in age order.
 */
SELECT CONCAT(pioneer.first, ' ', pioneer.last), 
   CASE 
      WHEN pioneer.death is null THEN EXTRACT(year FROM current_date) - pioneer.birth
      ELSE pioneer.death - pioneer.birth
   END AS age
FROM pioneer ORDER BY age;
/* 
   9. Which pioneers were Computer Scientists? Order them by birth year.
 */
SELECT CONCAT(pioneer.first, ' ', pioneer.last)
FROM pioneer
   JOIN pioneer_org_xref
   ON pioneer.id = pioneer_org_xref.pioneer_id
WHERE pioneer_org_xref.role LIKE '%Computer Scientist%';
/* 
   10. Which of the pioneers have won Turing awards? Include their name as a single 
       column (first and last with a space between), when they won the award, and what 
       it was for. Keep them in pioneer name order (last then first).
 */
SELECT CONCAT(pioneer.first, ' ', pioneer.last), year_awarded, awarded_for
FROM pioneer
   JOIN turing_award
   ON pioneer.id = turing_award.pioneer_id;
/* 
   11. Which pioneers worked for IBM? List their names as "last, first" (i.e., with a
       comma between last and first name). Order by last name then first.
 */
SELECT CONCAT(pioneer.last, ', ', pioneer.first)
FROM pioneer
   JOIN pioneer_org_xref
   ON pioneer.id = pioneer_org_xref.pioneer_id 
   JOIN organization
   ON pioneer_org_xref.organization_id = organization.id
WHERE organization.name = 'IBM' ORDER BY pioneer.last;
/* 
   12. What is the name (first and last) of the oldest pioneer who was a co-founder
       (assume there is only one oldest pioneer). Note, you will have to determine 
       their age when the company was founded.
 */
SELECT CONCAT(pioneer.first, ' ', pioneer.last)
FROM pioneer
   JOIN pioneer_org_xref
   ON pioneer.id = pioneer_org_xref.pioneer_id
   JOIN organization
   ON pioneer_org_xref.organization_id = organization.id
WHERE pioneer_org_xref.role LIKE '%Co-founder%' ORDER BY pioneer.birth ASC FETCH FIRST ROW ONLY;
   
/* 
    Extra Credit - no points lost for not completing the queries below
 */

/* 
   13. Provide the current time but put the hour, minute, and second each in their own 
       column with the field name as the name of the column (i.e. the hour column should 
       be named hour). 
 */
SELECT EXTRACT(hour FROM current_timestamp) AS hour, EXTRACT(minute FROM current_timestamp) AS minute, EXTRACT(second FROM current_timestamp) AS second;
/* 
   14. Where did the people who won Turing awards work? Include their name and the 
       organizations they have worked for. Do not assume data is static - include the 
       turing_award table in your query to ensure future winners would also appear. 
       Order by pioneer name and organization.
 */
SELECT CONCAT(pioneer.first, ' ', pioneer.last), organization.name
FROM pioneer
   JOIN pioneer_org_xref
   ON pioneer.id = pioneer_org_xref.pioneer_id
   JOIN organization
   ON pioneer_org_xref.organization_id = organization.id
   JOIN turing_award
   ON pioneer_org_xref.pioneer_id = turing_award.pioneer_id;