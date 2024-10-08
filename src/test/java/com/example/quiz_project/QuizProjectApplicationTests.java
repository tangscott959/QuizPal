package com.example.quiz_project;

import com.example.quiz_project.dao.QuizDao;
import com.example.quiz_project.dao.QuizQuestionDao;
import com.example.quiz_project.dao.QuizRowMapper;
import com.example.quiz_project.domain.Quiz;
import com.example.quiz_project.domain.QuizQuestion;
import com.example.quiz_project.util.JdbcTemplatePager;
import com.example.quiz_project.util.PageData;
import org.junit.jupiter.api.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;


@SpringBootTest
class QuizProjectApplicationTests {
	@Autowired
	private QuizQuestionDao quizQuestionDao;
	@Autowired
	private QuizDao quizDao;
	@Autowired
	QuizRowMapper quizRowMapper;
	@Autowired
	JdbcTemplatePager jdbcTemplatePager;
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	@Test
	void contextLoads() {
	}
	@Test
	public void test01() {
		List<QuizQuestion> qqList = new ArrayList<>();
		QuizQuestion qq = new QuizQuestion();
		qq.setQuizId(4);
		qq.setChoiceId(1);
		qq.setQuestionId(1);
		qqList.add(qq);
		QuizQuestion qq1 = new QuizQuestion();
		qq1.setQuizId(4);
		qq1.setChoiceId(6);
		qq1.setQuestionId(2);
		qqList.add(qq1);

		//quizQuestionDao.addBatch(qqList);
	}

	@Test
	public void test02() {
		List<Map<String,Object>> r =quizQuestionDao.getScoreByUser(4);
		System.out.println(r.size());
		System.out.println(r);
	}

	@Test
	public void test03() {
		System.out.println(isNumeric("1"));
		System.out.println(isNumeric("01"));
		System.out.println(isNumeric("10"));
	}
	@Test
	public void test04() {
		List<Quiz> quizList = quizDao.getByUserName("tang");
		System.out.println(quizList.size());
	}
	public boolean isNumeric(String str) {
		return str != null && str.matches("-?\\d+(\\.\\d+)?");
	}

	@Test
	public void test05() {
		String sql = "select * from quiz";
		PageData<Quiz> pq= jdbcTemplatePager.queryForPage(sql,2,5,quizRowMapper);
		logger.info("startrow:{}, total{},records{},rows{}",pq.getStartRow(),pq.getTotal(),pq.getRecords(),pq.getRows());
	}
}
