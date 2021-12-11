# Pewlett-Hackard Analysis: Planning for the Silver Tsunami

## Overview
Pewlett-Hackard employees 240,124 staff in nine departments and seven different job titles. Of those 240,124 employees, 90,398 are eligible to retire within the next three years, which represents nearly 38% of their workforce. The company has asked for an analysis of their human resources database to determine:
- How many potential retirees exist
- What are the job titles of these potential retirees
- Are there enough mentors available to train new employees for positions vacated by retirees

## Results
Two major data components are necessary to perform the analysis. The first identifies all possible employees eligible for retirment within the next three yeas; the second looks for current employees who may be eligible for the mentorship program. 

### Deliverable One
The first database query used to determine the potential retirees looks for all current employees whose birthday's fall between January 1, 1952 and December 31, 1955. This initial file was exported as retirement_titles.csv; however, there is duplication in this file that must be addressed. The query is provided in the event there is a need for future refinement:

      ```
      SELECT e.emp_no, 
        e.first_name, 
        e.last_name, 
        t.title, 
        t.from_date, 
        t.to_date
      INTO retirement_titles
      FROM employees as e
      INNER JOIN	titles as t
      ON e.emp_no = t.emp_no
      WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
      ORDER BY e.emp_no;
      ```

Next, duplication is removed to identify only those eligible retirees by their current title/ position. This list generates a unique list of eligibile employees, using the query below:

      ```
      SELECT DISTINCT ON (rt.emp_no)
        rt.emp_no, 
        rt.first_name, 
        rt.last_name, 
        rt.title
      INTO unique_titles
      FROM retirement_titles as rt
      ORDER BY rt.emp_no, rt.to_date DESC;
      ```
And finally, a summary is generated using the above data to identify the number of eligible retirees by job title. There are 90,398 employees eligible to retire in the next three years. The image presents the data by title, sorted largest to smallest number of retirees.

<img src ="images/retiring_titles_table.png" width="40%" height="20%">

### Deliverable Two
Next it is necessary to find those who are candidates for the mentorship program the company plans. These mentors will need to be sufficient in number to train future new employees hired to replace retirees. Initially, the prospective mentorship list was filtered to include all employees by title whose birthdays fall between January 1 - December 31, 1965. The following query is provided in the event of future needed refinement:

      ```
      SELECT DISTINCT ON (e.emp_no) e.emp_no, 
            e.first_name, 
            e.last_name, 
            e.birth_date,
            de.from_date,
            de.to_date,
            t.title
      INTO mentorship_eligibility
      FROM employees as e
      INNER JOIN dept_emp as de
      ON e.emp_no = de.emp_no
      INNER JOIN titles as t
      ON e.emp_no = t.emp_no
      WHERE (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
      AND t.to_date ='9999-01-01'
      ORDER BY e.emp_no, t.to_date DESC;
      ```
Using similar queries and processes to deliverable one, a mentorship list is defined, and summarized to show the distribution of mentors by job title. There are 1549 mentors returned in the query results and presented here:

<img src = "images/mentor_summary_by_title.png" width="40%" height="20%">
                                                                    
## Summary of the Analysis
