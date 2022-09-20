<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
    <meta name="viewport" content="width=device-width,initial-scale=1"/>
    <title>QuizHistory</title>
    <link rel="stylesheet" href="css/bootstrap.min.css">
    <script src="js/bootstrap.min.js"></script>

    <style type="text/css">
        .table tbody tr td {
            vertical-align: middle;
        }

        th {
            background-color: #42b983;
            color: rgba(255, 255, 255, 0.66);
            cursor: pointer;
        }

        .arrow {
            display: inline-block;
            vertical-align: middle;
            width: 0;
            height: 0;
            margin-left: 5px;
            opacity: 0.66;
        }

        .arrow.asc {
            border-left: 4px solid transparent;
            border-right: 4px solid transparent;
            border-bottom: 4px solid #fff;
        }

        .arrow.dsc {
            border-left: 4px solid transparent;
            border-right: 4px solid transparent;
            border-top: 4px solid #fff;
        }
    </style>
</head>

<body>
<div class="container">
    <div class="col-md-10">
        <h4> Quiz History</h4>
        <div class="row align-items-center">
            <div class="col-3">
                <form action="${pageContext.request.contextPath}/adminquiz?pageNum=1&sortByCategory=0" method="get">
                    <div class="input-group input-group-sm">
                        <label for="Select04" class="col-5 col-form-label col-form-label-sm">Category
                            Filter</label>
                        <select class="form-select form-select-sm" id="Select04" name="sortByCategory" aria-label="filter">
                            <option value="0" selected>ALL</option>
                            <c:forEach items="${category}" var="quiztype">
                                <option value=${quiztype.getCategoryId()}>${quiztype.getCategoryName()}</option>
                            </c:forEach>
                        </select>
                        <button class="btn btn-outline-secondary" type="submit">Apply</button>
                    </div>
                </form>
            </div>
            <div class="col-1"><span> OR </span></div>
            <div class="col-5">
                <form action="${pageContext.request.contextPath}/adminquiz?pageNum=1&sortByCategory=0" method="get">
                    <div class="input-group input-group-sm">
                        <input type="text" name="sortByName" class="form-control" placeholder="username pattern "  aria-label="username" aria-describedby="button-addon2">
                        <button class="btn btn-outline-secondary" type="submit" id="button-addon2">search</button>
                    </div>
                </form>
            </div>
        </div>
        <table class="table table-striped mt-2">
            <thead>
            <tr class="bg-info">
                <th class="col-2">UserName<span class="arrow asc"></span></th>
                <th class="col-2">Category<span class="arrow asc"></span></th>
                <th class="col-2">QuizName<span class="arrow asc"></span></th>
                <th class="col-2">StartTime</th>
                <th class="col-2">EndTime</th>
                <th class="col-1">Score</th>
                <th class="col-1">Details</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach items="${qrtList}" var="result">
                <tr>
                    <td class="col-2">${result.getUserName()}</td>
                    <td class="col-2">${result.getCategory()}</td>
                    <td class="col-2">${result.getQuizName()}</td>
                    <td class="col-2"><fmt:formatDate value="${result.getStartTime()}" type="date"
                                                      pattern="yyyy-MM-dd HH:mm"/></td>
                    <td class="col-2"><fmt:formatDate value="${result.getEndTime()}" type="date"
                                                         pattern="yyyy-MM-dd HH:mm"/></td>
                    <td class="col-1">${result.getScore()}</td>
                    <td class="col-1"><a class="btn btn-default"
                                            href="${pageContext.request.contextPath}/adminresultdetail?resultId=${result.getQuizId()}"
                                            role="button">Detail</a></td>

                </tr>
            </c:forEach>
            </tbody>
            <tfoot>
                Total: ${qrtList.size()}
            </tfoot>
        </table>
    </div>
</div>
<script type="text/javascript">

</script>
</body>
</html>