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

<body>
<div class="container">
    <div class="modal fade" id="QuModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title" id="myModalLabel">New Question </h4>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form role="form" id="add-form" action="${pageContext.request.contextPath}/admin/addquestion"
                      method="POST">
                    <div class="modal-body">
                        <div class="row gy-3">
                            <div class="col-12">
                                <div class="form-group">
                                    <label for="f1">Category</label>
                                    <select id="f1" name="quizType" class="form-select">
                                        <c:forEach items="${qzTypes}" var="qz">
                                            <option value="${qz.getCategoryId()}">${qz.getCategoryName()}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>
                            <div class="col-12">
                                <div class="form-group">
                                    <label for="c1">Question's Description</label>
                                    <input type="text" class="form-control"
                                           placeholder="Input description for the Category"
                                           name="desc" id="c1">
                                </div>
                            </div>
                            <div class="col-12">
                                <div class="form-group">
                                    <label>ChoicesList</label>
                                </div>
                            </div>
                            <div class="col-12">
                                <div class="form-group">
                                    <div class="input-group">
                                        <span class="input-group-addon">1.</span>
                                        <input type="text" class="form-control"
                                               placeholder="Input description for the choice" name="choices">
                                    </div>
                                </div>
                            </div>
                            <div class="col-12">
                                <div class="form-group">
                                    <div class="input-group">
                                        <span class="input-group-addon">2.</span>
                                        <input type="text" class="form-control"
                                               placeholder="Input description for the choice" id="c12" name="choices">
                                    </div>
                                </div>
                            </div>
                            <div class="col-12">
                                <div class="form-group">
                                    <div class="input-group">
                                        <span class="input-group-addon">3.</span>
                                        <input type="text" class="form-control"
                                               placeholder="Input description for the choice" name="choices">
                                    </div>
                                </div>
                            </div>
                            <div class="col-12">
                                <div class="form-group">
                                    <label>Set Answer</label>
                                </div>


                                <div class="form-group form-inline">
                                    <label class="radio-inline">
                                        <input type="radio" name="isAnswerOption" value="1"> 1
                                    </label>
                                    <label class="radio-inline">
                                        <input type="radio" name="isAnswerOption" value="2"> 2
                                    </label>
                                    <label class="radio-inline">
                                        <input type="radio" name="isAnswerOption" value="3"> 3
                                    </label>

                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-default" data-bs-dismiss="modal"> Close</button>
                        <button type="submit" id="save" class="btn btn-primary">Save</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    <div class="col-md-9">
        <caption><h3>Questions</h3></caption>
        <div style="text-align: right">
            <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#QuModal">
                New Question
            </button>
        </div>

        <table class="table table-striped table-sm">
            <thead>
            <tr>
                <th class="col-md-2">Category</th>
                <th class="col-md-1">QuestionId</th>
                <th class="col-md-4">Description</th>
                <th class="col-md-1">Status</th>
                <th class="col-md-2"></th>
            </tr>
            </thead>
            <c:forEach items="${qList}" var="qu">
                <tr>
                    <td class="col-md-2">${qu.getCategory_id()}</td>
                    <td class="col-md-1">${qu.getQuestion_id()}</td>
                    <td class="col-md-4">${qu.getQuiz_description()}</td>
                    <td class="col-md-1">${qu.getIs_active()}</td>
                    <td class="col-md-2"><a class="btn btn-default"
                                            href="${pageContext.request.contextPath}/admindetail?questionId=${qu.getQuestion_id()}"
                                            role="button">Edit</a></td>

                </tr>
            </c:forEach>
        </table>
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
<script src="js/bootstrap.min.js"></script>
</html>