<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
    <meta name="viewport" content="width=device-width,initial-scale=1"/>
    <title>QuestionList</title>
    <link rel="stylesheet" href="css/bootstrap.min.css">
    <style type="text/css">
        .table tbody tr td {
            vertical-align: middle;
        }

        .col-centered {
            display: inline-block;
            vertical-align: middle;
        }
    </style>
</head>
<c:set var="rows" value="${pageInfo.getContent()}"/>
<c:set var="pageNum" value="${pageInfo.getNumber()+1}"/>
<c:set var="total" value="${pageInfo.getTotalPages()}"/>

<body>
<div class="container">
    <div class="modal fade" id="QuModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span
                            aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="myModalLabel">New Question </h4>
                </div>
                <form role="form" id="add-form" action="${pageContext.request.contextPath}/admin/addquestion"
                      method="POST">
                    <div class="modal-body">

                        <div class="col-md-12">
                            <div class="form-group">
                                <label for="f1">Category</label>
                                <select id="f1" name="quizType" class="form-control">
                                    <c:forEach items="${qzTypes}" var="qz">
                                        <option value="${qz.getId()}">${qz.getName()}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div class="col-md-12">
                            <div class="form-group">
                                <label for="c1">Question's Description</label>
                                <input type="text" class="form-control" placeholder="Input description for the Category"
                                       name="desc" id="c1">
                            </div>
                        </div>
                        <div class="col-md-12">
                            <div class="form-group">
                                <label>ChoicesList</label>
                            </div>
                        </div>
                        <div class="col-md-12">
                            <div class="form-group">
                                <div class="input-group">
                                    <span class="input-group-addon">a.</span>
                                    <input type="text" class="form-control"
                                           placeholder="Input description for the choice" name="choices">
                                </div>
                            </div>
                        </div>
                        <div class="col-md-12">
                            <div class="form-group">
                                <div class="input-group">
                                    <span class="input-group-addon">b.</span>
                                    <input type="text" class="form-control"
                                           placeholder="Input description for the choice" id="c12" name="choices">
                                </div>
                            </div>
                        </div>
                        <div class="col-md-12">
                            <div class="form-group">

                                <div class="input-group">
                                    <span class="input-group-addon">c.</span>
                                    <input type="text" class="form-control"
                                           placeholder="Input description for the choice" name="choices">
                                </div>
                            </div>
                        </div>
                        <div class="col-md-12">
                            <div class="form-group">
                                <div class="input-group">
                                    <span class="input-group-addon">d.</span>
                                    <input type="text" class="form-control"
                                           placeholder="Input description for the choice" name="choices">
                                </div>
                            </div>
                        </div>
                        <div class="col-md-12">
                            <div class="form-group">
                                <label>Set Answer</label>
                            </div>
                            <div class="form-group form-inline">
                                <label class="radio-inline">
                                    <input type="radio" name="isAnswerOption" value="0"> a
                                </label>
                                <label class="radio-inline">
                                    <input type="radio" name="isAnswerOption" value="1"> b
                                </label>
                                <label class="radio-inline">
                                    <input type="radio" name="isAnswerOption" value="2"> c
                                </label>
                                <label class="radio-inline">
                                    <input type="radio" name="isAnswerOption" value="3"> d
                                </label>
                            </div>
                        </div>

                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-default" data-dismiss="modal"> Close</button>
                        <button type="submit" id="save" class="btn btn-primary">Save</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    <div class="col-md-9">
        <caption><h3>Questions</h3></caption>
        <div style="text-align: right">
            <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#QuModal">
                New Question
            </button>
        </div>

        <table class="table table-striped">
            <thead>
            <tr>
                <th class="col-md-2">Category</th>
                <th class="col-md-1">QuestionId</th>
                <th class="col-md-4">Description</th>
                <th class="col-md-1">Status</th>
                <th class="col-md-2"></th>
            </tr>
            </thead>
            <c:forEach items="${rows}" var="qu">
                <tr>
                    <td class="col-md-2">${qu.getQuizType().getName()}</td>
                    <td class="col-md-1">${qu.getId()}</td>
                    <td class="col-md-4">${qu.getDescription()}</td>
                    <td class="col-md-1">${qu.getStatus()}</td>
                    <td class="col-md-2"><a class="btn btn-default" href="${pageContext.request.contextPath}/admindetail?questionId=${qu.getId()}"
                                            role="button">Edit</a></td>

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
                            <a href="${pageContext.request.contextPath}/adminallquestions?pageNum=${pageNum-1}" aria-label="Previous">
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
                <%-- 计算分页如何排版 --%>
                <c:choose>
                    <%-- 当总页数不足10页，显示所有页数 --%>
                    <c:when test="${total <=10 }">
                        <c:set var="begin" value="1"/>
                        <c:set var="end" value="${total}"/>
                    </c:when>
                    <c:otherwise>
                        <%-- 当总页数大于10页，通过公式计算出begin和end --%>
                        <c:set var="begin" value="${pageNum-5 }"/>
                        <c:set var="end" value="${pageNum +4 }"/>
                        <%-- 头溢出 --%>
                        <c:if test="${begin<1 }">
                            <c:set var="begin" value="1"/>
                            <c:set var="end" value="10"/>
                        </c:if>
                        <%-- 尾溢出 --%>
                        <c:if test="${end > total}">
                            <c:set var="begin" value=" $total-9 }"/>
                            <c:set var="end" value="${total }"/>
                        </c:if>
                    </c:otherwise>
                </c:choose>
                <%-- 循环遍历页码列表 --%>
                <c:forEach var="i" begin="${begin }" end="${end }">
                    <c:choose>
                        <c:when test="${i eq pageNum }">
                            <li class="active"><a href="${pageContext.request.contextPath}/adminallquestions?pageNum=${i }">${i } <span class="sr-only">(current)</span></a>
                            </li>
                        </c:when>
                        <c:otherwise>
                            <li><a href="${pageContext.request.contextPath}/adminallquestions?pageNum=${i }">${i }</a></li>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>
                <li>
                    <c:choose>
                        <c:when test="${pageNum <total }">
                            <a href="${pageContext.request.contextPath}/adminallquestions?pageNum=${pageNum+1 }" aria-label="Next">
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
    // $('#save').submit(function(e) {
    //     e.preventDefault();
    //     $('#QuModal').modal('toggle'); //or  $('#IDModal').modal('hide');
    //     return false;
    // });
</script>
</body>
<script src="js/jquery-1.9.1.js"></script>
<script src="js/bootstrap.min.js"></script>
</html>