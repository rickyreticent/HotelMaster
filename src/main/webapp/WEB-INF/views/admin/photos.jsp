<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>

<div class="container adminContainer">
    <style>
        .borderlessInput {
            border: none;
            background-color: transparent;
            font-family: inherit;
            font-size: inherit;
        }

    </style>
    <script>
        $('table td tr input').click(
        function(e) {
            e.preventDefault(); // prevent the default action
            e.stopPropagation(); // stop the click from bubbling
            $(this).closest('input').find('.borderlessInput').removeClass('borderlessInput');
            $(this).parent().addClass('borderlessInput');
        });
    </script>

    <h1 class="text-center">Photo Manager</h1>

    <div>
        <table class="table table-striped">
            <thead>
                <tr>
                    <th>Room ID</th> 
                    <th>Room Name</th>
                    <th>Images</th>
                </tr>
            </thead>
            <c:forEach var="room" items="${roomList}" varStatus="status">
                <tr>
                    <td><c:out value="${room.roomID}"/></td>
                    <td><c:out value="${room.roomName}"/></td>
                    <td><button type="button" class="btn btn-info btn-lg" data-toggle="modal" data-target="#${room.roomID}">View</button></td>
                </tr>
                <!-- Modal -->
                <div class="modal fade" id="${room.roomID}" role="dialog">
                    <div class="modal-dialog modal-lg">
                        <div class="modal-content">
                            <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal">&times;</button>
                                <h4 class="modal-title">${room.roomName} Photos</h4>
                            </div>
                            <div class="modal-body container-fluid">
                                <c:set var="checkCounter" value="${0}"/>
                                <form:form id="addImageForm" action="/admin/photos/add" modelAttribute="photoBucket" method="POST" enctype="multipart/form-data">
                                    <div class="container-fluid">
                                    <label id="uploadBtn" class="text-center btn-primary">
                                        <i class="fa fa-plus-square-o" aria-hidden="true"></i>
                                        <input id="room${room.roomID}" type="file" path="file" name="file" class="file" size="50" />
                                    </label>
                                    </div>
                                    <input type="text" path="title" name="title" value="${room.roomName}" class="hidden"/>
                                    <input type="text" path="roomID" name="roomID" value="${room.roomID}" class="hidden"/>
                                </form:form>
                                <script type="text/javascript">                                   
                                    document.getElementById("room${room.roomID}").onchange = function() {
                                        document.getElementById("room${room.roomID}").form.submit();
                                    };
                                </script>
                                <h2 class="container-fluid text-center muted" id="title${room.roomID}">List of Photos</h2>
                                <div class="container-fluid">
                                    <c:forEach var="photo" items="${photoList}" varStatus="counter">
                                        <c:if test="${room.roomID eq photo.roomID}" >
                                            <div class="row photoRow">
                                                <div class="col-sm-6">
                                                    <img style="width: 100%;" src="/getPhoto?ID=${photo.imageID}" alt="placeholder">
                                                </div>
                                                <div class="col-sm-6">
                                                    <h3 class="text-center"><c:out value="${photo.title}"/></h3>
                                                    <div class="button-group photoButtonGroup">
                                                        <form:form action="/admin/photos/update" modelAttribute="photoBucket" method="POST" enctype="multipart/form-data">
                                                            <input type="number" value="${photo.imageID}" name="imageID" class="hidden"/>
                                                            <input type="number" value="${room.roomID}" name="roomID" class="hidden"/>
                                                            <c:choose>
                                                                <c:when test="${photo.getPrimary() == 1}">
                                                                    <button id="btnPrimaryImage" type="submit" class="btn btn-primary" name="action" value="setPrimary" disabled>Primary</button>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <button id="btnPrimaryImage" type="submit" class="btn btn-success" name="action" value="setPrimary">Set Primary</button>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </form:form>
                                                        <form:form action="/admin/photos/delete" modelAttribute="photoBucket" method="POST" enctype="multipart/form-data">
                                                            <input type="number" value="${photo.imageID}" name="imageID" class="hidden"/>
                                                            <button id="delete${room.roomID}" type="submit" class="btn btn-danger" name="action" value="delete">Delete</button>  
                                                        </form:form>
                                                    </div>
                                                </div>
                                            </div>
                                            <c:set var="checkCounter" value="${checkCounter + 1}"/>
                                        </c:if>
                                    </c:forEach>
                                    <c:if test="${checkCounter == 1}">
                                        <script type="text/javascript">                                   
                                            $('#delete${room.roomID}').prop("disabled", true);
                                        </script>
                                    </c:if>
                                    <c:if test="${checkCounter < 1}">
                                        <h1 class="text-center">Please Add Photos</h1>
                                        <script type="text/javascript">                                   
                                            $('#title${room.roomID}').addClass('hidden');
                                        </script>
                                    </c:if>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </table>
    </div>
    
</div>
