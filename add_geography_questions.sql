-- Add Geography Questions to Existing Database
-- This file adds 6 geography questions to the quiz_db_new database

-- Insert geography questions (category_id = 4 for Geography)
INSERT INTO question (category_id, question_text, question_type, difficulty_level, points) VALUES
(4, 'What is the capital of France?', 'MULTIPLE_CHOICE', 'EASY', 1),
(4, 'Which is the largest continent by area?', 'MULTIPLE_CHOICE', 'EASY', 1),
(4, 'What is the longest river in the world?', 'MULTIPLE_CHOICE', 'MEDIUM', 2),
(4, 'Which country has the largest population?', 'MULTIPLE_CHOICE', 'MEDIUM', 2),
(4, 'What is the smallest country in the world?', 'MULTIPLE_CHOICE', 'HARD', 3),
(4, 'Which desert is the largest in the world?', 'MULTIPLE_CHOICE', 'HARD', 3);

-- Insert choices for geography questions
-- Note: These question IDs (5-10) assume you already have 4 questions in the database
-- If you have more questions, adjust the question IDs accordingly

INSERT INTO choice (question_id, choice_text, is_correct, choice_order) VALUES
-- Question 5: Capital of France
(5, 'London', FALSE, 1),
(5, 'Paris', TRUE, 2),
(5, 'Berlin', FALSE, 3),
(5, 'Madrid', FALSE, 4),

-- Question 6: Largest continent
(6, 'Africa', FALSE, 1),
(6, 'Asia', TRUE, 2),
(6, 'Europe', FALSE, 3),
(6, 'North America', FALSE, 4),

-- Question 7: Longest river
(7, 'Amazon', FALSE, 1),
(7, 'Nile', TRUE, 2),
(7, 'Yangtze', FALSE, 3),
(7, 'Mississippi', FALSE, 4),

-- Question 8: Largest population
(8, 'India', FALSE, 1),
(8, 'United States', FALSE, 2),
(8, 'China', TRUE, 3),
(8, 'Brazil', FALSE, 4),

-- Question 9: Smallest country
(9, 'Monaco', FALSE, 1),
(9, 'San Marino', FALSE, 2),
(9, 'Vatican City', TRUE, 3),
(9, 'Liechtenstein', FALSE, 4),

-- Question 10: Largest desert
(10, 'Sahara', FALSE, 1),
(10, 'Arabian', FALSE, 2),
(10, 'Antarctica', TRUE, 3),
(10, 'Gobi', FALSE, 4);

-- Verify the questions were added
SELECT 
    q.question_id,
    q.question_text,
    q.difficulty_level,
    c.category_name
FROM question q
JOIN category c ON q.category_id = c.category_id
WHERE c.category_name = 'Geography'
ORDER BY q.question_id;
