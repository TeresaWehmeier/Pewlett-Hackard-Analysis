--SQL query DELIVERABLE 1 steps 1 - 7
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

-- Check table file
SELECT * FROM retirement_titles;

-- Use Dictinct ON with Orderby to remove duplicate rows DELIVERABLE 1, 8-14
SELECT DISTINCT ON (rt.emp_no)
	rt.emp_no, 
	rt.first_name, 
	rt.last_name, 
	rt.title
INTO unique_titles
FROM retirement_titles as rt
ORDER BY rt.emp_no, rt.to_date DESC;

-- Check unique_tables creation
SELECT * FROM unique_titles;

-- select the number of retiring employees by title DELIVERABLE 1, 15-21
SELECT COUNT(emp_no) "Eligible Retirees", title "Title"
INTO retiring_titles
FROM unique_titles
GROUP BY "Title"
ORDER BY "Eligible Retirees" DESC;

-- Check retiring_titles creation
SELECT * FROM retiring_titles;


-- Create mentorship eligibility table DELIVERABLE 2, 1-11
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



-- OTHER QUERIES FOR ANALYSIS
-- Double check current employee headcount by job title
SELECT DISTINCT ON (e.emp_no) e.emp_no, t.title
FROM employees as e
INNER JOIN titles as t
ON e.emp_no = t.emp_no
WHERE t.to_date = '9999-01-01'
ORDER BY e.emp_no, t.to_date DESC;

-- How many current employees by department? 240,124 total employees
SELECT COUNT(de.emp_no), d.dept_name
FROM dept_emp as de
INNER JOIN departments as d
ON de.dept_no = d.dept_no
WHERE de.to_date = '9999-01-01'
GROUP BY d.dept_name;

-- Find the % of mentors to retirees
DROP TABLE mentor_summary;

SELECT title "mentor_title", COUNT(emp_no) "mentor_count"
INTO mentor_summary
FROM mentorship_eligibility
GROUP BY "mentor_title"
ORDER BY "mentor_count" DESC;

SELECT * FROM mentor_summary;

SELECT SUM(mentor_count) FROM mentor_summary;

-- What is the percentage of mentors to train new candidates 
SELECT rt.title "retiree_title", rt.count,
		ms.mentor_count mentor_count, 
		ROUND(CAST(mentor_count AS DEC) / CAST(rt.count AS DEC)*100,2) AS percent_mentors
FROM retiring_titles AS rt
LEFT JOIN mentor_summary AS ms
ON rt.title = ms.mentor_title
GROUP BY retiree_title, mentor_count, rt.count;

--Expand mentorship population out by increase birthdate range
SELECT * FROM mentorship_eligibility_expanded;

DROP TABLE mentorship_eligibility_expanded;

SELECT DISTINCT ON (e.emp_no) e.emp_no, 
	e.first_name, 
	e.last_name, 
	e.birth_date,
	de.from_date,
	de.to_date,
	t.title
INTO mentorship_eligibility_expanded
FROM employees as e
INNER JOIN dept_emp as de
ON e.emp_no = de.emp_no
INNER JOIN titles as t
ON e.emp_no = t.emp_no
WHERE (e.birth_date BETWEEN '1964-01-01' AND '1965-12-31')
AND t.to_date ='9999-01-01'
ORDER BY e.emp_no, t.to_date DESC;

--See how many mentors by department if the pool is expanded.
DROP TABLE mentor_summary_expanded;

SELECT title mentor_title, COUNT(emp_no) mentor_count
INTO mentor_summary_expanded
FROM mentorship_eligibility_expanded
GROUP BY mentor_title
ORDER BY mentor_count DESC;

select * from mentor_summary_expanded;


-- compare number of mentors to number or replacement positions for retirees
SELECT rt.title "Retiree Title", rt.count retirees,
		mentor_count, 
		ROUND(CAST(mentor_count AS DEC) / CAST(rt.count AS DEC)*100,2) AS percent_mentors
FROM retiring_titles AS rt
LEFT JOIN mentor_summary_expanded AS ms
ON rt.title = mentor_title
GROUP BY "Retiree Title", mentor_count, retirees;







