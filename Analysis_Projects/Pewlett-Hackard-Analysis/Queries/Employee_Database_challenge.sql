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
SELECT DISTINCT ON (e.emp_no) e.emp_no, t.title
FROM employees as e
INNER JOIN titles as t
ON e.emp_no = t.emp_no
WHERE t.to_date = '9999-01-01'
ORDER BY e.emp_no, t.to_date DESC;

-- How many current employees by department?
SELECT COUNT(de.emp_no), d.dept_name
FROM dept_emp as de
INNER JOIN departments as d
ON de.dept_no = d.dept_no
WHERE de.to_date = '9999-01-01'
GROUP BY d.dept_name;

-- Find the ratio of retirees to potential mentors
SELECT title, COUNT(emp_no) "Potential Mentors"
FROM mentorship_eligibility
GROUP BY title
ORDER BY "Potential Mentors" DESC;

SELECT * FROM retiring_titles;

SELECT COUNT(emp_no) FROM titles
WHERE to_date = '9999-01-01';

SELECT SUM(count) FROM retiring_titles;

SELECT * FROM departments;

