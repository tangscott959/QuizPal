<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=Edge" />
    <meta name="viewport" content="width=device-width,initial-scale=1" />
    <title>QuizHistory</title>
    <link rel="stylesheet" href="css/bootstrap.min.css">
    <script src="js/bootstrap.min.js"></script>

    <style type="text/css">
        .table tbody tr td{
            vertical-align: middle;
        }
        th {
            background-color: #42b983;
            color: rgba(255,255,255,0.66);
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
<c:set var="rows" value="${resultList.getContent()}"/>
<c:set var="pageNum" value="${resultList.getNumber()+1}"/>
<c:set var="total" value="${resultList.getTotalPages()}"/>

<body>
<div class="container">
    <div class="col-md-9">
        <table class="table table-striped">
            <caption><h3> Quiz History</h3></caption>
            <thead>
            <tr>
                <th id="thname" class="col-md-4">FullName<span class="arrow asc"></span></th>
                <th id="thcat" class="col-md-4">Category<span class="arrow asc"></span></th>
                <th id="thdate" class="col-md-3">Taken_Date</th>
                <th class="col-md-1">QuestionId</th>
                <th class="col-md-1">Score</th>
                <th class="col-md-1"></th>
            </tr>
            </thead>
            <c:forEach items="${rows}" var="result">
                <tr>
                    <td class="col-md-4">${result.getUser().getName()}</td>
                    <td class="col-md-4">${result.getQuestion().getQuizType().getDescription()}</td>
                    <td class="col-md-3"><fmt:formatDate value="${result.getTakenDate()}" type="date" pattern="yyyy-MM-dd"/></td>
                    <td class="col-md-1">${result.getQuestion().getId()}</td>
                    <td class="col-md-1">NA.</td>
                    <td class="col-md-2"><a class="btn btn-default" href="${pageContext.request.contextPath}/quizdetail?resultId=${result.getId()}" role="button">Detail</a></td>

                </tr>
            </c:forEach>
        </table>
    </div>
    <div class="col-md-12">
        <nav aria-label="Page navigation">
            <ul class="pagination">
                <li>
                    <c:choose>
                        <c:when test="${pageNum >1}">
                            <a href="${pageContext.request.contextPath}/adminquiz?pageNum=${pageNum-1}" aria-label="Previous">
                                <span>&laquo;</span>
                            </a>
                        </c:when>
                        <c:otherwise>
                            <a href="javascript:void(0)" disabled="disabled" aria-label="Previous">
                                <span aria-hidden="true">&laquo;</span>
                            </a>
                        </c:otherwise>
                    </c:choose>
                </li>

                <c:choose>
                    <c:when test="${total <=10 }">
                        <c:set var="begin" value="1"/>
                        <c:set var="end" value="${total}"/>
                    </c:when>
                    <c:otherwise>
                        <c:set var="begin" value="${pageNum-5 }"/>
                        <c:set var="end" value="${pageNum +4 }"/>

                        <c:if test="${begin<1 }">
                            <c:set var="begin" value="1"/>
                            <c:set var="end" value="10"/>
                        </c:if>

                        <c:if test="${end > total}">
                            <c:set var="begin" value=" $total-9 }"/>
                            <c:set var="end" value="${total }"/>
                        </c:if>
                    </c:otherwise>
                </c:choose>

                <c:forEach var="i" begin="${begin }" end="${end }">
                    <c:choose>
                        <c:when test="${i eq pageNum }">
                            <li class="active"><a href="${pageContext.request.contextPath}/adminquiz?pageNum=${i }">${i } <span class="sr-only">(current)</span></a></li>
                        </c:when>
                        <c:otherwise>
                            <li><a href="${pageContext.request.contextPath}/adminquiz?pageNum=${i }">${i }</a></li>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>
                <li>
                    <c:choose>
                        <c:when test="${pageNum <total }">
                            <a href="${pageContext.request.contextPath}/adminquiz?pageNum=${pageNum+1 }" aria-label="Next">
                                <span>&raquo;</span>
                            </a>
                        </c:when>
                        <c:otherwise>
                            <a href="javascript:void(0)" disabled="disabled" aria-label="Next">
                                <span aria-hidden="true">&raquo;</span>
                            </a>
                        </c:otherwise>
                    </c:choose>
                </li>
            </ul>
        </nav>
    </div>
</div>
<script type="text/javascript">
    function show(data){
        if(data==null||data.length==0){
            window.location.href="${pageContext.request.contextPath}/adminquiz?pageNum=1"
        }
    }
    $("#thname").click(function (){
        window.location.href ="${pageContext.request.contextPath}/adminquiz?pageNum=1&sortByName=1"
    })
    $("#thcat").click(function (){
        window.location.href ="${pageContext.request.contextPath}/adminquiz?pageNum=1&sortByCategory=1"
    })
    $("#thdate").click(function (){
        window.location.href ="${pageContext.request.contextPath}/adminquiz?pageNum=1"
    })
</script>
</body>
</html>