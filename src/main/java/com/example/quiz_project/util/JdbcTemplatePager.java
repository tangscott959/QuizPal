package com.example.quiz_project.util;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.PreparedStatementSetter;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;

import javax.sql.DataSource;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
@Component
public class JdbcTemplatePager extends JdbcTemplate {
    public JdbcTemplatePager() {
    }
@Autowired
    public JdbcTemplatePager(DataSource dataSource) {
        super(dataSource);
    }

    public JdbcTemplatePager(DataSource dataSource, boolean lazyInit) {
        super(dataSource, lazyInit);
    }

    public <T> PageData<T> queryForPage(String sql, int page,int pageSize, RowMapper<T> rowMapper) throws DataAccessException {

        return queryForPage(sql, page,pageSize, new PreparedStatementSetter() {
            public void setValues(PreparedStatement preparedStatement) throws SQLException {
            }
        }, rowMapper);
    }


    public <T> PageData<T> queryForPage(String sql, int page, int pageSize,PreparedStatementSetter var2, RowMapper<T> var3) throws DataAccessException {

        PageData<T> result = new PageData<T>(page,pageSize);

        //获取记录条数
        String countSql = "select count(1) as count from (" + sql + ") temp";

        List<Integer> countList = super.query(countSql, var2, new RowMapper<Integer>() {
            public Integer mapRow(ResultSet resultSet, int i) throws SQLException {
                return resultSet.getInt("count");
            }
        });
        result.setRecords(countList.get(0));
        sql += parseLimit(result);

        List<T> data = super.query(sql, var2, var3);
        result.setRows(data);
        return result;
    }
    private <T> String parseLimit(PageData<T> pagination) {
        StringBuilder stringBuffer = new StringBuilder();
        stringBuffer.append(" ");
        stringBuffer.append("limit");
        stringBuffer.append(" ");
        if (pagination.getPage() == 0) {
            stringBuffer.append("0");
        } else {
            stringBuffer.append((pagination.getPage() - 1) * pagination.getPageSize());
        }
        stringBuffer.append(",");
        stringBuffer.append(pagination.getPageSize());

        return stringBuffer.toString();
    }
}