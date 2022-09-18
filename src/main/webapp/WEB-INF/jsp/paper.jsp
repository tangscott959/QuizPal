<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>papers</title>

    <style>
        li {
            margin-top: 5px;
            margin-bottom: 10px;
            padding-left: 5px
        }

        p {
            margin-left: 15px;
            margin-top: 20px;
            font-size: 20px;
        }

        label:hover {
            background: SeaShell;
            color: OrangeRed
        }

        .questionbox {
            BORDER-RIGHT: 3px inset;
            BORDER-TOP: 3px inset;
            BORDER-LEFT: 3px inset;
            WIDTH: 90%;
            BORDER-BOTTOM: 3px inset;
            HEIGHT: 80%
        }
    </style>
</head>
<body onload=setTimer(${leftTime})>

<div class="container">
    <div class="row">
        <div class="col-md-4">
            <h1>
                Question ${currentPage+1} / ${pageSize}
            </h1>
        </div>
        <div class="col-md-8 text-right text-warning">
            <h3>Time Left <span id="leftTime"></span></h3>
        </div>

        <form action="${pageContext.request.contextPath}/questions" method="GET">
            <div class="col-md-12 questionbox">
                <h2>${questionAnswer.getQuestion().getDescription()}</h2>
                <input type="hidden" name="qtid" value="0"/>
                <input id="Timer" type="hidden" name="lefttime" value="0"/>
                <input type="hidden" name="page" value="${currentPage}"/>
                <c:forEach var="choice" items="${questionAnswer.getOptions().entrySet()}">
                    <p><input type="radio" class="form-check-input" name="optradio" id=O${choice.getKey()}
                              value="${choice.getKey()}"
                        ${questionAnswer.getUserSelection() == choice.getKey()  ? "checked=\"checked\"" : ""} >
                        <label for="O${choice.getKey()}">
                                ${choice.getKey()}.${choice.getValue()}
                        </label>
                    </p>
                </c:forEach>
                <div style="margin-top: 20px ;margin-left: 20px" class="btn-group btn-group-lg">
                    <c:if test="${currentPage != 0}">
                        <button name="action" value="prev" class="btn btn-Info " type="submit">Prev</button>
                    </c:if>
                    <c:if test="${currentPage != pageSize -1}">
                        <button name="action" value="next" class="btn btn-Info " type="submit">Next</button>
                    </c:if>
                    <c:if test="${currentPage == pageSize -1}">
                        <button name="action" value="finish" class="btn btn-Info " type="submit">Finish</button>
                        <!-- a style="margin-left: 20px" class="btn btn-default btn-Success" href="${pageContext.request.contextPath}/finish">Finish</a -->
                    </c:if>
                </div>
            </div>
        </form>
    </div>
</div>
<script type="text/javascript">

    function  setTimer(leftSeconds) {
        $("#leftTime").text(Math.trunc(leftSeconds/60).toString() + ":" + (leftSeconds%60).toString());
        window.setInterval(function () {
            leftSeconds = leftSeconds - 5;
            if ( leftSeconds === 0) {
                alert("Time is Over")
            }
            $("#leftTime").text(Math.trunc(leftSeconds/60).toString() + ":" + (leftSeconds%60).toString());
            $("#Timer").val(leftSeconds);
        }, 5000);
    }
</script>
</body>
</html>

