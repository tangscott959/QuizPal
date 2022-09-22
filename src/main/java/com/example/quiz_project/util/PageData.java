package com.example.quiz_project.util;

import com.example.quiz_project.domain.Quiz;
import org.springframework.data.domain.Page;

import java.util.List;
import java.util.Map;

public class PageData<T> {
    private int			page;
    private int			pageSize;
    private int			total;
    private final int	startRow;
    private int			records;
    private Map<String,Object> parameter;
    private List<T>		rows;

    public PageData(int page, int pageSize) {
        this.page = page;
        this.pageSize = pageSize;
        this.startRow = (page - 1) * pageSize;
    }

    public PageData(int page, int pageSize, Map<String,Object> parameter) {
        this.page = page;
        this.pageSize = pageSize;
        this.parameter = parameter;
        this.startRow = (page - 1) * pageSize;
    }

    public int getPage() {
        return page;
    }

    public void setPage(int page) {
        this.page = page;
    }

    public int getTotal() {
        return total;
    }

    public void setTotal(int total) {
        this.total = total;
    }

    public int getStartRow() {
        return startRow;
    }

    public int getRecords() {
        return records;
    }

    public void setRecords(int records) {
        this.total = ((records - 1) / pageSize) + 1;
        this.records = records;
    }

    public Map<String,Object> getParameter() {
        return parameter;
    }

    public void setParameter(Map<String,Object> parameter) {
        this.parameter = parameter;
    }

    public int getPageSize() {
        return pageSize;
    }

    public void setPageSize(int pageSize) {
        this.pageSize = pageSize;
    }

    public List<T> getRows() {
        return rows;
    }

    public void setRows(List<T> rows) {
        this.rows = rows;
    }

}
