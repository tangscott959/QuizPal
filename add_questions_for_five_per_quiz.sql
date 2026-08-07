-- Add questions so every category has at least 5 active questions for fixed-length quizzes.
-- Safe to run on an existing quiz_db_new database; skips rows that already exist.

USE quiz_db_new;

INSERT INTO question (category_id, question_text, question_type, difficulty_level, points)
SELECT 1, 'What is 15 - 7?', 'MULTIPLE_CHOICE', 'EASY', 1
WHERE NOT EXISTS (
    SELECT 1 FROM question WHERE category_id = 1 AND question_text = 'What is 15 - 7?'
);

INSERT INTO question (category_id, question_text, question_type, difficulty_level, points)
SELECT 1, 'What is 100 ÷ 4?', 'MULTIPLE_CHOICE', 'EASY', 1
WHERE NOT EXISTS (
    SELECT 1 FROM question WHERE category_id = 1 AND question_text = 'What is 100 ÷ 4?'
);

INSERT INTO question (category_id, question_text, question_type, difficulty_level, points)
SELECT 1, 'What is 3 squared (3²)?', 'MULTIPLE_CHOICE', 'EASY', 1
WHERE NOT EXISTS (
    SELECT 1 FROM question WHERE category_id = 1 AND question_text = 'What is 3 squared (3²)?'
);

INSERT INTO question (category_id, question_text, question_type, difficulty_level, points)
SELECT 2, 'Which planet is closest to the Sun?', 'MULTIPLE_CHOICE', 'EASY', 1
WHERE NOT EXISTS (
    SELECT 1 FROM question WHERE category_id = 2 AND question_text = 'Which planet is closest to the Sun?'
);

INSERT INTO question (category_id, question_text, question_type, difficulty_level, points)
SELECT 2, 'What gas do plants absorb from the air?', 'MULTIPLE_CHOICE', 'EASY', 1
WHERE NOT EXISTS (
    SELECT 1 FROM question WHERE category_id = 2 AND question_text = 'What gas do plants absorb from the air?'
);

INSERT INTO question (category_id, question_text, question_type, difficulty_level, points)
SELECT 2, 'What is the center of an atom called?', 'MULTIPLE_CHOICE', 'MEDIUM', 2
WHERE NOT EXISTS (
    SELECT 1 FROM question WHERE category_id = 2 AND question_text = 'What is the center of an atom called?'
);

INSERT INTO question (category_id, question_text, question_type, difficulty_level, points)
SELECT 2, 'What force keeps us on the ground?', 'MULTIPLE_CHOICE', 'EASY', 1
WHERE NOT EXISTS (
    SELECT 1 FROM question WHERE category_id = 2 AND question_text = 'What force keeps us on the ground?'
);

INSERT INTO question (category_id, question_text, question_type, difficulty_level, points)
SELECT 3, 'Who was the first President of the United States?', 'MULTIPLE_CHOICE', 'EASY', 1
WHERE NOT EXISTS (
    SELECT 1 FROM question WHERE category_id = 3 AND question_text = 'Who was the first President of the United States?'
);

INSERT INTO question (category_id, question_text, question_type, difficulty_level, points)
SELECT 3, 'In which year did World War I begin?', 'MULTIPLE_CHOICE', 'MEDIUM', 2
WHERE NOT EXISTS (
    SELECT 1 FROM question WHERE category_id = 3 AND question_text = 'In which year did World War I begin?'
);

INSERT INTO question (category_id, question_text, question_type, difficulty_level, points)
SELECT 3, 'What ancient civilization built the pyramids at Giza?', 'MULTIPLE_CHOICE', 'EASY', 1
WHERE NOT EXISTS (
    SELECT 1 FROM question WHERE category_id = 3 AND question_text = 'What ancient civilization built the pyramids at Giza?'
);

INSERT INTO question (category_id, question_text, question_type, difficulty_level, points)
SELECT 3, 'In which year did the Berlin Wall fall?', 'MULTIPLE_CHOICE', 'MEDIUM', 2
WHERE NOT EXISTS (
    SELECT 1 FROM question WHERE category_id = 3 AND question_text = 'In which year did the Berlin Wall fall?'
);

INSERT INTO choice (question_id, choice_text, is_correct, choice_order)
SELECT q.question_id, v.choice_text, v.is_correct, v.choice_order
FROM question q
JOIN (
    SELECT 'What is 15 - 7?' AS question_text, '8' AS choice_text, TRUE AS is_correct, 1 AS choice_order UNION ALL
    SELECT 'What is 15 - 7?', '6', FALSE, 2 UNION ALL
    SELECT 'What is 15 - 7?', '7', FALSE, 3 UNION ALL
    SELECT 'What is 15 - 7?', '9', FALSE, 4 UNION ALL
    SELECT 'What is 100 ÷ 4?', '25', TRUE, 1 UNION ALL
    SELECT 'What is 100 ÷ 4?', '20', FALSE, 2 UNION ALL
    SELECT 'What is 100 ÷ 4?', '30', FALSE, 3 UNION ALL
    SELECT 'What is 100 ÷ 4?', '40', FALSE, 4 UNION ALL
    SELECT 'What is 3 squared (3²)?', '9', TRUE, 1 UNION ALL
    SELECT 'What is 3 squared (3²)?', '6', FALSE, 2 UNION ALL
    SELECT 'What is 3 squared (3²)?', '12', FALSE, 3 UNION ALL
    SELECT 'What is 3 squared (3²)?', '27', FALSE, 4 UNION ALL
    SELECT 'Which planet is closest to the Sun?', 'Mercury', TRUE, 1 UNION ALL
    SELECT 'Which planet is closest to the Sun?', 'Venus', FALSE, 2 UNION ALL
    SELECT 'Which planet is closest to the Sun?', 'Earth', FALSE, 3 UNION ALL
    SELECT 'Which planet is closest to the Sun?', 'Mars', FALSE, 4 UNION ALL
    SELECT 'What gas do plants absorb from the air?', 'Carbon dioxide', TRUE, 1 UNION ALL
    SELECT 'What gas do plants absorb from the air?', 'Oxygen', FALSE, 2 UNION ALL
    SELECT 'What gas do plants absorb from the air?', 'Nitrogen', FALSE, 3 UNION ALL
    SELECT 'What gas do plants absorb from the air?', 'Hydrogen', FALSE, 4 UNION ALL
    SELECT 'What is the center of an atom called?', 'Nucleus', TRUE, 1 UNION ALL
    SELECT 'What is the center of an atom called?', 'Electron', FALSE, 2 UNION ALL
    SELECT 'What is the center of an atom called?', 'Proton shell', FALSE, 3 UNION ALL
    SELECT 'What is the center of an atom called?', 'Neutron cloud', FALSE, 4 UNION ALL
    SELECT 'What force keeps us on the ground?', 'Gravity', TRUE, 1 UNION ALL
    SELECT 'What force keeps us on the ground?', 'Magnetism', FALSE, 2 UNION ALL
    SELECT 'What force keeps us on the ground?', 'Friction', FALSE, 3 UNION ALL
    SELECT 'What force keeps us on the ground?', 'Pressure', FALSE, 4 UNION ALL
    SELECT 'Who was the first President of the United States?', 'George Washington', TRUE, 1 UNION ALL
    SELECT 'Who was the first President of the United States?', 'Thomas Jefferson', FALSE, 2 UNION ALL
    SELECT 'Who was the first President of the United States?', 'Abraham Lincoln', FALSE, 3 UNION ALL
    SELECT 'Who was the first President of the United States?', 'John Adams', FALSE, 4 UNION ALL
    SELECT 'In which year did World War I begin?', '1914', TRUE, 1 UNION ALL
    SELECT 'In which year did World War I begin?', '1918', FALSE, 2 UNION ALL
    SELECT 'In which year did World War I begin?', '1939', FALSE, 3 UNION ALL
    SELECT 'In which year did World War I begin?', '1900', FALSE, 4 UNION ALL
    SELECT 'What ancient civilization built the pyramids at Giza?', 'Ancient Egypt', TRUE, 1 UNION ALL
    SELECT 'What ancient civilization built the pyramids at Giza?', 'Ancient Rome', FALSE, 2 UNION ALL
    SELECT 'What ancient civilization built the pyramids at Giza?', 'Ancient Greece', FALSE, 3 UNION ALL
    SELECT 'What ancient civilization built the pyramids at Giza?', 'Mesopotamia', FALSE, 4 UNION ALL
    SELECT 'In which year did the Berlin Wall fall?', '1989', TRUE, 1 UNION ALL
    SELECT 'In which year did the Berlin Wall fall?', '1991', FALSE, 2 UNION ALL
    SELECT 'In which year did the Berlin Wall fall?', '1985', FALSE, 3 UNION ALL
    SELECT 'In which year did the Berlin Wall fall?', '1979', FALSE, 4
) v ON q.question_text = v.question_text
LEFT JOIN choice c ON c.question_id = q.question_id AND c.choice_text = v.choice_text
WHERE c.choice_id IS NULL;
