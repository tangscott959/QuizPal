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

        .top-buffer {
            margin-top: 20px;
        }
    </style>

</head>

<body>
<div class="container">

    <div class="modal fade" id="quModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-bs-dismiss="modal" aria-label="Close"><span
                            aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="myModalLabel">New Category </h4>
                </div>
                <form action="${pageContext.request.contextPath}/admin/addcategory" method="POST">
                    <div class="modal-body">
                        <label for="c1">Name</label>
                        <input type="text" class="form-control" placeholder="Input Name for the Category" name="name"
                               id="c1">
                        <label for="c2">Description</label>
                        <input type="text" class="form-control" placeholder="Input description for the Category"
                               name="desc" id="c2">

                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-default" data-bs-dismiss="modal">Close</button>
                        <button id="save" type="submit" class="btn btn-primary">Save changes</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    <div class="row condition-bar top-buffer">
        <form action="${pageContext.request.contextPath}/admin/updatequestion" method="POST">
            <div class="col-5">
                <input type="hidden" name="Id" value="${detailInfo.getQuestion_id()}"/>
                <div class="form-group">
                    <label for="f1">Category</label>
                    <select id="f1" name="quizType" class="form-select">
                        <c:forEach items="${qzTypes}" var="qz">
                            <option value="${qz.getCategoryId()}" ${detailInfo.getCategory_id() == qz.getCategoryId() ? "selected=\"selected\"" : ""}>${qz.getCategoryName()}</option>
                        </c:forEach>
                    </select>
                </div>
            </div>
            <div class="col-12">
                <div class="form-group">
                    <label for="f2">Description</label>
                    <input type="text" id="f2" name="desc" class="form-control"
                           value="${detailInfo.getQuiz_description()}"/>
                </div>
            </div>
            <div class="col-8">
                <div class="form-group">
                    <label>Choice</label>
                    <div class="form-check">
                        <input class="form-check-input" type="radio" name="isAnswerOption" id="r1" value="${choices.get(0).getChoice_id()}"
                        ${choices.get(0).getIs_correct() == 1  ? "checked=\"checked\"" : ""}>
                        <label class="form-check-label" for="r1">
                            a. ${choices.get(0).getChoice_description()}
                        </label>
                    </div>
                    <div class="form-check">
                        <input class="form-check-input" type="radio" name="isAnswerOption" id="r2" value="${choices.get(1).getChoice_id()}"
                        ${choices.get(1).getIs_correct()  == 1  ? "checked=\"checked\"" : ""}>
                        <label class="form-check-label" for="r2">
                            b. ${choices.get(1).getChoice_description()}
                        </label>
                    </div>
                    <div class="form-check">
                        <input class="form-check-input" type="radio" name="isAnswerOption" id="r3" value="${choices.get(2).getChoice_id()}"
                        ${choices.get(2).getIs_correct() == 1  ? "checked=\"checked\"" : ""}>
                        <label class="form-check-label" for="r3">
                            c. ${choices.get(2).getChoice_description()}
                        </label>
                    </div>
                </div>

            </div>
            <div class="col-12">
                <div class="form-group">
                    <label for="f2" >Status</label>
                    <label class="radio-inline">
                        <input type="radio" name="status" value="1" ${detailInfo.getIs_active() == 1 ? "checked=\"checked\"" : ""}>Active
                    </label>
                    <label class="radio-inline">
                        <input type="radio" name="status" value="0" ${detailInfo.getIs_active() == 0 ? "checked=\"checked\"" : ""}>Disable
                    </label>
                </div>
            </div>
            <div class="row">
                <div class="col-3">
                    <a href="#" class="btn btn-default" onClick="javascript:window.history.back();return false;">Close</a>
                </div>
                <div class="col-3">
                    <button class="btn btn-info" type="submit">Save</button>
                </div>
            </div>
        </form>
    </div>
</div>
<script type="text/javascript">

</script>

<script src="js/bootstrap.min.js"></script>
</body>
</html>
