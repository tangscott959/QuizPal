-- Create views after running the migration script
-- These views require the new columns added in the migration

-- View for quiz results with user and category info
CREATE OR REPLACE VIEW `quiz_results_view` AS
SELECT 
    q.quiz_id,
    q.quiz_name,
    q.status,
    q.score,
    q.max_score,
    ROUND((q.score / NULLIF(q.max_score, 0)) * 100, 2) AS percentage,
    q.quiz_time_start,
    q.quiz_time_end,
    TIMESTAMPDIFF(SECOND, q.quiz_time_start, q.quiz_time_end) AS duration_seconds,
    u.user_id,
    u.user_name,
    CONCAT(u.firstname, ' ', u.lastname) AS full_name,
    c.category_id,
    c.category_name
FROM quiz q
JOIN user u ON q.user_id = u.user_id
JOIN category c ON q.category_id = c.category_id;

-- View for question statistics
CREATE OR REPLACE VIEW `question_stats_view` AS
SELECT 
    q.question_id,
    q.question_text,
    q.difficulty_level,
    q.points,
    c.category_name,
    COUNT(qa.answer_id) AS times_answered,
    COUNT(CASE WHEN qa.is_correct = TRUE THEN 1 END) AS times_correct,
    ROUND((COUNT(CASE WHEN qa.is_correct = TRUE THEN 1 END) / 
           NULLIF(COUNT(qa.answer_id), 0)) * 100, 2) AS success_rate
FROM question q
JOIN category c ON q.category_id = c.category_id
LEFT JOIN quiz_answer qa ON q.question_id = qa.question_id
GROUP BY q.question_id, q.question_text, q.difficulty_level, q.points, c.category_name;

-- Alternative view using the old quizquestion table for backward compatibility
CREATE OR REPLACE VIEW `quiz_results_legacy_view` AS
SELECT 
    q.quiz_id,
    q.quiz_name,
    COALESCE(q.status, 'COMPLETED') AS status,
    COALESCE(q.score, 
        (SELECT COUNT(*) 
         FROM quizquestion qq 
         JOIN choice c ON qq.choice_id = c.choice_id 
         WHERE qq.quiz_id = q.quiz_id AND c.is_correct = 1)
    ) AS score,
    COALESCE(q.max_score, 
        (SELECT COUNT(*) FROM quizquestion WHERE quiz_id = q.quiz_id)
    ) AS max_score,
    ROUND(
        (COALESCE(q.score, 
            (SELECT COUNT(*) 
             FROM quizquestion qq 
             JOIN choice c ON qq.choice_id = c.choice_id 
             WHERE qq.quiz_id = q.quiz_id AND c.is_correct = 1)
        ) / 
        NULLIF(COALESCE(q.max_score, 
            (SELECT COUNT(*) FROM quizquestion WHERE quiz_id = q.quiz_id)
        ), 0)) * 100, 2
    ) AS percentage,
    q.quiz_time_start,
    q.quiz_time_end,
    TIMESTAMPDIFF(SECOND, q.quiz_time_start, q.quiz_time_end) AS duration_seconds,
    u.user_id,
    u.user_name,
    CONCAT(u.firstname, ' ', u.lastname) AS full_name,
    c.category_id,
    c.category_name
FROM quiz q
JOIN user u ON q.user_id = u.user_id
JOIN category c ON q.category_id = c.category_id;
