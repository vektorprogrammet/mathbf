
use vektorprogrammet;

WITH answer_scores AS (
       SELECT answer_score,
              COUNT(*) as cnt
       FROM (
              SELECT *,
                     CASE
                       WHEN answer = 'Enig' THEN 3
                       WHEN answer = 'Delvis enig' THEN 1
                       WHEN answer = 'Delvis uenig' THEN -1
                       WHEN answer = 'Uenig' THEN 0
                       WHEN answer = 'Ja' THEN 3
                       WHEN answer = 'Nei' THEN -3
                       WHEN answer = 'Passe' THEN 1
                       WHEN answer = 'Fornøyd' THEN 1
                       WHEN answer = 'Veldig Fornøyd' THEN 3
                       WHEN answer = 'Usikker' THEN -1
                       WHEN answer = 'Nøytral' THEN 0
                       WHEN answer = 'Mangelfull' THEN -1
                       WHEN answer = 'Litt for omfattende' THEN -1
                       WHEN answer = 'Misfornøyd' THEN -1
                       WHEN answer = 'Svært misfornøyd' THEN -3
                       WHEN answer = 'Har ikke brukt kompendiet' THEN -1
                       WHEN answer = 'Veldig misfornøyd' THEN -3
                       WHEN answer = 'Jeg deltok ikke' THEN 3 # Means that they have been assistant before
                       WHEN answer = 'Jeg brukte ikke nettsiden' THEN -1
                       WHEN answer = 'Hadde ikke behov for kontakt' THEN 1
                       END
                       AS answer_score
              FROM survey_answer
              WHERE answer IN
                    ('For omfattende', 'Litt for omfattende', 'Mangelfull', 'Svært mangelfull', 'Ja',
                     'Nei', 'Nøytral',
                     'Passe',
                     'Fornøyd', 'Veldig misfornøyd', 'Misfornøyd', 'Delvis uenig', 'Uenig', 'Usikker',
                     'Delvis Enig', 'Enig',
                     'Har ikke brukt kompendiet', 'Jeg deltok ikke', 'Jeg brukte ikke nettsiden',
                     'Hadde ikke behov for kontakt')
            ) survey_answer_with_score
              LEFT JOIN survey_question ON survey_answer_with_score.question_id = survey_question.id
              LEFT JOIN survey_taken ON survey_taken.id = survey_answer_with_score.survey_taken_id
              LEFT JOIN survey on survey_taken.survey_id = survey.id
              LEFT JOIN school on survey_taken.school_id = school.id
              LEFT JOIN department d on survey.department_id = d.id
       WHERE survey.name LIKE 'Elevundersøkelse'
         AND time NOT LIKE '2015-%'
         AND time NOT LIKE '2016-%'
         AND short_name = 'NTNU'
       GROUP BY 1
       LIMIT 10000000
     )
SELECT answer_score, cnt / (SELECT sum(cnt) FROM answer_scores) AS proportion FROM answer_scores;
