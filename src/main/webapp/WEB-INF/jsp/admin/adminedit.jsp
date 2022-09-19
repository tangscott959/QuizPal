<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>

<!DOCTYPE html>
<html>
<head>
    <title>QuizEditor</title>
    <link rel="stylesheet" href="css/bootstrap.min.css">
    <style>
        .condition-bar {
            border: 1px solid rgb(225, 225, 225);
            border-bottom-width: 0;
            padding: 10px 10px;
            background-color: rgb(241, 241, 241);
        }
        .top-buffer { margin-top:20px; }
    </style>

</head>

<body>
<div class="container">

    <div class="modal fade" id="quModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="myModalLabel">New Category </h4>
                </div>
                <form action="${pageContext.request.contextPath}/admin/addcategory" method="POST">
                <div class="modal-body">
                    <label for="c1">Name</label>
                    <input type="text" class="form-control" placeholder="Input Name for the Category" name="name" id="c1">
                    <label for="c2">Description</label>
                    <input type="text" class="form-control" placeholder="Input description for the Category" name="desc" id="c2">

                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                    <button id="save" type="submit" class="btn btn-primary">Save changes</button>
                </div>
                </form>
            </div>
        </div>
    </div>
    <div class="row condition-bar top-buffer">
        <form action="${pageContext.request.contextPath}/admin/updatequestion"  method="POST">
                <div class="col-md-5">
                    <input  type="hidden" name="Id" value="${detailInfo.getId()}" />
                    <div class="form-group">
                        <label for="f1">Category</label>
                        <select id="f1" name="quizType" class="form-control">
                            <c:forEach items="${qzTypes}" var="qz">
                                <option value="${qz.getId()}" ${detailInfo.getQuizType().getId() == qz.getId() ? "selected=\"selected\"" : ""}>${qz.getName()}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>
                <!-- <div class="col-md-3" style="margin-top: 24px">
                    <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#quModal">
                        New Category
                    </button>
                </div>-->
                <div class="col-md-12">
                    <div class="form-group">
                        <label for="f2" >Description</label>
                        <input type="text" id="f2" name="desc" class="form-control" value="${detailInfo.getDescription()}"/>
                    </div>
                </div>
                <div class="col-md-8">
                    <div class="form-group">
                        <label>Choice</label>
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="isAnswerOption" id="r1" value="0"
                            ${detailInfo.getChoice().get(0).getIsAnswer() == 1  ? "checked=\"checked\"" : ""}>
                            <label class="form-check-label" for="r1">
                                a. ${detailInfo.getChoice().get(0).getDescription()}
                            </label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="isAnswerOption" id="r2" value="1"
                            ${detailInfo.getChoice().get(1).getIsAnswer() == 1  ? "checked=\"checked\"" : ""}>
                            <label class="form-check-label" for="r2">
                                b. ${detailInfo.getChoice().get(1).getDescription()}
                            </label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="isAnswerOption" id="r3" value="2"
                            ${detailInfo.getChoice().get(2).getIsAnswer() == 1  ? "checked=\"checked\"" : ""}>
                            <label class="form-check-label" for="r3">
                                c. ${detailInfo.getChoice().get(2).getDescription()}
                            </label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="isAnswerOption" id="r4" value="3"
                            ${detailInfo.getChoice().get(3).getIsAnswer() == 1  ? "checked=\"checked\"" : ""}>
                            <label class="form-check-label" for="r4">
                                d. ${detailInfo.getChoice().get(3).getDescription()}
                            </label>
                        </div>
                    </div>

                </div>
                <div class="col-md-12">
                    <div class="form-group">
                        <label for="f2" >Status</label>
                        <label class="radio-inline">
                            <input type="radio" name="status" value="1" ${detailInfo.getStatus() == 1 ? "checked=\"checked\"" : ""}>Active
                        </label>
                        <label class="radio-inline">
                            <input type="radio" name="status" value="0" ${detailInfo.getStatus() == 0 ? "checked=\"checked\"" : ""}>Disable
                        </label>
                    </div>
                </div>
            <div class="col-md-3">
                <a href="#"  class="btn btn-default" onClick="javascript:window.history.back();return false;">Close</a>
            </div>
            <div class="col-md-3">
                <button class="btn btn-info" type="submit">Save</button>
            </div>
        </form>
    </div>
</div>
<script type="text/javascript">
    $('#save').submit(function(e) {
        e.preventDefault();
        $('#quModal').modal('toggle'); //or  $('#IDModal').modal('hide');
        return false;
    });
</script>

<script src="js/jquery-1.9.1.js"></script>
<script src="js/bootstrap.min.js"></script>
</body>
</html>
